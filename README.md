# flutter_siri_suggestions

Flutter plugin for exposure on Siri Suggestions.

Note: This plugin only work in iOS.

<img width="300" src="https://user-images.githubusercontent.com/581861/68270186-e29d9680-009f-11ea-943e-50dc511c0858.png">

<img width="300" src="https://user-images.githubusercontent.com/581861/68270221-f812c080-009f-11ea-9be2-18d5bbf8f3b7.png">

<img width="300" src="https://user-images.githubusercontent.com/581861/68270188-e29d9680-009f-11ea-8729-a1ed7f4befa2.png">

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
FlutterSiriSuggestions.instance.buildActivity(FlutterSiriActivity(
        "Open App 👨‍💻",
        isEligibleForSearch: true,
        isEligibleForPrediction: true,
        contentDescription: "Did you enjoy that?",
        suggestedInvocationPhrase: "open my app"));

    FlutterSiriSuggestions.instance.configure(
        onLaunch: (Map<String, dynamic> message) async {
      //Awaken from Siri Suggestion

      //Do what you want :)
    });
```

```dart
static void launch({String androidAppId, String iOSAppId}) async {
    await _channel.invokeMethod(
        'openappstore', {'android_id': androidAppId, 'ios_id': iOSAppId});
  }
```

call buildActivity method if you want.

---

### suggestedInvocationPhrase

[suggestedInvocationPhrase](https://developer.apple.com/documentation/foundation/nsuseractivity/2976237-suggestedinvocationphrase), only available iOS 12+

<img width="300" src="https://docs-assets.developer.apple.com/published/10619043bf/ac199760-6ff9-489e-a3b9-af84428a1884.png">


enjoy! 💃
