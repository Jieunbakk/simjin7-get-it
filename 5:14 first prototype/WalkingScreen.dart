import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  // 1초마다 위치 정보 받아오기
  Future<void> _startWalking() async {
    setState(() {
      _isWalking = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (_previousPosition != null) {
          final distanceInMeters =
          await Geolocator.distanceBetween(_previousPosition!.latitude,
              _previousPosition!.longitude, position.latitude, position.longitude);
          setState(() {
            _distanceInMeters = distanceInMeters;
            _totalDistanceInMeters += distanceInMeters;
            _caloriesBurned = _totalDistanceInMeters * 0.05;
            _elapsedSeconds += 1;
          });
        }
        _previousPosition = position;
      });
    });
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
        title: Text('산책'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}
