import 'package:bloc/bloc.dart';
import 'package:fire_todo/features/home/domain/usecase/task/add_task.dart';
import 'package:fire_todo/features/home/domain/usecase/task/delete_task.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_all_tasks.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_tasks_by_category.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_tasks_by_date.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import '../../../domain/usecase/task/update_task.dart';

part 'task_state.dart';
part "task_event.dart";

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTaskUsecase addTask;
  final DeleteTaskUsecase deleteTask;
  final GetAllTasksUsecase getAllTasks;
  final GetTasksByCategoryIdUsecase getByCategoryId;
  final GetTasksByDateUsecase getByDate;
  final UpdateTaskUsecase updateTask;

  int? _lastLoadedCategoryId;

  TaskBloc({
    required this.addTask,
    required this.deleteTask,
    required this.getAllTasks,
    required this.getByCategoryId,
    required this.getByDate,
    required this.updateTask,
  }) : super(const TaskInitialState()) {
    on<AddTaskEvent>((event, emit) async {
      emit(const TaskLoadingState());
      await addTask(event.taskEntity);

      if (_lastLoadedCategoryId != null) {
        final result = await getByCategoryId(_lastLoadedCategoryId!);
        result.fold(
          (failure) => emit(TaskFailureState(message: failure.message)),
          (tasks) => emit(TasksLoadedState(taskEntity: tasks)),
        );
      } else {
        await _loadTasks(emit);
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      emit(const TaskLoadingState());
      await deleteTask(event.taskId);

      if (_lastLoadedCategoryId != null) {
        final result = await getByCategoryId(_lastLoadedCategoryId!);
        result.fold(
          (failure) => emit(TaskFailureState(message: failure.message)),
          (tasks) => emit(TasksLoadedState(taskEntity: tasks)),
        );
      } else {
        await _loadTasks(emit);
      }
    });

    on<GetAllTasksEvent>((event, emit) async {
      emit(const TaskLoadingState());
      _lastLoadedCategoryId = null;
      await _loadTasks(emit);
    });

    on<GetTasksByCategoryEvent>((event, emit) async {
      emit(const TaskLoadingState());
      _lastLoadedCategoryId = event.categoryId;

      final result = await getByCategoryId(event.categoryId);
      result.fold(
        (failure) => emit(TaskFailureState(message: failure.message)),
        (tasks) => emit(TasksLoadedState(taskEntity: tasks)),
      );
    });

    on<GetTasksByDateEvent>((event, emit) async {
      emit(const TaskLoadingState());
      _lastLoadedCategoryId = null;

      final result = await getByDate(event.date);
      result.fold(
        (failure) => emit(TaskFailureState(message: failure.message)),
        (tasks) => emit(TasksLoadedState(taskEntity: tasks)),
      );
    });

    on<ClearTasksEvent>((event, emit) async {
      emit(const TasksLoadedState(taskEntity: []));
      _lastLoadedCategoryId = null;
      print('Tasks cleared - no categories available');
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(const TaskLoadingState());

      await updateTask(event.taskEntity);

      if (_lastLoadedCategoryId != null) {
        final result = await getByCategoryId(_lastLoadedCategoryId!);
        result.fold(
          (failure) => emit(TaskFailureState(message: failure.message)),
          (tasks) => emit(TasksLoadedState(taskEntity: tasks)),
        );
      } else {
        await _loadTasks(emit);
      }
    });
  }

  Future<void> _loadTasks(Emitter<TaskState> emit) async {
    final result = await getAllTasks();
    result.fold(
      (failure) => emit(TaskFailureState(message: failure.message)),
      (tasks) => emit(TasksLoadedState(taskEntity: tasks)),
    );
  }
}
