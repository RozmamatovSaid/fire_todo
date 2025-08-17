import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/core/error/local_failures.dart';
import 'package:fire_todo/shared/global/data/model/task_model.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:fire_todo/features/home/domain/repository/task_repository.dart';
import '../../../../shared/global/data/datasource/task_local_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required this.localDataSource});
  final TaskLocalDatasource localDataSource;

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    try {
      final model = TaskModel.fromEntity(task);
      await localDataSource.addTask(model);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure("Task qo‘shishda xatolik: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(int id) async {
    try {
      await localDataSource.deleteTask(id);

      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure("Task o'chirishda xatolik $e"));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    try {
      final taskModels = await localDataSource.getAllTasks();
      final taskEntities = taskModels.map((model) => model.toEntity()).toList();
      return Right(taskEntities);
    } catch (e) {
      return Left(LocalDatabaseFailure("Tasklarni olishda xatolik : $e"));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByCategory(
    int categoryId,
  ) async {
    try {
      final taskModels = await localDataSource.getTasksByCategory(categoryId);
      final taskEntities = taskModels.map((model) => model.toEntity()).toList();
      return Right(taskEntities);
    } catch (e) {
      return Left(
        LocalDatabaseFailure("Category bo'yicha sortlashda xatolik: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(
    DateTime date,
  ) async {
    try {
      final taskModels = await localDataSource.getTasksByDate(date);
      final taskEntities = taskModels.map((model) => model.toEntity()).toList();
      return Right(taskEntities);
    } catch (e) {
      return Left(LocalDatabaseFailure("Sana bo'yicha sortlashda xatolik: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.updateTask(taskModel);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }
}
