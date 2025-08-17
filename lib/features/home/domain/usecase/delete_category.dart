import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repository/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repo;

  DeleteCategoryUseCase({required this.repo});

  Future<Either<Failure, void>> call(int id) {
    return repo.deleteCategory(id);
  }
}
