import 'package:ai_study/classes/questionClass.dart';
import 'package:ai_study/widgets/answerReviewCard.dart';
import 'package:flutter/material.dart';

class AnswerWrapper extends StatefulWidget {
  QuestionClass q;
  int userAns;
  AnswerWrapper({super.key, required this.q, required this.userAns});

  @override
  State<AnswerWrapper> createState() => _AnswerWrapperState(q, userAns);
}

class _AnswerWrapperState extends State<AnswerWrapper> {
  QuestionClass q;
  int userAns;

  _AnswerWrapperState(this.q, this.userAns);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explanation'),
        leading: const SizedBox(),
      ),
      body: AnswerReviewCard(q: q, userAns: userAns),
    );
  }
}
