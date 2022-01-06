import 'package:flutter/material.dart';
import 'package:todo_list_demo/components/db_tool.dart';
import 'package:todo_list_demo/model/task.dart';

class HomeModel with ChangeNotifier {
  // Loading status.
  bool _isLoading = true;
  // Current filter status.
  int _filterStatus = 0;
  // Task list.
  List<Task> _tasks = [];

  bool get isLoading => _isLoading;

  int get filterStatus => _filterStatus;

  List<Task> get tasks => _tasks;

  @override
  void dispose() {
    super.dispose();
    DataBase db = DataBase();
    db.closeDB();
  }

  initData() async {
    DataBase db = DataBase();
    _tasks = await db.getAll();
    _isLoading = false;
    notifyListeners();
  }

  // Filter data by status
  filterTasks(int status) async {
    _isLoading = true;
    notifyListeners();
    DataBase db = DataBase();
    switch (status) {
      case 1:
        _tasks = await db.getTaskBy(where: 'completed = ?', whereArgs: [0], orderBy: 'create_time desc');
        break;
      case 2:
        _tasks = await db.getTaskBy(where: 'completed = ?', whereArgs: [1], orderBy: 'create_time desc');
        break;
      default:
        _tasks = await db.getAll();
        break;
    }
    _filterStatus = status;
    _isLoading = false;
    notifyListeners();
  }

  toggleTaskStatus(Task task, bool isChecked) {
    task.completed = isChecked;
    DataBase db = DataBase();
    db.update(task);
    notifyListeners();
  }

  deleteTask(int taskId, int index) {
    DataBase db = DataBase();
    db.delete(taskId);
    tasks.removeAt(index);
    notifyListeners();
  }

  String getFilterTitle() {
    switch (_filterStatus) {
      case 1:
        return 'Active';
      case 2:
        return 'Completed';
        break;
      default:
        return 'All';
    }
  }
}