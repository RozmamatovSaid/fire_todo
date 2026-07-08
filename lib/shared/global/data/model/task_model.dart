import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:isar/isar.dart';
part 'task_model.g.dart';

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  late String title;
  late int categoryId;
  late int priorityIndex;
  late DateTime createdAt;
  bool check = false;
  bool notify = false;
  int orderIndex = 0;

  DateTime? dueAt; 
  String? description;

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      categoryId: categoryId,
      priority: TaskPriority.values[priorityIndex],
      check: check,
      notify: notify,
      createdAt: createdAt,
      dueAt: dueAt,
      description: description,
      orderIndex: orderIndex,
    );
  }

  static TaskModel fromEntity(TaskEntity e) {
    final m = TaskModel()
      ..title = e.title
      ..categoryId = e.categoryId
      ..priorityIndex = e.priority.index
      ..check = e.check
      ..notify = e.notify
      ..createdAt = e.createdAt
      ..dueAt = e.dueAt
      ..description = e.description
      ..orderIndex = e.orderIndex;

    if (e.id != null) m.id = e.id!;
    return m;
  }
}
