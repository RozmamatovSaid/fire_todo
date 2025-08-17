import 'package:fire_todo/core/services/database_service.dart';
import 'package:fire_todo/shared/global/data/model/category_model.dart';
import 'package:fire_todo/shared/global/data/model/task_model.dart';
import 'package:isar/isar.dart';

// Abstract interface
abstract class CategoryLocalDataSource {
  Future<void> init();
  Future<void> addCategory(String name);
  Future<void> deleteCategory(int id);
  Future<List<CategoryModel>> getAllCategories();
}

// impl
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  // kategoryalarni init qilish
  @override
  Future<void> init() async {
    await IsarService.getInstance();
  }

  // kategorya qoshish
  @override
  Future<void> addCategory(String name) async {
    final _isar = await IsarService.getInstance();
    final category = CategoryModel()..name = name;
    await _isar.writeTxn(() => _isar.categoryModels.put(category));
  }

  @override
  Future<void> deleteCategory(int id) async {
    final _isar = await IsarService.getInstance();

    await _isar.writeTxn(() async {
      // shu category'ga tegishli barcha tasklarni topish
      final tasksToDelete = await _isar.taskModels
          .filter()
          .categoryIdEqualTo(id)
          .findAll();

      // Barcha tasklarni o'chirish
      for (final task in tasksToDelete) {
        await _isar.taskModels.delete(task.id);
      }

      //  categoryni ham ochiramiz
      await _isar.categoryModels.delete(id);
    });
  }

  // kategoryalarni olish
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final _isar = await IsarService.getInstance();
    return await _isar.categoryModels.where().findAll();
  }
}
