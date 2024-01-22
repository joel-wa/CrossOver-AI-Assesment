import 'package:ai_study/aLocal/LocalServer.dart';
import 'package:ai_study/classes/questionClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerClass {
  LocalServer localServer = LocalServer();
  FirebaseFirestore cloud = FirebaseFirestore.instance;

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

  Future _createPost(String question, String userAns, String ending) async {
    // final Map<String, String> postData = {
    //   'question': question,
    //   'userAns': userAns,
    // };

    final response = await http.post(
      Uri.parse(
          '$url$ending/$question/$userAns'), // Replace with your actual API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
      final parsedData = response.body;
      print(parsedData);
      return parsedData;
    } else {
      return 'System Error ${response.statusCode}';
    }
  }

  String modifyJsonString(String jsonString) {
    // Find the possibleAnswers array in the JSON string
    RegExp exp = RegExp(r'"possibleAnswers": \[.*?\],');
    RegExpMatch? match = exp.firstMatch(jsonString);

    String possibleAnswersStr = match!.group(0)!;
    print(possibleAnswersStr);
    // possibleAnswersStr = possibleAnswersStr.replaceAll("[", replace)
    jsonString = jsonString.replaceAll(possibleAnswersStr, "");

    return jsonString;
  }

  Map<String, dynamic> _convertStringToMap(String jsonString) {
    jsonString = jsonString.replaceAll("'", "\"");
    jsonString = modifyJsonString(jsonString);
    print(jsonString);
    // jsonString = escapeDoubleQuotesInField(jsonString, 'explanation');

    // print("New string is: \n  $jsonString");
    // print(jsonString);
    Map<String, dynamic> resultMap = json.decode(jsonString);
    // print(resultMap["intro"]);
    return resultMap;
  }

  List<String> _convertStringToList(List inputString) {
    // Remove square brackets and split the string into a list
    List<String> values = inputString
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(', ');

    // for (var element in inputString) {
    //   values.add(element.toString());
    // }

    print("Possible answers are:");
    print(values[1]);
    return values;
  }

  getAnswerIndex(var answer, List answers) {
    int val = 0;
    val = answers.indexWhere((element) => element == answer);
    return val;
  }

  QuestionClass _convertMapToQuestion(Map questionMap, String id) {
    // print(questionMap);
    QuestionClass q = QuestionClass(
      '',
      questionMap['intro'],
      questionMap['question'],
      [],
      0,
      "questionMap['explanation']",
      id,
      // questionMap["id"],
    );

    return q;
  }

  Future<QuestionClass> getServerQuestion(
      String questionStandard, String interest) async {
    // String userPrompt = "standard: $questionStandard, my interests:$interest";
    // late QuestionClass questions;

    final results = await newServerGetQuestion(questionStandard, interest);
    // final results = await _newPost(userPrompt, 'getQuestion');
    // print(results);
    final r = _convertMapToQuestion(results["r"], results["id"]);
    QuestionClass question = r;

    return question;
  }

  serverEvaluateAnswer(String question, String ans, String id) async {
    String prompt = '$question/$ans';
    print('prompt is');
    print(prompt);
    print("Question id is: ${id}");
    final response = await getAiReply(question, ans, id);
    print(response);
    final reply = response;
    return reply;
  }

  ///////////Firebase Implementation
  ///
  Future<Map> newServerGetQuestion(
      String questionStandard, String interest) async {
    String id = "43I3AFrQfGQETuV3VxHp";
    late var r;
    CollectionReference questionCollection = cloud.collection("Questions");
    DocumentReference questionDoc = await questionCollection
        .add({"questionDoc": "$questionStandard:$interest"});

    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      var val = await questionDoc.get();
      if (val.exists) {
        Map<String, dynamic> data = val.data() as Map<String, dynamic>;

        // Extract values from the "questionDoc" field
        r = data["Question"];
        id = val.id;

        if (r != null) {
          // Break the loop when the "Question" field is valid
          break;
        }
      }
    }
    // r = {
    //   "intro":
    //       "In a baseball game, there are two teams - the home team and the visiting team. Each team takes turns playing offense and defense. The team on offense tries to score runs, while the team on defense tries to prevent the other team from scoring. Here's a question to test your understanding of baseball:",
    //   "question":
    //       "What is the term for the team that is currently on offense in a baseball game?",
    //   "possibleAnswers":
    //       "[A] Home team, [B] Visiting team, [C] Both teams, [D] Neither team",
    //   "answer": "A",
    //   "explanation":
    //       "The term for the team that is currently on offense in a baseball game is the home team. The visiting team is on defense."
    // };
    return {"r": r, "id": id};
  }

  Future<Map> getAiReply(
    String question,
    String answer,
    String id,
  ) async {
    late var r;
    CollectionReference questionCollection = cloud.collection("Questions");
    DocumentReference questionDoc = questionCollection.doc(id);
    print("ID is $id");
    await questionCollection
        .doc(id)
        .update({"studentResponse": "$question:$answer"});

    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      var val = await questionDoc.get();
      if (val.exists) {
        Map<String, dynamic> data = val.data() as Map<String, dynamic>;

        // Extract values from the "studentResponse" field
        r = data["Evaluation"];

        if (r != null) {
          // Break the loop when the "Evaluation" field is valid
          break;
        }
      }
    }

    return r;
  }
}
