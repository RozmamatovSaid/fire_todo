import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_todo/features/home/domain/usecase/add_category.dart';
import 'package:fire_todo/features/home/domain/usecase/delete_category.dart';
import 'package:fire_todo/features/home/domain/usecase/get_all_categories.dart';
import 'package:fire_todo/features/home/domain/usecase/update_category.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    on<ReorderCategoriesEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final idList = event.categories.map((c) => c.id.toString()).toList();
      await prefs.setStringList('category_order_ids', idList);
      emit(CategoryLoadedState(categories: event.categories));
    });
  }

  Future<void> _loadCategories(Emitter<CategoryState> emit) async {
    final result = await getAllCategories();
    await result.fold(
      (failure) async => emit(CategoryFailureState(message: failure.message)),
      (categories) async {
        final sortedCategories = await _sortCategoriesBySavedOrder(categories);
        emit(CategoryLoadedState(categories: sortedCategories));
      },
    );
  }

  Future<List<CategoryEntity>> _sortCategoriesBySavedOrder(List<CategoryEntity> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList('category_order_ids');
    if (savedOrder == null || savedOrder.isEmpty) {
      return categories;
    }

    final Map<int, int> orderMap = {};
    for (int i = 0; i < savedOrder.length; i++) {
      final id = int.tryParse(savedOrder[i]);
      if (id != null) {
        orderMap[id] = i;
      }
    }

    final sorted = List<CategoryEntity>.from(categories);
    sorted.sort((a, b) {
      final indexA = orderMap[a.id] ?? 999999;
      final indexB = orderMap[b.id] ?? 999999;
      return indexA.compareTo(indexB);
    });
    return sorted;
  }
}
