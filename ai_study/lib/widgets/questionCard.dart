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

  String userAnswer = '';
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

            // Replace the previous list of possible answers with a TextField
            TextField(
              onChanged: (value) {
                setState(() {
                  userAnswer = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Type your answer here',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            (!isloading)
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      userAnswer = userAnswer.replaceAll("?", "");
                      EventHandler().onAnswerSubmitted(q, context, userAnswer);
                    },
                    child: const Text('Submit'),
                  )
                : const CircularProgressIndicator(),
          ],
        ));
  }
}
