import 'package:fire_todo/core/services/database_service.dart';
import 'package:fire_todo/shared/global/data/model/task_model.dart';
import 'package:isar/isar.dart';

abstract class TaskLocalDatasource {
  Future<void> init();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getTasksByCategory(int categoryId);
  Future<List<TaskModel>> getTasksByDate(DateTime date);
}

class TaskLocalDatasourceImpl implements TaskLocalDatasource {
  @override
  Future<void> init() async {
    await IsarService.getInstance();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() => isar.taskModels.put(task));
  }

  @override
  Future<void> deleteTask(int id) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() => isar.taskModels.delete(id));
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final isar = await IsarService.getInstance();
    return await isar.taskModels.where().findAll();
  }

  @override
  Future<List<TaskModel>> getTasksByCategory(int categoryId) async {
    final isar = await IsarService.getInstance();

    return await isar.taskModels
        .filter()
        .categoryIdEqualTo(categoryId)
        .findAll();
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() => isar.taskModels.put(task));
  }

  @override
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final isar = await IsarService.getInstance();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await isar.taskModels
        .filter()
        .dueAtBetween(startOfDay, endOfDay)
        .sortByDueAt()
        .findAll();
  }
}
