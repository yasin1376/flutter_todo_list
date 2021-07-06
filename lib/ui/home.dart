import 'package:flutter/material.dart';
import 'package:flutter_todo_list/ui/todo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo'),
        backgroundColor: Colors.black45,
        centerTitle: true,
      ),
      body: new TodoScreen(),
    );
  }
}
