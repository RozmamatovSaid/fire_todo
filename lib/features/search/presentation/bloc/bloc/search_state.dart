part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitialState extends SearchState {
  const SearchInitialState();
}

final class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

final class SearchLoadedState extends SearchState {
  const SearchLoadedState({required this.taskList});
  final List<TaskEntity> taskList;

  @override
  List<Object> get props => [taskList];
}

final class SearchFailureState extends SearchState {
  const SearchFailureState({required this.message});
  final String message;

  @override
  List<Object> get props => [];
}
