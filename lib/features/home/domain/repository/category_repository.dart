import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/global/domain/entity/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, void>> addCategory(String name);
  Future<Either<Failure, void>> deleteCategory(int id);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, void>> updateCategory(CategoryEntity category);
}

