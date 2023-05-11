import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> todos = [
    '아침 주기',
    '점심 주기',
    '산책하기',
    '간식 주기',
    '약 주기',
  ];

  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(hours: 24), (timer) {
      setState(() {
        todos = [
          '아침 주기',
          '점심 주기',
          '산책하기',
          '간식 주기',
          '약 주기',
        ];
      });
    });
  }

  void addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        String newTodo = '';
        return AlertDialog(
          title: Text('해야할 일 추가'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTodo = value;
            },
          ),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('추가'),
              onPressed: () {
                setState(() {
                  todos.add(newTodo);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('해야할 일'),
        ),
        body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(todos[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeTodo(index);
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addTodo,
          tooltip: '해야할 일 추가',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
