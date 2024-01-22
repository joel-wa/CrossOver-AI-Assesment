import 'dart:async';

import 'package:ai_study/classes/questionClass.dart';
import 'package:ai_study/classes/serverClass.dart';
import 'package:ai_study/classes/userClass.dart';

class SimClass {
  ServerClass server = ServerClass();
  static int maxQuestions = 5;
  static List<QuestionClass> questionsList = [];
  static UserClass user = UserClass(
      'random user', '4th Grade Common Core Writing standard', 'Baseball');

  SimClass() {
    questionsList.clear();
  }

/////////Timer Handlers.
  final StreamController<double> timerStreamController =
      StreamController<double>();
  static double currentTime = 0;

//////////Method to check elapsed time

////////////Functions
  Future<QuestionClass> generateQuestion() async {
    QuestionClass q = await server.getServerQuestion(
        user.questionStandard, user.userInterest);
    // print(q.question);
    questionsList.add(q);
    print(questionsList);
    return q;
  }

  submitAnswer(QuestionClass q, String userAnswer) async {
    print('waiting for reply');
    final response =
        await server.serverEvaluateAnswer(q.question, userAnswer, q.qid);

    if (response["goodAnswer"] == "True") {
      user.answerCorrectly();
    } else {
      user.answerWrongly();
    }
    return response["feedback"];
  }

  void reset() {
    currentTime = 0;
    user = UserClass(
        'random user', '4th Grade Common Core Writing standard', 'baseball');
    user.restart();
  }
}
