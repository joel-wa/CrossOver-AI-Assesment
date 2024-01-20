import 'package:ai_study/classes/questionClass.dart';
import 'package:ai_study/classes/simClass.dart';
import 'package:ai_study/widgets/questionCard.dart';
import 'package:flutter/material.dart';

class QuestionWrapper extends StatefulWidget {
  const QuestionWrapper({super.key});

  @override
  State<QuestionWrapper> createState() => _QuestionWrapperState();
}

class _QuestionWrapperState extends State<QuestionWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        // height: 600,
        // width: Media
        child: FutureBuilder(
            future: SimClass().generateQuestion(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While data is still loading
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If there's an error in fetching data
                return Text('Error: ${snapshot.error}');
              } else {
                return QuestionCardWidget(question: snapshot.data!);
              }
            }))
        // PageView.builder(
        //   itemCount: questionList.length,
        //   itemBuilder: (BuildContext context, index) {
        //     return QuestionCardWidget(question: questionList[index]);
        //   },
        // ),
        );
  }
}
