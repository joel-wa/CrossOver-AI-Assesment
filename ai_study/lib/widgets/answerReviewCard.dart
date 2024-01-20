import 'package:ai_study/classes/eventHandler.dart';
import 'package:ai_study/classes/questionClass.dart';
import 'package:flutter/material.dart';

class AnswerReviewCard extends StatelessWidget {
  QuestionClass q;
  int userAns;
  AnswerReviewCard({super.key, required this.q, required this.userAns});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionCardWidget(q),
              const SizedBox(height: 20),
              const Text(
                'Your answer: ',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Text(q.possibleAnswers[userAns])),
              const SizedBox(height: 40),
              (userAns != q.answer)
                  ?
                  //User selected wrong answer
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sorry, incorrect...'),
                        const SizedBox(height: 10),
                        const Text(
                          'The correct Answer is...',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: Text(q.possibleAnswers[q.answer])),
                        const SizedBox(height: 20),
                        const Text(
                          'Explanation',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                          ),
                          child: Text(q.answerExplanation),
                        ),
                      ],
                    )
                  : Container(
                      child: const Text(
                        'Excellent !!!',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                        ),
                      ),
                    ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    EventHandler().onProceed(context);
                  },
                  child: const Text('Proceed'))
            ],
          ),
        ));
  }

  QuestionCardWidget(QuestionClass q) {
    return Column(
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
                    child: ListTile(
                      tileColor:
                          (index == userAns) ? Colors.lightBlue : Colors.white,
                      title: Text(q.possibleAnswers[index]),
                    ),
                  );
                })),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
