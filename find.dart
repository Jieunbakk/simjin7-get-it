import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

const SERVER_URL = 'http://your.server.url';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '주변 수의사 찾기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '주변 수의사 찾기'),
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
  Socket socket;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    initSocket();
    initLocation();
  }

  void initSocket() {
    socket = io(SERVER_URL, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.onConnect((_) {
      print('connected');
      socket.emit('login', {
        'id': 'user1',
        'lat': 37.5,
        'lng': 127.0,
      });
    });
    socket.on('users', (data) {
      print('users: $data');
      setState(() {
        users = List<User>.from(data.map((x) => User.fromJson(x)));
      });
    });
    socket.on('message', (data) {
        print('message: $data');
    });
  }

  void initLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.granted) {
    Geolocator.getPositionStream().listen((position) {
      print(position);
      socket.emit('updateLocation', {
        'id': 'user1',
        'lat': position.latitude,
        'lng': position.longitude,
      });
    });
    }
  }

  void sendMessage(String message, String to) {
    socket.emit('message', {
      'from': 'user1',
      'to': to,
      'message': message,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.id),
              subtitle: Text('(${user.lat}, ${user.lng})'),
              onTap: () => sendMessage('상담을 요청하고 싶습니다.', user.id),
            );
          },
        ),
    );
  }
}

class User {
  String id;
  double lat;
  double lng;

  User({
    this.id,
    this.lat,
    this.lng,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}