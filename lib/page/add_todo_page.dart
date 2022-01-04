import 'package:flutter/material.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key key}) : super(key: key);

  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add TODO"),
        )
    );
  }
}
