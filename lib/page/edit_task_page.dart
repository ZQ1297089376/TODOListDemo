import 'package:flutter/material.dart';
import 'package:todo_list_demo/model/task.dart';
import 'package:todo_list_demo/provider/provider_widget.dart';
import 'package:todo_list_demo/view_model/task_model.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key key, this.title, this.task}) : super(key: key);

  final String title;

  final Task task;

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TaskModel>(
      model: TaskModel(task: widget.task),
      onModelReady: (model) {
        model.initData();
      },
      builder: (context, TaskModel model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              TextButton(
                  onPressed: () async {
                    var success = await model.onSubmit();
                    if (!(success ?? false)) {
                      showDialog(context: context, builder: (c) => _buildAlertDialog());
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
            ],
          ),
          bottomNavigationBar: _buildBottomWidget(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(
                    text: model.taskTitle,
                  ),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title'
                  ),
                  onChanged: (v) {
                    model.changeTitle(v);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  minLines: 5,
                  maxLines: 10,
                  controller: TextEditingController(
                    text: model.taskDesc,
                  ),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'description',
                      border: OutlineInputBorder()
                  ),
                  onChanged: (v) {
                    model.changeDesc(v);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: const Text('Please enter task title～'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Widget _buildBottomWidget() {
    if (widget.task.createTime == null) {
      return const SizedBox.shrink();
    } else {
      return Container(
        height: 44,
        alignment: Alignment.center,
        child: Text('Created at ${widget.task.createTime}'),
      );
    }
  }
}
