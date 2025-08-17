import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

class TaskEntity extends Equatable {
  const TaskEntity({
    this.id,
    required this.title,
    required this.categoryId,
    required this.priority,
    required this.check,
    required this.notify,
    required this.createdAt,
    this.dueAt,
    this.description,
  });

  final int? id;
  final String title;
  final int categoryId;
  final TaskPriority priority;
  final bool check;
  final bool notify;
  final DateTime createdAt;
  final DateTime? dueAt;
  final String? description;

  TaskEntity copyWith({
    int? id,
    String? title,
    int? categoryId,
    TaskPriority? priority,
    bool? check,
    bool? notify,
    DateTime? createdAt,
    DateTime? dueAt,
    String? description,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      check: check ?? this.check,
      notify: notify ?? this.notify,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    categoryId,
    priority,
    check,
    notify,
    createdAt,
    dueAt,
    description,
  ];
}
