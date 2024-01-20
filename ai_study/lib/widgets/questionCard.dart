import 'package:ai_study/classes/eventHandler.dart';
import 'package:ai_study/classes/questionClass.dart';
import 'package:ai_study/classes/simClass.dart';
import 'package:ai_study/widgets/answerWrapper.dart';
import 'package:flutter/material.dart';

class QuestionCardWidget extends StatefulWidget {
  QuestionClass question;
  QuestionCardWidget({super.key, required this.question});

  @override
  State<QuestionCardWidget> createState() => _QuestionCardWidgetState(question);
}

class _QuestionCardWidgetState extends State<QuestionCardWidget> {
  QuestionClass q;
  _QuestionCardWidgetState(this.q);

  int selectedAnswer = -1;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              q.generalContext,
            ),
            const SizedBox(height: 20),
            Container(
                color: const Color.fromARGB(255, 221, 221, 221),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                child: Text(q.passage)),
            const SizedBox(height: 20),
            Text(q.question),
            const SizedBox(height: 20),
            Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: q.possibleAnswers.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                        ),
                        child: CheckboxListTile(
                            title: Text(q.possibleAnswers[index]),
                            value: (index == selectedAnswer) ? true : false,
                            onChanged: (value) {
                              setState(() {
                                selectedAnswer = index;
                                EventHandler()
                                    .onUserSelectAnswer(selectedAnswer);
                              });
                            }),
                      );
                    })),
            const SizedBox(
              height: 20,
            ),
            (!isloading)
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      EventHandler().onAnswerSubmitted(q, context);
                    },
                    child: const Text('Submit'),
                  )
                : CircularProgressIndicator(),
          ],
        ));
  }
}
