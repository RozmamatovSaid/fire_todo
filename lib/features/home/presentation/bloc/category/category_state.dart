part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitialState extends CategoryState {
  const CategoryInitialState();
}

class CategoryLoadingState extends CategoryState {
  const CategoryLoadingState();
}

class CategoryLoadedState extends CategoryState {
  final List<CategoryEntity> categories;
  
  const CategoryLoadedState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryFailureState extends CategoryState {
  final String message;

  const CategoryFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
