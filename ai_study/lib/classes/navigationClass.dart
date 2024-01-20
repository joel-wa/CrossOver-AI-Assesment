import 'package:ai_study/classes/simClass.dart';
import 'package:ai_study/pages/EndQuizPage.dart';
import 'package:ai_study/pages/landingPage.dart';
import 'package:ai_study/pages/questionPage.dart';
import 'package:flutter/material.dart';

class NavClass {
  changePage(String pageName, context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      switch (pageName) {
        case 'LandingPage':
          return LandingPage();
        case 'Question Page':
          return const QuestionPage();
        case 'End':
          return EndQuizScreen(simClass: SimClass());
        default:
          return LandingPage();
      }
    }));
  }
}
