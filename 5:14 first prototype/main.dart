import 'dart:async';
import 'package:dogcare/DogInfoScreen.dart';
import 'package:dogcare/FindVetScreen.dart';
import 'package:flutter/material.dart';
import 'TodoScreen.dart';
import 'WalkingScreen.dart';
import 'FindVetScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '우리집 강아지 귀여워',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('우리집 강아지 귀여워'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DogInfoScreen()),
                );
              },
              child: Text('내 강아지 정보'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoScreen()),
                );
              },
              child: Text('해야할 일'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalkingScreen()),
                );
              },
              child: Text('산책 기록'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FindVetScreen()),
                );
              },
              child: Text('수의사 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}

