import 'package:fire_todo/core/services/database_service.dart';
import 'package:fire_todo/shared/global/data/model/category_model.dart';
import 'package:fire_todo/shared/global/data/model/task_model.dart';
import 'package:isar/isar.dart';

// Abstract interface
abstract class CategoryLocalDataSource {
  Future<void> init();
  Future<void> addCategory(String name);
  Future<void> deleteCategory(int id);
  Future<List<CategoryModel>> getAllCategories();
}

// impl
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  // kategoryalarni init qilish
  @override
  Future<void> init() async {
    await IsarService.getInstance();
  }

  // kategorya qoshish
  @override
  Future<void> addCategory(String name) async {
    final isar = await IsarService.getInstance();
    final category = CategoryModel()..name = name;
    await isar.writeTxn(() => isar.categoryModels.put(category));
  }

  @override
  Future<void> deleteCategory(int id) async {
    final isar = await IsarService.getInstance();

    await isar.writeTxn(() async {
      // shu category'ga tegishli barcha tasklarni topish
      final tasksToDelete = await isar.taskModels
          .filter()
          .categoryIdEqualTo(id)
          .findAll();

      // Barcha tasklarni o'chirish
      for (final task in tasksToDelete) {
        await isar.taskModels.delete(task.id);
      }

      //  categoryni ham ochiramiz
      await isar.categoryModels.delete(id);
    });
  }

  // kategoryalarni olish
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final isar = await IsarService.getInstance();
    return await isar.categoryModels.where().findAll();
  }
}
