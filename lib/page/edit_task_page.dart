import 'package:flutter/material.dart';
import 'package:todo_list_demo/components/db_tool.dart';
import 'package:todo_list_demo/model/task.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key key, this.title, this.task}) : super(key: key);

  final String title;

  final Task task;

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  String _taskTitle = '';
  String _taskDesc = '';

  @override
  void initState() {
    super.initState();
    _taskTitle = widget.task.title;
    _taskDesc = widget.task.description;
  }

  onSubmit() async {
    widget.task.title = _taskTitle;
    widget.task.description = _taskDesc;
    DataBase db = DataBase();
    if (widget.task.id == null) {
      await db.insert(widget.task);
    } else {
      await db.update(widget.task);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () {
              if (_taskTitle == null || _taskTitle == '') {
                showDialog(context: context, builder: (c) => _buildAlertDialog());
              } else {
                onSubmit();
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
                text: _taskTitle,
              ),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title'
              ),
              onChanged: (v) {
                _taskTitle = v;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              minLines: 5,
              maxLines: 10,
              controller: TextEditingController(
                text: _taskDesc,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'description',
                border: OutlineInputBorder()
              ),
              onChanged: (v) {
                _taskDesc = v;
              },
            ),
          ],
        ),
      ),
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
