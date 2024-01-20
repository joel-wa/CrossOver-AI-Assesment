class QuestionClass {
  String generalContext;
  String passage;
  String question;
  List<String> possibleAnswers;
  int answer;
  String answerExplanation;

  QuestionClass(this.generalContext, this.passage, this.question,
      this.possibleAnswers, this.answer, this.answerExplanation);
}
