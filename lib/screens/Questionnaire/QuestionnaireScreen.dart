import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../questionnairedb.dart';
import '../../services/exportServices.dart';
import '../userinfo/exportUserinfo.dart';

class QuestionnairePage extends StatefulWidget {
  static const routeName = '/questionnairePage';
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController pageController = PageController();
  int currentIndex = 0;
  List<int?> scores =
      List.filled(5, null); // List to hold scores for each question
  List<int?> selectedChoices =
      List.filled(5, null); // List to hold selected choices for each question
  int totalScore = 0;

  void nextPage() {
    setState(() {
      if (scores[currentIndex] == null) {
        // Calculate score only if not already answered
        int score = Questionnaire().questions[currentIndex]['scores']
            [selectedChoices[currentIndex] ?? 0];
        scores[currentIndex] = score;

        // Print the selected choice and its score
        String choice = Questionnaire().questions[currentIndex]['options']
            [selectedChoices[currentIndex] ?? 0];
        print('Question ${currentIndex + 1}: $choice - Score: $score');
      }

      if (currentIndex < 4) {
        currentIndex++;
        pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        selectedChoices[currentIndex] = 0;
      } else {
        calculateTotalScore();
      }
    });
  }

  void calculateTotalScore() async {
    bool isLoading = false;
    totalScore = scores.fold(0, (prev, score) => prev + (score ?? 0));
    String stage = '';
    if (totalScore <= 12) {
      stage = "Preclinical Alzheimer's Disease";
    } else if (totalScore <= 20) {
      stage = "Mild Cognitive Impairment (MCI)";
    } else if (totalScore <= 30) {
      stage = "Mild Alzheimer's Disease";
    } else if (totalScore <= 40) {
      stage = "Moderate Alzheimer's Disease";
    } else {
      stage = "Severe Alzheimer's Disease";
    }
    // Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
    await QuestionNairService().uploadQuestionnairResult(
        totalScore: totalScore, diagnosis: stage.trim(), context: context);
    setState(() {
      isLoading = false;
    });
    (isLoading)
        ? showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            })
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'ADHD Assessment Result',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Score: $totalScore'),
                  SizedBox(height: 10),
                  Text(stage)
                  //Text(diagnosis),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        UserInfoScreen.routeName, (route) => false);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
  }

  Object? groupVal = 0; // Current selected radio button value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: Questionnaire().questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                height: 500,
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: QuestionPage(
                          question: Questionnaire().questions[index]
                              ['question'],
                          onChanged: (val) {
                            setState(() {
                              selectedChoices[index] = val as int?;
                              groupVal = val;
                            });
                          },
                          groupVal: selectedChoices[index],
                          options: Questionnaire().questions[index]['options'],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, bottom: 8),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: nextPage,
                              child: Text(
                                (currentIndex == 4) ? 'Done' : 'Next',
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 17),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final String question;
  final Function(Object?) onChanged;
  final Object? groupVal;
  final List<String> options;

  const QuestionPage({
    Key? key,
    required this.question,
    required this.onChanged,
    required this.options,
    this.groupVal,
  }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Text(
            widget.question,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.options
                .asMap()
                .entries
                .map(
                  (entry) => RadioButton(
                    val: entry.key, // Assigning the index as val
                    onChanged: widget.onChanged,
                    text: entry.value,
                    groupVal: widget.groupVal,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class RadioButton extends StatelessWidget {
  final int val;
  final void Function(Object?) onChanged;
  final String text;
  final Object? groupVal;
  const RadioButton(
      {Key? key,
      required this.text,
      required this.val,
      required this.onChanged,
      this.groupVal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          elevation: 4,
          color: Colors.blue[300],
          child: ListTile(
            title: Text(
              text,
              style: GoogleFonts.getFont('Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            leading: Radio(
              fillColor: MaterialStateProperty.resolveWith((states) {
                // active
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                // inactive
                return Colors.white;
              }),
              value: val,
              groupValue: groupVal,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
