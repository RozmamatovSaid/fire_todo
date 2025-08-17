part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchGetAllTaskEvent extends SearchEvent {
  const SearchGetAllTaskEvent();
}

final class SearchTasksEvent extends SearchEvent {
  const SearchTasksEvent({required this.query});
  final String query;

  @override
  List<Object> get props => [];
}

final class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}
