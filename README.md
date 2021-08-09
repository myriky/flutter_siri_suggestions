# flutter_siri_suggestions

Flutter plugin for exposure on Siri Suggestions.

<img src="https://img.shields.io/pub/v/flutter_siri_suggestions.svg" />
<img src="https://img.shields.io/github/license/myriky/flutter_siri_suggestions" />

Note: This plugin only work in iOS.

<img width="200" src="https://user-images.githubusercontent.com/581861/68270186-e29d9680-009f-11ea-943e-50dc511c0858.png"><img width="200" src="https://user-images.githubusercontent.com/581861/68270188-e29d9680-009f-11ea-8729-a1ed7f4befa2.png"><img width="200" src="https://user-images.githubusercontent.com/581861/68270221-f812c080-009f-11ea-9be2-18d5bbf8f3b7.png">

## Getting Started

Add [flutter_siri_suggestions](https://pub.dev/packages/flutter_siri_suggestions) as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Check out the example directory for a sample app.

## Usage

Import the library via

```dart
import 'package:flutter_siri_suggestions/flutter_siri_suggestions.dart';
```

Example :

```dart

await FlutterSiriSuggestions.instance.buildActivity(
  FlutterSiriActivity(
     "Open App 👨‍💻",
     "mainActivity",
     isEligibleForSearch: true,
     isEligibleForPrediction: true,
     contentDescription: "Did you enjoy that?",
     suggestedInvocationPhrase: "open my app"
  )
);

FlutterSiriSuggestions.instance.configure(
  onLaunch: (Map<String, dynamic> message) async {
      // Awaken from Siri Suggestion
      // message = {title: "Open App 👨‍💻", key: "mainActivity", userInfo: {}}
      // Do what you want :)

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


  }
);
```

call buildActivity method if you want.

---

### suggestedInvocationPhrase

[suggestedInvocationPhrase](https://developer.apple.com/documentation/foundation/nsuseractivity/2976237-suggestedinvocationphrase), only available iOS 12+

<img width="300" src="https://docs-assets.developer.apple.com/published/10619043bf/ac199760-6ff9-489e-a3b9-af84428a1884.png">

enjoy! 💃

---

## Contributors

❤️

| github                                       |
| :------------------------------------------- |
| [**@aaqibism**](https://github.com/aaqibism) |
