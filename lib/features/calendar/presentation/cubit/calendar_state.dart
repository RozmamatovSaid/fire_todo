import 'package:equatable/equatable.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final List<TaskEntity> tasks;
  final Set<String> datesWithTasks;
  final bool isLoading;

  const CalendarState({
    required this.selectedDate,
    required this.focusedMonth,
    required this.tasks,
    required this.datesWithTasks,
    required this.isLoading,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? focusedMonth,
    List<TaskEntity>? tasks,
    Set<String>? datesWithTasks,
    bool? isLoading,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      tasks: tasks ?? this.tasks,
      datesWithTasks: datesWithTasks ?? this.datesWithTasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        focusedMonth,
        tasks,
        datesWithTasks,
        isLoading,
      ];
}
