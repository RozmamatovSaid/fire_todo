import 'failure.dart';

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure([
    super.message = 'Mahalliy maʼlumotlar bazasi xatoligi',
  ]);
}

class CategoryNotFoundFailure extends Failure {
  const CategoryNotFoundFailure([super.message = 'Kategoriya topilmadi']);
}
