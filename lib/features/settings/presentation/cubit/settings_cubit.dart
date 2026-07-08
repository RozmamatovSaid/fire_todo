import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/features/home/domain/repository/category_repository.dart';
import 'package:fire_todo/features/home/domain/repository/task_repository.dart';
import 'package:fire_todo/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:fire_todo/features/home/presentation/bloc/tasks/task_bloc.dart';
import 'package:fire_todo/shared/global/domain/entity/category_entity.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final TaskBloc taskBloc;
  final CategoryBloc categoryBloc;
  final CategoryRepository categoryRepository;
  final TaskRepository taskRepository;

  SettingsCubit({
    required this.taskBloc,
    required this.categoryBloc,
    required this.categoryRepository,
    required this.taskRepository,
  }) : super(const SettingsState(
          username: '',
          joinDate: '',
          notificationEnabled: true,
        ));

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('user_name') ?? 'User';
    
    var joinDate = prefs.getString('join_date');
    if (joinDate == null) {
      joinDate = DateFormat('d,MMMM,yyyy').format(DateTime.now()).toLowerCase();
      await prefs.setString('join_date', joinDate);
    }
    
    final notificationEnabled = prefs.getBool('notifications_enabled') ?? true;
    
    emit(SettingsState(
      username: username,
      joinDate: joinDate,
      notificationEnabled: notificationEnabled,
    ));
  }

  Future<void> updateUsername(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    emit(state.copyWith(username: newName));
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    emit(state.copyWith(notificationEnabled: value));
  }

  Future<void> exportData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final categoriesResult = await categoryRepository.getAllCategories();
      final tasksResult = await taskRepository.getAllTasks();

      final categories = categoriesResult.getOrElse(() => []);
      final tasks = tasksResult.getOrElse(() => []);

      final exportMap = {
        'categories': categories.map((c) => {
          'id': c.id,
          'name': c.name,
        }).toList(),
        'tasks': tasks.map((t) => {
          'title': t.title,
          'description': t.description,
          'categoryId': t.categoryId,
          'priority': t.priority.index,
          'check': t.check,
          'notify': t.notify,
          'createdAt': t.createdAt.toIso8601String(),
          'dueAt': t.dueAt?.toIso8601String(),
          'orderIndex': t.orderIndex,
        }).toList(),
      };

      final jsonStr = jsonEncode(exportMap);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/tasks_backup.json');
      await tempFile.writeAsString(jsonStr);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path)],
          text: 'FIRE TODO backup',
        ),
      );

      emit(state.copyWith(
        isLoading: false,
        successMessage: AppStrings.dataExported,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  Future<void> importData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final file = File(result.files.single.path!);
      final jsonStr = await file.readAsString();
      final Map<String, dynamic> importMap = jsonDecode(jsonStr);

      if (!importMap.containsKey('categories') || !importMap.containsKey('tasks')) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.invalidData,
        ));
        return;
      }

      final List<dynamic> importedCatsRaw = importMap['categories'];
      final List<dynamic> importedTasksRaw = importMap['tasks'];

      final currentCatsResult = await categoryRepository.getAllCategories();
      final currentCats = currentCatsResult.getOrElse(() => []);

      final Map<int, int> categoryIdMap = {};

      for (final catRaw in importedCatsRaw) {
        final id = catRaw['id'] as int;
        final name = catRaw['name'] as String;

        final existingCat = currentCats.firstWhere(
          (c) => c.name.toLowerCase() == name.toLowerCase(),
          orElse: () => CategoryEntity(id: -1, name: ''),
        );

        if (existingCat.id != -1) {
          categoryIdMap[id] = existingCat.id;
        } else {
          await categoryRepository.addCategory(name);
          final updatedCatsResult = await categoryRepository.getAllCategories();
          final updatedCats = updatedCatsResult.getOrElse(() => []);
          final newCat = updatedCats.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
          categoryIdMap[id] = newCat.id;
        }
      }

      for (final taskRaw in importedTasksRaw) {
        final oldCategoryId = taskRaw['categoryId'] as int;
        final newCategoryId = categoryIdMap[oldCategoryId] ?? oldCategoryId;

        final task = TaskEntity(
          title: taskRaw['title'] as String,
          description: taskRaw['description'] as String?,
          categoryId: newCategoryId,
          priority: TaskPriority.values[taskRaw['priority'] as int],
          check: taskRaw['check'] as bool,
          notify: taskRaw['notify'] as bool,
          createdAt: DateTime.parse(taskRaw['createdAt'] as String),
          dueAt: taskRaw['dueAt'] != null ? DateTime.parse(taskRaw['dueAt'] as String) : null,
          orderIndex: taskRaw['orderIndex'] as int? ?? 0,
        );

        await taskRepository.addTask(task);
      }

      categoryBloc.add(GetAllCategoriesEvent());
      taskBloc.add(GetAllTasksEvent());

      emit(state.copyWith(
        isLoading: false,
        successMessage: AppStrings.dataImported,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }
}
