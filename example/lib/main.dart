import 'package:flutter/material.dart';

import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _text = 'added mainActivity, beerActivity suggestions 🙋‍♂️';
  @override
  void initState() {
    super.initState();
    initSuggestions();
  }

  void initSuggestions() async {
    FlutterSiriSuggestions.instance.configure(
        onLaunch: (Map<String, dynamic> message) async {
      //Awaken from Siri Suggestion
      ///// TO DO : do something!
      String __text;

      print("called by ${message['key']} suggestion.");

      switch (message["key"]) {
        case "mainActivity":
          __text = "redirect to mainActivity";
          break;
        case "beerActivity":
          __text = "redirect to beerActivity";
          break;
        case "searchActivity":
          __text = "redirect to searchActivity";
          break;
        case "talkActivity":
          __text = "redirect to talkActivity";
          break;
        default:
          __text = "hmmmm...... made a typo";
      }

      setState(() {
        _text = __text;
      });
    });

    await FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity(
        "mainActivity Suggestion", "mainActivity",
        isEligibleForSearch: true,
        isEligibleForPrediction: true,
        contentDescription: "Open mainActivity",
        suggestedInvocationPhrase: "open my app"));

    await FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity(
      "beerActivity Suggestion",
      "beerActivity",
      isEligibleForSearch: true,
      isEligibleForPrediction: true,
      contentDescription: "Open beerActivity 🍺",
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: Text(_text),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: Text("add searchActivity Suggestion"),
                      onPressed: () async {
                        String ret = await FlutterSiriSuggestions.instance
                            .buildActivity(FlutterSiriActivity(
                          "searchActivity Suggestion",
                          "searchActivity",
                          isEligibleForSearch: true,
                          isEligibleForPrediction: true,
                          contentDescription: "Open searchActivity 🧐",
                          suggestedInvocationPhrase: "Search",
                        ));
                        print("$ret suggestion added.");
                      },
                    ),
                    TextButton(
                      child: Text("add talkActivity Suggestion"),
                      onPressed: () async {
                        String ret = await FlutterSiriSuggestions.instance
                            .buildActivity(FlutterSiriActivity(
                          "talkActivity Suggestion",
                          "talkActivity",
                          isEligibleForSearch: true,
                          isEligibleForPrediction: true,
                          contentDescription: "Open talkActivity 💩",
                          suggestedInvocationPhrase: "Talk",
                        ));
                        print("$ret suggestion added.");
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
