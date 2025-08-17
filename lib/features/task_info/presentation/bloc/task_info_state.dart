part of 'task_info_bloc.dart';

class TaskInfoState extends Equatable {
  final TaskEntity task;
  final String categoryName;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TaskPriority selectedPriority;
  final bool isNotify;
  final bool isLoading;

  const TaskInfoState({
    required this.task,
    required this.categoryName,
    this.selectedDate,
    this.selectedTime,
    required this.selectedPriority,
    required this.isNotify,
    this.isLoading = false,
  });

  TaskInfoState copyWith({
    TaskEntity? task,
    String? categoryName,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    TaskPriority? selectedPriority,
    bool? isNotify,
    bool? isLoading,
  }) {
    return TaskInfoState(
      task: task ?? this.task,
      categoryName: categoryName ?? this.categoryName,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      isNotify: isNotify ?? this.isNotify,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    task,
    categoryName,
    selectedDate,
    selectedTime,
    selectedPriority,
    isNotify,
    isLoading,
  ];
}
