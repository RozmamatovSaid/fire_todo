part of 'task_info_bloc.dart';

abstract class TaskInfoEvent extends Equatable {
  const TaskInfoEvent();

  @override
  List<Object?> get props => [];
}

class InitTaskInfoEvent extends TaskInfoEvent {
  final TaskEntity task;
  final String? categoryName;

  const InitTaskInfoEvent({required this.task, this.categoryName});

  @override
  List<Object?> get props => [task, categoryName];
}

class UpdateCategoryEvent extends TaskInfoEvent {
  final CategoryEntity category;

  const UpdateCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

class UpdateDateEvent extends TaskInfoEvent {
  final DateTime date;

  const UpdateDateEvent({required this.date});

  @override
  List<Object?> get props => [date];
}

class UpdateTimeEvent extends TaskInfoEvent {
  final TimeOfDay time;

  const UpdateTimeEvent({required this.time});

  @override
  List<Object?> get props => [time];
}

class UpdatePriorityEvent extends TaskInfoEvent {
  final TaskPriority priority;

  const UpdatePriorityEvent({required this.priority});

  @override
  List<Object?> get props => [priority];
}

class UpdateNotifyEvent extends TaskInfoEvent {
  final bool notify;

  const UpdateNotifyEvent({required this.notify});

  @override
  List<Object?> get props => [notify];
}

// task_info_state.dart
