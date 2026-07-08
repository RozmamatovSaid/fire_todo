import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_all_tasks.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_tasks_by_date.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final GetTasksByDateUsecase getTasksByDate;
  final GetAllTasksUsecase getAllTasks;

  CalendarCubit({
    required this.getTasksByDate,
    required this.getAllTasks,
  }) : super(CalendarState(
          selectedDate: DateTime.now(),
          focusedMonth: DateTime.now(),
          tasks: const [],
          datesWithTasks: const {},
          isLoading: false,
        ));

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));
    final result = await getTasksByDate(state.selectedDate);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (tasks) => emit(state.copyWith(tasks: tasks, isLoading: false)),
    );
  }

  Future<void> fetchDatesWithTasks() async {
    final result = await getAllTasks();
    result.fold(
      (failure) => null,
      (tasks) {
        final dates = tasks
            .where((task) => task.dueAt != null)
            .map((task) => "${task.dueAt!.year}-${task.dueAt!.month}-${task.dueAt!.day}")
            .toSet();
        emit(state.copyWith(datesWithTasks: dates));
      },
    );
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, focusedMonth: date));
    loadTasks();
  }

  void changeSelectedDate(int offset) {
    final newDate = state.selectedDate.add(Duration(days: offset));
    emit(state.copyWith(
      selectedDate: newDate,
      focusedMonth: DateTime(newDate.year, newDate.month, 1),
    ));
    loadTasks();
  }
}
