import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoItem {
  String title;
  bool isComplete;

  TodoItem({required this.title, this.isComplete = false});
}

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoItem> todos = [
    TodoItem(title: '아침 주기'),
    TodoItem(title: '점심 주기'),
    TodoItem(title: '산책하기'),
    TodoItem(title: '간식 주기'),
    TodoItem(title: '약 주기'),
  ];

  late Timer timer;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<TodoItem>> _events = {};

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(hours: 24), (timer) {
      setState(() {
        todos = [
          TodoItem(title: '아침 주기'),
          TodoItem(title: '점심 주기'),
          TodoItem(title: '산책하기'),
          TodoItem(title: '간식 주기'),
          TodoItem(title: '약 주기'),
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
                  todos.add(TodoItem(title: newTodo));
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

  void toggleTodoComplete(int index) {
    setState(() {
      todos[index].isComplete = !todos[index].isComplete;
    });
  }

  void _addTodoToCalendar(DateTime date, TodoItem todo) {
    setState(() {
      _events[date] = [...(_events[date] ?? []), todo];
    });
  }

  void _removeTodoFromCalendar(DateTime date, TodoItem todo) {
    setState(() {
      if (_events.containsKey(date)) {
        _events[date]!.remove(todo);
        if (_events[date]!.isEmpty) {
          _events.remove(date);
        }
      }
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('해야할 일'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
              calendarFormat: CalendarFormat.month,
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, _) {
                  return Container(
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),


            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  TodoItem todo = todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isComplete,
                      onChanged: (_) => toggleTodoComplete(index),
                    ),
                    title: Text(todo.title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removeTodo(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addTodo,
        ),
      ),
    );
  }
}


