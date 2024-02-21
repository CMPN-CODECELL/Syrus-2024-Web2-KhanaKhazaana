import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  static const routeName = '/thirdGame';
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestion = 0;
  int _score = 0;

  List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the your father\'s name?',
      'answers': ['Roji', 'Hemant', 'Raju', 'Shyam'],
      'correctAnswer': 1,
      'score': 10,
    },
    {
      'question': 'What is the your mother\'s name?',
      'answers': ['Sharda', 'Shamila', 'Suman', 'Vasu'],
      'correctAnswer': 1,
      'score': 20,
    },
    {
      'question': 'Where do you live?',
      'answers': ['Nagpur', 'Mulund', 'Kurla', 'Chembur'],
      'correctAnswer': 1,
      'score': 20,
    },
    {
      'question': 'What is your age?',
      'answers': ['20', '21', '25', '31'],
      'correctAnswer': 2,
      'score': 20,
    },
    {
      'question': 'Where do you work?',
      'answers': ['Nagpur', 'Mulund', 'Kurla', 'Chembur'],
      'correctAnswer': 2,
      'score': 20,
    },
    {
      'question': 'What is your occupation?',
      'answers': ['Floor Washer', 'Peon', 'Engineer', 'Politician'],
      'correctAnswer': 3,
      'score': 20,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              _questions[_currentQuestion]['question'],
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            Column(
              children: List.generate(
                _questions[_currentQuestion]['answers'].length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListTile(
                        selectedColor: Colors.green,
                        title: Text(
                            '${index + 1}. ${_questions[_currentQuestion]['answers'][index]}'),
                        trailing: _questions[_currentQuestion]
                                    .containsKey('isAnswered') &&
                                _questions[_currentQuestion]['isAnswered'] &&
                                _questions[_currentQuestion]['correctAnswer'] ==
                                    index
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () => _checkAnswer(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text('Score: $_score'),
          ],
        ),
      ),
    );
  }

  _checkAnswer(int answerIndex) {
    setState(() {
      if (_questions[_currentQuestion]['correctAnswer'] == answerIndex) {
        _score += _questions[_currentQuestion]['score'] as int;
      } else {
        // Show correct answer
        _questions[_currentQuestion]['isAnswered'] = true;
      }

      _currentQuestion++;

      if (_currentQuestion >= _questions.length) {
        // Show results page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsPage(score: _score)),
        );
      }
    });
  }
}

class ResultsPage extends StatelessWidget {
  final int score;

  ResultsPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your score: $score'),
            // Add buttons to play again or close the app
          ],
        ),
      ),
    );
  }
}
