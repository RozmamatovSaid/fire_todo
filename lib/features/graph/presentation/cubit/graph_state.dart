import 'package:equatable/equatable.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';

enum GraphFilter { week, month, year }

class GraphState extends Equatable {
  final bool isLoading;
  final List<TaskEntity> tasks;
  final GraphFilter filter;
  final int? touchedBarIndex;

  const GraphState({
    this.isLoading = false,
    this.tasks = const [],
    this.filter = GraphFilter.week,
    this.touchedBarIndex,
  });

  GraphState copyWith({
    bool? isLoading,
    List<TaskEntity>? tasks,
    GraphFilter? filter,
    int? touchedBarIndex,
  }) {
    return GraphState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      touchedBarIndex: touchedBarIndex,
    );
  }

  @override
  List<Object?> get props => [isLoading, tasks, filter, touchedBarIndex];
}
