import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/global/domain/entity/category_entity.dart';
import '../repository/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repo;

  UpdateCategoryUseCase({required this.repo});

  Future<Either<Failure, void>> call(CategoryEntity category) {
    return repo.updateCategory(category);
  }
}
