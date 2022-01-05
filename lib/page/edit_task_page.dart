import 'package:flutter/material.dart';
import 'package:todo_list_demo/components/db_tool.dart';
import 'package:todo_list_demo/model/task.dart';
import 'package:intl/intl.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key key, this.title, this.task}) : super(key: key);

  final String title;

  final Task task;

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {

  onSubmit() async {
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
              if (widget.task.title == null || widget.task.title.isEmpty) {
                showDialog(context: context, builder: (c) => _buildAlertDialog());
              }
              onSubmit();
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
                text: widget.task.title,
              ),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title'
              ),
              onChanged: (v) {
                widget.task.title = v;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              minLines: 5,
              maxLines: 10,
              controller: TextEditingController(
                text: widget.task.description,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'description',
                border: OutlineInputBorder()
              ),
              onChanged: (v) {
                widget.task.description = v;
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
      DateTime createTime = widget.task.createTime;
      DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm");
      String time = formatter.format(createTime);
      return Container(
        height: 44,
        alignment: Alignment.center,
        child: Text('Created at $time'),
      );
    }
  }
}
