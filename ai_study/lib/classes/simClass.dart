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

  submitAnswer(QuestionClass q, int selectedAnswer) async {
    if (selectedAnswer != q.answer) {
      //Tell AI user answered question wrongly
      final response = await server.userAnweredWrongly(q.question,
          q.possibleAnswers[selectedAnswer], q.possibleAnswers[q.answer]);

      user.answerWrongly();
      return response;
    } else {
      user.answerCorrectly();
      //Ask AI for next question
      return q.answerExplanation;
    }
  }

  void reset() {
    currentTime = 0;
    user = UserClass(
        'random user', '4th Grade Common Core Writing standard', 'baseball');
    user.restart();
  }
}
