import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:fire_todo/features/home/domain/repository/task_repository.dart';

class GetAllTasksUsecase {
  GetAllTasksUsecase({required this.repo});

  final TaskRepository repo;

  Future<Either<Failure, List<TaskEntity>>> call() async {
    return await repo.getAllTasks();
  }
}
