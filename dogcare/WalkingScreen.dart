import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:table_calendar/table_calendar.dart';

class WalkingScreen extends StatefulWidget {
  @override
  _WalkingScreenState createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen> {
  bool _isWalking = false;
  double _distanceInMeters = 0;
  double _totalDistanceInMeters = 0;
  double _caloriesBurned = 0;
  int _elapsedSeconds = 0;
  Timer? _timer;
  Position? _previousPosition;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Calendar event data structure
  Map<DateTime, List<dynamic>> _events = {};

  // Function to handle day selection
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  // Function to add data to the selected date in events
  void _addDataToCalendar(DateTime date, dynamic data) {
    setState(() {
      _events[date] = [...(_events[date] ?? []), data];
    });
  }

  // 1초마다 위치 정보 받아오기
  Future<void> _startWalking() async {
    setState(() {
      _isWalking = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds += 1;
        });
      });
    });

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _previousPosition = position;
  }

  // 산책 중지
  void _stopWalking() {
    setState(() {
      _isWalking = false;
      _timer?.cancel();
      _previousPosition = null;
    });
  }

  // UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('산책 측정'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2023, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
            calendarFormat: CalendarFormat.month,
            onDaySelected: _onDaySelected,
          ),
          SizedBox(height: 10),
          Text(
            '산책 추천 거리 : 5km',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            '보통이(이)가 아직 만족하지 못했습니다.',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Text(
            '이동 거리: ${(_totalDistanceInMeters / 1000).toStringAsFixed(2)} km',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            '소모 칼로리: ${_caloriesBurned.toInt()} kcal',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            '산책 시간: ${Duration(seconds: _elapsedSeconds).toString().split('.').first}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 32),
          if (_isWalking)
            ElevatedButton(
              onPressed: _stopWalking,
              child: Text('산책 중지'),
            )
          else
            ElevatedButton(
              onPressed: _startWalking,
              child: Text('산책 시작'),
            ),
          SizedBox(height: 16),
          Text(
            '선택한 날짜 데이터:',
            style: TextStyle(fontSize: 24),
          ),
          if (_events[_selectedDate]?.isNotEmpty ?? false)
            Column(
              children: _events[_selectedDate]!.map((event) {
                final distance = event['distance'] as double;
                final calories = event['calories'] as double;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '거리: ${distance.toStringAsFixed(2)}m, 칼로리: ${calories.toInt()}kcal',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            )
          else
            Text(
              '데이터 없음',
              style: TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }
}
