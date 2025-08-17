import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/features/home/domain/repository/task_repository.dart';

class DeleteTaskUsecase {
  DeleteTaskUsecase({required this.repo});
  final TaskRepository repo;

  Future<Either<Failure, void>> call(int id) async {
    return await repo.deleteTask(id);
  }
}
