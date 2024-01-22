import 'package:ai_study/classes/eventHandler.dart';
import 'package:ai_study/classes/navigationClass.dart';
import 'package:ai_study/classes/simClass.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String selectedStandard = '4th Grade Common Core Writing Standard';
  TextEditingController interestController =
      TextEditingController(text: 'Baseball');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SimClass().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your AI study Assistant -v1"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Joel Assiakwa\'s AI Study Prototype',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select the standard of questions you want, to get practice questions:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                // List of standards
                standardOption('4th Grade Common Core Writing Standard'),
                standardOption(
                    'Common Core State Standards (CCSS) for English Language Arts'),
                standardOption(
                    'National Assessment of Educational Progress (NAEP)'),

                // Text field for user's interest
                const SizedBox(height: 20),
                TextField(
                  controller: interestController,
                  onChanged: (value) {
                    EventHandler().onChangeUserInterest(value);
                    print(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Type in your interest',
                  ),
                ),

                // Begin Button
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    NavClass().changePage('Question Page', context);
                  },
                  child: const Text("Begin"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget standardOption(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: (selectedStandard == title),
      onChanged: (value) {
        setState(() {
          selectedStandard = title;
          EventHandler().onStandardSelected(title);
        });
      },
    );
  }
}
