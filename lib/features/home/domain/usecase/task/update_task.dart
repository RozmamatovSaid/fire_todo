
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../shared/global/domain/entity/task_entity.dart';
import '../../repository/task_repository.dart';

class UpdateTaskUsecase {
  final TaskRepository repo;
  
  UpdateTaskUsecase({required this.repo});
  
  Future<Either<Failure, void>> call(TaskEntity task) async {
    return await repo.updateTask(task);
  }
}
