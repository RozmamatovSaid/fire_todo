import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/features/search/domain/repository/search_repo.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';

class SearchUsecase {
  SearchUsecase({required this.repo});

  final SearchRepository repo;
  Future<Either<Failure, List<TaskEntity>>> call() async {
    return await repo.getAllTaskForSearch();
  }
}
