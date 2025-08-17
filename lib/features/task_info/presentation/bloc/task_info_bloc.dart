import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:fire_todo/shared/global/domain/entity/category_entity.dart';
import '../../../home/presentation/bloc/tasks/task_bloc.dart';
part 'task_info_event.dart';
part 'task_info_state.dart';

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  final TaskBloc taskBloc;

  TaskInfoBloc({required this.taskBloc})
    : super(
        TaskInfoState(
          task: TaskEntity(
            title: '',
            categoryId: 0,
            priority: TaskPriority.medium,
            check: false,
            notify: false,
            createdAt: DateTime.now(),
          ),
          categoryName: '',
          selectedPriority: TaskPriority.medium,
          isNotify: false,
        ),
      ) {
    // Task ma'lumotlarini boshlash
    on<InitTaskInfoEvent>((event, emit) {
      emit(
        TaskInfoState(
          task: event.task,
          categoryName: event.categoryName ?? '',
          selectedDate: event.task.dueAt,
          selectedTime: event.task.dueAt != null
              ? TimeOfDay.fromDateTime(event.task.dueAt!)
              : null,
          selectedPriority: event.task.priority,
          isNotify: event.task.notify,
        ),
      );
    });

    // Category o'zgartirish
    on<UpdateCategoryEvent>((event, emit) {
      final updatedTask = state.task.copyWith(categoryId: event.category.id);

      emit(
        state.copyWith(
          task: updatedTask,
          categoryName: event.category.name,
          isLoading: true,
        ),
      );

      // TaskBloc'ga o'zgarishni yuborish
      taskBloc.add(UpdateTaskEvent(taskEntity: updatedTask));

      emit(state.copyWith(isLoading: false));
    });

    // Sana o'zgartirish
    on<UpdateDateEvent>((event, emit) {
      DateTime finalDateTime;

      if (state.selectedTime != null) {
        finalDateTime = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
          state.selectedTime!.hour,
          state.selectedTime!.minute,
        );
      } else {
        finalDateTime = DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
          9,
          0,
        );
      }

      final updatedTask = state.task.copyWith(dueAt: finalDateTime);

      emit(
        state.copyWith(
          task: updatedTask,
          selectedDate: finalDateTime,
          selectedTime:
              state.selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
          isLoading: true,
        ),
      );

      taskBloc.add(UpdateTaskEvent(taskEntity: updatedTask));
      emit(state.copyWith(isLoading: false));
    });

    // Vaqt o'zgartirish
    on<UpdateTimeEvent>((event, emit) {
      if (state.selectedDate == null) return;

      final finalDateTime = DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        event.time.hour,
        event.time.minute,
      );

      final updatedTask = state.task.copyWith(dueAt: finalDateTime);

      emit(
        state.copyWith(
          task: updatedTask,
          selectedDate: finalDateTime,
          selectedTime: event.time,
          isLoading: true,
        ),
      );

      taskBloc.add(UpdateTaskEvent(taskEntity: updatedTask));
      emit(state.copyWith(isLoading: false));
    });

    // Priority o'zgartirish
    on<UpdatePriorityEvent>((event, emit) {
      final updatedTask = state.task.copyWith(priority: event.priority);

      emit(
        state.copyWith(
          task: updatedTask,
          selectedPriority: event.priority,
          isLoading: true,
        ),
      );

      taskBloc.add(UpdateTaskEvent(taskEntity: updatedTask));
      emit(state.copyWith(isLoading: false));
    });

    // Notification o'zgartirish
    on<UpdateNotifyEvent>((event, emit) {
      final updatedTask = state.task.copyWith(notify: event.notify);

      emit(
        state.copyWith(
          task: updatedTask,
          isNotify: event.notify,
          isLoading: true,
        ),
      );

      taskBloc.add(UpdateTaskEvent(taskEntity: updatedTask));
      emit(state.copyWith(isLoading: false));
    });
  }
}
