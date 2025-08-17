part of "task_bloc.dart";

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {
  const TaskInitialState();
}

class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}

// ✅ FAQAT BITTA LOADED STATE
class TasksLoadedState extends TaskState {
  const TasksLoadedState({required this.taskEntity});
  final List<TaskEntity> taskEntity;

  @override
  List<Object?> get props => [taskEntity];
}

class TaskFailureState extends TaskState {
  const TaskFailureState({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
