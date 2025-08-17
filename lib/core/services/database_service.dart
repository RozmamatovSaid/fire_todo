import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../shared/global/data/model/category_model.dart';
import '../../shared/global/data/model/task_model.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> getInstance() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      CategoryModelSchema,
      TaskModelSchema,
    ], directory: dir.path);

    return _isar!;
  }
}
