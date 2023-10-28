import 'package:hive_flutter/adapters.dart';
import 'package:task_list_flutter/data/model/task_model.dart';
import 'package:task_list_flutter/data/source/source.dart';

// HiveTaskDataSource follows the DataSource rulebook
class HiveTaskDataSource implements DataSource<TaskModel> {

  // Constructor
  HiveTaskDataSource(this.box);

  final Box<TaskModel> box;

  @override
  Future<TaskModel> createOrUpdate(TaskModel data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskModel data) async {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) async {
    return box.delete(id);
  }

  @override
  Future<TaskModel> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskModel>> getAll({String searchKeyword = ''}) async {
    if (searchKeyword.isNotEmpty) {
      return box.values.where((element) => element.name.contains(searchKeyword)).toList();
      // element == task
    } else {
      return box.values.toList();
    }
  }
}