import 'package:dartz/dartz.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import '../../../../core/error/failure.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<TaskEntity>>> getAllTaskForSearch();
}
