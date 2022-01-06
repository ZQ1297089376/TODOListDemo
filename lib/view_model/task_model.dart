import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list_demo/components/db_tool.dart';
import 'package:todo_list_demo/model/task.dart';

class TaskModel with ChangeNotifier {

  Task task;

  TaskModel({@required this.task});

  String _taskTitle = '';
  String _taskDesc = '';

  String get taskTitle => _taskTitle;
  String get taskDesc => _taskDesc;

  initData() {
    _taskTitle = task.title;
    _taskDesc = task.description;
  }

  changeTitle(String title) {
    _taskTitle = title;
  }

  changeDesc(String desc) {
    _taskDesc = desc;
  }

  Future<bool> onSubmit() async {
    if (_taskTitle == null || _taskTitle == '') {
      return false;
    } else {
      task.title = _taskTitle;
      task.description = _taskDesc;
      DataBase db = DataBase();
      if (task.id == null) {
        await db.insert(task);
      } else {
        await db.update(task);
      }
      return true;
    }
  }
}
