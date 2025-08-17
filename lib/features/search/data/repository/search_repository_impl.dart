import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/core/error/local_failures.dart';
import 'package:fire_todo/features/search/domain/repository/search_repo.dart';
import 'package:fire_todo/shared/global/data/datasource/task_local_datasource.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.localDatasource});
  final TaskLocalDatasource localDatasource;

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTaskForSearch() async {
    try {
      final models = await localDatasource.getAllTasks();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure('Tasklarni olishda xatolik: $e'));
    }
  }
}
