import 'package:flutter/material.dart';

class DogStudentCard extends StatefulWidget {
  final String? dogName;
  final String? dogBreed;
  final String? dogGender;
  final DateTime? dogBirthDate;

  DogStudentCard({
    this.dogName,
    this.dogBreed,
    this.dogGender,
    this.dogBirthDate,
  });

  @override
  _DogStudentCardState createState() => _DogStudentCardState();
}

class _DogStudentCardState extends State<DogStudentCard> {
  String? _dogImage;

  @override
  void initState() {
    super.initState();
    _loadDogImage();
  }

  void _loadDogImage() {
    // Simulating loading a dog image
    // Replace this with your own logic to load a dog image
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _dogImage = "selected_image.jpg";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String birthDate =
        '${widget.dogBirthDate?.year ?? '??'}년 ${widget.dogBirthDate?.month ?? '??'}월 ${widget.dogBirthDate?.day ?? '??'}일';
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 330,
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Handle image selection
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: _dogImage != null
                    ? DecorationImage(
                  image: AssetImage(_dogImage!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _dogImage == null
                  ? Center(child: CircularProgressIndicator())
                  : null,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '이름: ${widget.dogName ?? '보통이'}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '품종: ${widget.dogBreed ?? '말티푸'}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  '성별: ${widget.dogGender ?? '수컷'}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  '생년월일: 2023-5-24',  //$birthDate
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
