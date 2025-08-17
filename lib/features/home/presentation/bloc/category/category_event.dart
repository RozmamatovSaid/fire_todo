part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class AddCategoryEvent extends CategoryEvent {
  final String name;

  const AddCategoryEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetAllCategoriesEvent extends CategoryEvent {
  const GetAllCategoriesEvent();
}
