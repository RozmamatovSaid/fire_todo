import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, void>> addTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(int id);
  Future<Either<Failure, List<TaskEntity>>> getAllTasks();
  Future<Either<Failure, List<TaskEntity>>> getTasksByCategory(int categoryId);
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(DateTime date);
  Future<Either<Failure, void>> updateTask(TaskEntity task);
}
