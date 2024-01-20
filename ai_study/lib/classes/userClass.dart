import 'package:ai_study/classes/questionClass.dart';

class UserClass {
  String userName;
  List<QuestionClass> questionList = [];
  List<int> answerList = [];
  List<int> userAnswerList = [];
  String questionStandard;
  String userInterest;
  int _score = 0;
  int totalQuestions = 0;

  UserClass(this.userName, this.questionStandard, this.userInterest);

  answerCorrectly() {
    _score += 1;
    totalQuestions += 1;
  }

  answerWrongly() {
    _score += 0;
    totalQuestions += 1;
  }

  String getTotalScore() {
    String score = "$_score/$totalQuestions";
    return score;
  }

  void restart() {
    _score = 0;
    totalQuestions = 0;
  }
}
