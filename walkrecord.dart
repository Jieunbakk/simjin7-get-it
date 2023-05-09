import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_timer/flutter_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '산책 기록',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '산책 기록'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isRecording = false;
  double distance = 0;
  double calories = 0;
  Timer timer;
  TimerRecord timerRecord;
  String duration = '00:00:00';

  @override
  void initState() {
    super.initState();
    loadRecord();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        duration = TimerRecord.fromSeconds(timerRecord.secondsElapsed + 1)
            .format(DurationFormat.HH_MM_SS);
      });
    });
  }

  void startRecording() async {
    setState(() {
      isRecording = true;
      distance = 0;
      calories = 0;
      timerRecord = TimerRecord();
      duration = '00:00:00';
    });
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Position position) {
      setState(() {
        double newDistance = calculateDistance(position);
        distance += newDistance;
        calories += calculateCalories(newDistance);
      });
    });
  }

 
