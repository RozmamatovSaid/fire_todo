import 'package:dartz/dartz.dart';
import 'package:fire_todo/core/error/failure.dart';
import 'package:fire_todo/shared/global/domain/entity/category_entity.dart';
import 'package:fire_todo/features/home/domain/repository/category_repository.dart';
import '../../../../core/error/local_failures.dart';
import '../../../../shared/global/data/datasource/category_local_datasource.dart';
import '../../../../shared/global/data/model/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDatasource;

  CategoryRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, void>> addCategory(String name) async {
    try {
      await localDatasource.addCategory(name);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure("Kategoriya qo‘shishda xatolik: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await localDatasource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure("Kategoriya o‘chirishda xatolik: $e"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final models = await localDatasource.getAllCategories();
      final entities = models
          .map((model) => CategoryEntity(id: model.id, name: model.name))
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure("Kategoriyalarni olishda xatolik: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel()
        ..id = category.id
        ..name = category.name;
      await localDatasource.updateCategory(model);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure("Kategoriyani yangilashda xatolik: $e"));
    }
  }
}
