import 'package:ai_study/classes/navigationClass.dart';
import 'package:ai_study/classes/simClass.dart';
import 'package:ai_study/pages/EndQuizPage.dart';
import 'package:ai_study/widgets/questionCard.dart';
import 'package:ai_study/widgets/questionWrapper.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  SimClass simClass = SimClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Question ${SimClass.user.totalQuestions + 1}',
          ),
          leading: Container(),
        ),
        body: const SingleChildScrollView(
          child: Column(children: [
            QuestionWrapper(),
          ]),
        ));
  }
}
