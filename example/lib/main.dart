import 'package:flutter/material.dart';

import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _text = 'Hey man! It\'s me, Bart Simpson! 🙋‍♂️';
  @override
  void initState() {
    super.initState();
    initSuggestions();
  }

  void initSuggestions() async {
    FlutterSiriSuggestions.instance.configure(onLaunch: (Map<String, dynamic> message) async {
      //Awaken from Siri Suggestion
      ///// TO DO : do something!
      String __text;

      switch (message["key"]) {
        case "mainActivity":
          __text = "No Beer 😨";
          break;
        case "beerActivity":
          __text = "Let's Beer Time 🍻";
          break;
        case "searchActivity":
          __text = "Search for meaning...";
          break;
        case "talkActivity":
          __text = "Let's talk about you 😘";
          break;
        default:
          __text = "hmmmm...... made a typo";
      }

      setState(() {
        _text = __text;
      });
    });

    await FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity("Open App 👨‍💻", "mainActivity",
        isEligibleForSearch: true,
        isEligibleForPrediction: true,
        contentDescription: "Did you enjoy that?",
        suggestedInvocationPhrase: "open my app"));

    await FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity(
      "Let's BEER time 🍺",
      "beerActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Frost! 짠!",
      suggestedInvocationPhrase: "coooooool",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Siri Suggestions Sample'),
          ),
          body: Center(
              child: SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Text(_text),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text("add Third Activity"),
                            onPressed: () async {
                              String ret = await FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity("Search 🧐", "searchActivity",
                                  isEligibleForSearch: true,
                                  isEligibleForPrediction: true,
                                  contentDescription: "Search",
                                  suggestedInvocationPhrase: "Search"));
                              print(ret);
                            },
                          ),
                          FlatButton(
                            child: Text("add Fourth Activity"),
                            onPressed: () async {
                              String ret = await FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity(
                                "TALK TALK 💩",
                                "talkActivity",
                                isEligibleForSearch: true,
                                isEligibleForPrediction: true,
                                contentDescription: "TALK TALK",
                                suggestedInvocationPhrase: "Talk",
                              ));
                              print(ret);
                            },
                          )
                        ],
                      )
                    ],
                  )))),
    );
  }
}
