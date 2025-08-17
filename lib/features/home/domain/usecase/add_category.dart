import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repository/category_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository repo;

  AddCategoryUseCase({required this.repo});

  Future<Either<Failure, void>> call(String name) {
    return repo.addCategory(name);
  }
}
