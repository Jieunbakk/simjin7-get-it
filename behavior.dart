class DogBehavior {
  List<String> _behaviors = [];

  void recordBehavior(String behavior) {
    _behaviors.add(behavior);
  }

  Map<String, int> analyzeBehaviors() {
    Map<String, int> behaviorCounts = {};
    _behaviors.forEach((behavior) {
      if (behaviorCounts.containsKey(behavior)) {
        behaviorCounts[behavior]++;
      } else {
        behaviorCounts[behavior] = 1;
      }
    });
    return behaviorCounts;
  }
}

class DogBehaviorPage extends StatefulWidget {
  @override
  _DogBehaviorPageState createState() => _DogBehaviorPageState();
}

class _DogBehaviorPageState extends State<DogBehaviorPage> {
  DogBehavior _dogBehavior = DogBehavior();

  void _recordBehavior(String behavior) {
    setState(() {
      _dogBehavior.recordBehavior(behavior);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('우리집 강아지 귀여워 - 행동 분석'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '강아지의 행동을 기록하세요',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _recordBehavior('먹이 먹음');
              },
              child: Text('먹이 먹음'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _recordBehavior('산책');
              },
              child: Text('산책'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _recordBehavior('잠 잠');
              },
              child: Text('잠 잠'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Map<String, int> behaviorCounts = _dogBehavior.analyzeBehaviors();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('강아지 행동 분석 결과'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: behaviorCounts.entries.map((entry) {
                          return Text('${entry.key}: ${entry.value}번');
                        }).toList(),
                      ),
                    );
                  },
                );
              },
              child: Text('분석하기'),
            ),
          ],
        ),
      ),
    );
  }
}
