import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_todo/features/search/domain/usecase/search_usecase.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUsecase searchUsecase;
  List<TaskEntity> _allTasks = [];

  SearchBloc({required this.searchUsecase})
    : super(const SearchInitialState()) {
    on<SearchGetAllTaskEvent>(_onGetAllTasks);

    on<SearchTasksEvent>(
      _onSearchTasks,
      transformer: customSearchTransformer(),
    );

    on<ClearSearchEvent>(_onClearSearch);
  }

  EventTransformer<T> customSearchTransformer<T>() {
    return (events, mapper) {
      return events
          .debounce(const Duration(milliseconds: 300))
          .switchMap(mapper);
    };
  }

  Future<void> _onGetAllTasks(
    SearchGetAllTaskEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoadingState());
    final result = await searchUsecase.call();
    result.fold(
      (failure) => emit(SearchFailureState(message: failure.message)),
      (tasks) {
        _allTasks = tasks;
        emit(SearchLoadedState(taskList: _allTasks));
      },
    );
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<SearchState> emit) {
    if (event.query.isEmpty) {
      emit(SearchLoadedState(taskList: _allTasks));
      return;
    }

    final filteredTasks = _allTasks.where((task) {
      final titleMatch = task.title.toLowerCase().trim().contains(
        event.query.toLowerCase().trim(),
      );

      final descriptionMatch =
          task.description?.toLowerCase().trim().contains(
            event.query.toLowerCase().trim(),
          ) ??
          false;

      return titleMatch || descriptionMatch;
    }).toList();

    emit(SearchLoadedState(taskList: filteredTasks));
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchLoadedState(taskList: _allTasks));
  }
}
