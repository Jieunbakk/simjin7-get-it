import 'package:flutter/material.dart';

class DogInfoScreen extends StatefulWidget {
  @override
  _DogInfoScreenState createState() => _DogInfoScreenState();
}

class _DogInfoScreenState extends State<DogInfoScreen> {
  String? _dogName;
  String? _dogBreed;
  String? _dogGender;
  DateTime? _dogBirthDate;
  final _formKey = GlobalKey<FormState>();

  void _showDogInfo() {
    String gender = _dogGender == '남자' ? '수컷' : '암컷';
    String birthDate =
        '${_dogBirthDate!.year}년 ${_dogBirthDate!.month}월 ${_dogBirthDate!.day}일';
    String message =
        '강아지 이름: $_dogName\n강아지 성별: $gender\n강아지 생년월일: $birthDate\n강아지 품종: $_dogBreed';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('강아지 정보'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('강아지 정보'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
        padding: EdgeInsets.all(16.0),
      child: Form(
      key: _formKey,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      TextFormField(
      decoration: InputDecoration(
      labelText: '강아지 이름',
      border: OutlineInputBorder(),
      ),
      validator: (value) {
      if (value == null || value.isEmpty) {
      return '강아지 이름을 입력하세요';
      }
      return null;
    },
    onSaved:(value) {
      setState(() {
        _dogName = value;
      });
    },
    ),
      SizedBox(height: 16.0),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: '강아지 성별',
          border: OutlineInputBorder(),
        ),
        value: _dogGender,
        onChanged: (String? newValue) {
          setState(() {
            _dogGender = newValue;
          });
        },
        items: <String>['남자', '여자']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      SizedBox(height: 16.0),
      InputDecorator(
        decoration: InputDecoration(
          labelText: '강아지 생년월일',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _dogBirthDate == null
                  ? '생년월일을 선택하세요'
                  : '${_dogBirthDate!.year}.${_dogBirthDate!.month}.${_dogBirthDate!.day}',
            ),
            IconButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: _dogBirthDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                ).then((value) {
                  setState(() {
                    _dogBirthDate = value;
                  });
                });
              },
              icon: Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.0),
      TextFormField(
        decoration: InputDecoration(
          labelText: '강아지 품종',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '강아지 품종을 입력하세요';
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            _dogBreed = value;
          });
        },
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _showDogInfo();
          }
        },
        child: Text('저장'),
      ),
    ],
    ),
    ),
        ),
    );
  }
}