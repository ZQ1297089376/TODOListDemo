import 'package:flutter/material.dart';
import 'package:todo_list_demo/model/task.dart';
import 'package:todo_list_demo/page/edit_task_page.dart';
import 'package:todo_list_demo/provider/provider_widget.dart';
import 'package:todo_list_demo/view_model/home_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<HomeModel>(
      model: HomeModel(),
      onModelReady: (model) {
        model.initData();
      },
      builder: (context, HomeModel model, child) {
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
                  model.filterTasks(v);
                },
              )
            ],
          ),
          body: _buildTaskList(model),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                  builder: (c) => EditTaskPage(title: 'Add a task', task: Task())))
                  .then((v) {
                model.filterTasks(0);
              });
            },
            tooltip: 'Add a task',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildTaskList(HomeModel model) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            model.getFilterTitle(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: model.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  itemCount: model.tasks.length,
                  itemBuilder: (context, index) {
                    Task task = model.tasks[index];
                    return Dismissible(
                      key: Key(UniqueKey().toString()),
                      child: _buildItem(model, task),
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
                        model.deleteTask(task.id, index);
                      },
                      confirmDismiss: (v) async {
                        var _alertDialog = AlertDialog(
                          title: Text(
                              '"${task.title}" will be permanently deleted.'),
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

  Widget _buildItem(HomeModel model, Task task) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (c) => EditTaskPage(title: 'Edit', task: task)))
            .then((v) {
          setState(() {});
        });
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        child: Row(
          children: [
            Checkbox(
              value: task.completed,
              onChanged: (bool isChecked) {
                model.toggleTaskStatus(task, isChecked);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title ?? '',
                            style: TextStyle(
                                color: task.completed
                                    ? Colors.grey
                                    : Colors.black87,
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          task.description == '' ?
                          const SizedBox(height: 4) :
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 2),
                            child: Text(
                              task.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  decoration: task.completed
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                          ),
                          Text(
                            task.createTime,
                            style: TextStyle(
                                color: Colors.grey[400],
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
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
