import 'package:ai_study/classes/navigationClass.dart';
import 'package:ai_study/classes/questionClass.dart';
import 'package:ai_study/classes/simClass.dart';
import 'package:ai_study/widgets/answerWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class EventHandler {
  static String questionStandard = '';
  static String userInterest = 'Baseball';
  NavClass nav = NavClass();
  static int answeredTotal = 0;

/////OnBoarding
  onStandardSelected(String standard) {
    questionStandard = standard;
    SimClass.user.questionStandard = questionStandard;
    print('Changed to $questionStandard');
  }

  onChangeUserInterest(String interest) {
    userInterest = interest;
    SimClass.user.userInterest = userInterest;
  }

//////////////Question Events
  // onUserSelectAnswer(int answer) {
  //   selectedAnswer = answer;
  // }

  onAnswerSubmitted(
      QuestionClass q, BuildContext context, String userAnswer) async {
    // Use this as the selected answer selectedAnswer

    print(userAnswer);
    // int tempAns = selectedAnswer;
    final response = await SimClass().submitAnswer(q, userAnswer);
    // print(selectedAnswer);
    q.answerExplanation = response;
    //Navigate to Answer page
    if (context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return AnswerWrapper(q: q, userAns: userAnswer);
      }));
    }

    //then reset to -1
    // selectedAnswer = -1;
  }

  onProceed(BuildContext context) {
    answeredTotal += 1;
    print('Answer question is: ${SimClass.user.totalQuestions}');
    if (answeredTotal >= SimClass.maxQuestions) {
      nav.changePage('End', context);

      return;
    }

    nav.changePage('Question Page', context);
  }
}
