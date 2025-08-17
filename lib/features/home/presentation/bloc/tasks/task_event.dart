part of "task_bloc.dart";

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTaskEvent extends TaskEvent {
  const AddTaskEvent({required this.taskEntity});
  final TaskEntity taskEntity;

  @override
  List<Object?> get props => [taskEntity];
}

class DeleteTaskEvent extends TaskEvent {
  const DeleteTaskEvent({required this.taskId});
  final int taskId;

  @override
  List<Object?> get props => [taskId];
}

class GetAllTasksEvent extends TaskEvent {
  const GetAllTasksEvent();
}

class GetTasksByCategoryEvent extends TaskEvent {
  const GetTasksByCategoryEvent({required this.categoryId});
  final int categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class GetTasksByDateEvent extends TaskEvent {
  const GetTasksByDateEvent({required this.date});
  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class CheckTask extends TaskEvent {
  const CheckTask({required this.check});
  final bool check;

  @override
  List<Object?> get props => [check];
}

class ClearTasksEvent extends TaskEvent {
  const ClearTasksEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTaskEvent extends TaskEvent {
  const UpdateTaskEvent({required this.taskEntity});
  final TaskEntity taskEntity;

  @override
  List<Object?> get props => [taskEntity];
}
