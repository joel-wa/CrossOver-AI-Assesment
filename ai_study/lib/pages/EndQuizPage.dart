import 'package:ai_study/classes/navigationClass.dart';
import 'package:ai_study/pages/landingPage.dart';
import 'package:flutter/material.dart';

import '../classes/simClass.dart';

class EndQuizScreen extends StatefulWidget {
  SimClass simClass;
  EndQuizScreen({super.key, required this.simClass});

  @override
  State<EndQuizScreen> createState() => _EndQuizScreenState(simClass);
}

class _EndQuizScreenState extends State<EndQuizScreen> {
  SimClass simClass;
  _EndQuizScreenState(this.simClass);
  String score = SimClass.user.getTotalScore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Quiz has ended'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $score',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home screen or quiz start screen
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                simClass.reset();
                NavClass().changePage("LandingPage", context);
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
