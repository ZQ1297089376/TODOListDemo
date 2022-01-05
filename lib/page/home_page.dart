import 'package:flutter/material.dart';
import 'package:todo_list_demo/components/db_tool.dart';
import 'package:todo_list_demo/model/task.dart';
import 'package:todo_list_demo/page/edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  int _filterStatus = 0;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    filterTasks(0);
  }

  @override
  void dispose() {
    super.dispose();
    DataBase db = DataBase();
    db.closeDB();
  }

  // Filter data by status
  filterTasks(int status) async {
    DataBase db = DataBase();
    setState(() {
      _isLoading = true;
    });
    switch (status) {
      case 1:
        tasks = await db.getTaskBy(where: 'completed = ?', whereArgs: [0]);
        break;
      case 2:
        tasks = await db.getTaskBy(where: 'completed = ?', whereArgs: [1]);
        break;
      default:
        tasks = await db.getAll();
        break;
    }
    setState(() {
      _filterStatus = status;
      _isLoading = false;
    });
  }

  addTask() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => EditTaskPage(title: 'Add a task', task: Task()))).then((v) {
      filterTasks(0);
    });
  }

  toggleTaskStatus(Task task, bool isChecked) {
    DataBase db = DataBase();
    setState(() {
      task.completed = isChecked;
    });
    db.update(task);
  }

  deleteTask(int taskId) {
    DataBase db = DataBase();
    db.delete(taskId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: 0, child: Text('All')),
                PopupMenuItem(value: 1, child: Text('Active')),
                PopupMenuItem(value: 2, child: Text('Completed')),
              ];
            },
            offset: const Offset(0, 56),
            icon: const Icon(
              Icons.filter_alt_rounded,
              color: Colors.white,
            ),
            onSelected: (v) {
              filterTasks(v);
            },
          )
        ],
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTask();
        },
        tooltip: 'Add a task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            getFilterTitle(),
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          ) : ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey[200],
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return Dismissible(
                key: Key(UniqueKey().toString()),
                child: _buildItem(task),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const ListTile(
                    trailing: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                onDismissed: (v) {
                  deleteTask(task.id);
                  setState(() {
                    tasks.removeAt(index);
                  });
                },
                confirmDismiss: (v) async {
                  var _alertDialog = AlertDialog(
                    title:
                    Text('"${task.title}" will be permanently deleted.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Delete Task'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      )
                    ],
                  );
                  var isDismiss = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _alertDialog;
                      });
                  return isDismiss;
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildItem(Task task) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => EditTaskPage(title: 'Edit', task: task))).then((v) {
          setState(() {});
        });
      },
      child: Container(
        constraints: const BoxConstraints(
            minHeight: 60
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.completed,
              onChanged: (bool isChecked) {
                toggleTaskStatus(task, isChecked);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                          color: task.completed ? Colors.grey : Colors.black87,
                          decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey[400],
                          decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
