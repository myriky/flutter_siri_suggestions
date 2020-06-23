import 'package:flutter/material.dart';

import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initSuggestions();
  }

  void initSuggestions() async {
    FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity("Open App 👨‍💻", "firstActivity",
        isEligibleForSearch: true,
        isEligibleForPrediction: true,
        contentDescription: "Did you enjoy that?",
        suggestedInvocationPhrase: "open my app"));

    FlutterSiriSuggestions.instance.configure(onLaunch: (Map<String, dynamic> message) async {
      //Awaken from Siri Suggestion

      ///// TO DO : do something!
      if (message["key"] == "firstActivty") {
        //firstSiriActivity
      } else if (message["key"] == "secondActivity") {
        //secondSiriActivity
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Siri Suggestions Sample'),
        ),
        body: Center(
          child: Text('Hey man! It\'s me, Bart Simpson! 🙋‍♂️'),
        ),
      ),
    );
  }
}
