import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_todo/features/home/domain/usecase/add_category.dart';
import 'package:fire_todo/features/home/domain/usecase/delete_category.dart';
import 'package:fire_todo/features/home/domain/usecase/get_all_categories.dart';
import 'package:fire_todo/features/home/domain/usecase/update_category.dart';
import '../../../../../shared/global/domain/entity/category_entity.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUseCase addCategory;
  final DeleteCategoryUseCase deleteCategory;
  final GetAllCategoriesUseCase getAllCategories;
  final UpdateCategoryUseCase updateCategory;

  CategoryBloc({
    required this.addCategory,
    required this.deleteCategory,
    required this.getAllCategories,
    required this.updateCategory,
  }) : super(const CategoryInitialState()) {
    on<AddCategoryEvent>((event, emit) async {
      emit(const CategoryLoadingState());
      await addCategory(event.name);
      await _loadCategories(emit);
    });

    on<DeleteCategoryEvent>((event, emit) async {
      emit(const CategoryLoadingState());
      await deleteCategory(event.id);
      await _loadCategories(emit);
    });

    on<GetAllCategoriesEvent>((event, emit) async {
      emit(const CategoryLoadingState());
      await _loadCategories(emit);
    });

    on<EditCategoryEvent>((event, emit) async {
      emit(const CategoryLoadingState());
      await updateCategory(event.category);
      await _loadCategories(emit);
    });
  }

  Future<void> _loadCategories(Emitter<CategoryState> emit) async {
    final result = await getAllCategories();
    result.fold(
      (failure) => emit(CategoryFailureState(message: failure.message)),
      (categories) => emit(CategoryLoadedState(categories: categories)),
    );
  }
}
