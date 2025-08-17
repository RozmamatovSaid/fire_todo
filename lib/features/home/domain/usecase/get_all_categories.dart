import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/global/domain/entity/category_entity.dart';
import '../repository/category_repository.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository repo;

  GetAllCategoriesUseCase({required this.repo});

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repo.getAllCategories();
  }
}

