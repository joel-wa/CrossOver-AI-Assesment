import 'package:ai_study/aLocal/LocalServer.dart';
import 'package:ai_study/classes/questionClass.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerClass {
  LocalServer localServer = LocalServer();
  final url = 'http://ec2-3-145-176-115.us-east-2.compute.amazonaws.com:5000/';
  final test = '''
{
  "intro": "In a baseball game, there are two teams - the home team and the visiting team. Each team takes turns playing offense and defense. The team on offense tries to score runs, while the team on defense tries to prevent the other team from scoring. Here's a question to test your understanding of baseball:",
  "question": "What is the term for the team that is currently on offense in a baseball game?",
  "possibleAnswers": "[A] Home team, [B] Visiting team, [C] Both teams, [D] Neither team",
  "answer": "A",
  "explanation": "The term for the team that is currently on offense in a baseball game is the home team. The visiting team is on defense."
}
''';

  Future _newPost(String body, String ending) async {
    String encoded = Uri.encodeFull('$url$ending/$body');
    final response = await http.post(
      Uri.parse(encoded),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      final parsedData = response.body;
      print(parsedData);
      return parsedData;
    } else {
      return 'System Error ${response.statusCode}';
    }
  }

  Future _createPost(
      String question, String userAns, String correctAns, String ending) async {
    final Map<String, String> postData = {
      'question': question,
      'userAns': userAns,
      'correctAns': correctAns,
    };

    final response = await http.post(
      Uri.parse('${url}$ending'), // Replace with your actual API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
      final parsedData = response.body;
      print(parsedData);
      return parsedData;
    } else {
      return 'System Error ${response.statusCode}';
    }
  }

  Map<String, dynamic> _convertStringToMap(String jsonString) {
    Map<String, dynamic> resultMap = json.decode(jsonString);
    print(resultMap);
    return resultMap;
  }

  List<String> _convertStringToList(List inputString) {
    // Remove square brackets and split the string into a list
    List<String> values = [];
    // inputString.toString().replaceAll('[', '').replaceAll(']', '').split(', ');

    for (var element in inputString) {
      values.add(element.toString());
    }

    print("Possible answers are:");
    print(values[1]);
    return values;
  }

  getAnswerIndex(var answer, List answers) {
    int val = 0;
    val = answers.indexWhere((element) => element == answer);
    return val;
  }

  QuestionClass _convertMapToQuestion(Map questionMap) {
    List<String> pa = _convertStringToList(questionMap['possibleAnswers']);
    QuestionClass q = QuestionClass(
      '',
      // questionMap['passage'],
      questionMap['intro'],
      questionMap['question'],
      pa,
      getAnswerIndex(questionMap['answer'], pa),
      questionMap['explanation'],
    );

    return q;
  }

  Future<QuestionClass> getServerQuestion(
      String questionStandard, String interest) async {
    String userPrompt = "standard: $questionStandard, my interests:$interest";
    // late QuestionClass questions;

    // final results = ;
    final results = await _newPost(userPrompt, 'getQuestion');
    print(results);
    final r = _convertMapToQuestion(_convertStringToMap(results));
    QuestionClass question = r;

    return question;
  }

  Future<String> userAnweredWrongly(
      String question, String ans, String rightAns) async {
    String prompt = '$question/$ans/$rightAns';
    print('prompt is');
    print(prompt);
    String response =
        await _createPost(question, ans, rightAns, "evaluateAnswer");

    return response;
  }
}
