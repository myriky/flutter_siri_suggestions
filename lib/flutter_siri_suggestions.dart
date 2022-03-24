import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef Future<dynamic> MessageHandler(Map<String, dynamic> message);

class FlutterSiriActivity {
  const FlutterSiriActivity(this.title, this.key,
      {this.contentDescription,
      this.isEligibleForSearch = true,
      this.isEligibleForPrediction = true,
      this.suggestedInvocationPhrase,
      this.persistentIdentifier,
      this.userInfo});

  final String title;
  final String key;
  final String? contentDescription;
  final bool isEligibleForSearch;
  final bool isEligibleForPrediction;
  final String? suggestedInvocationPhrase;
  final String? persistentIdentifier;
  final Map<dynamic, dynamic>? userInfo;

  Map<String, dynamic> asMap() {
    return {
      'title': this.title,
      'key': this.key,
      'userInfo': this.userInfo,
      'contentDescription': this.contentDescription,
      'isEligibleForSearch': this.isEligibleForSearch,
      'isEligibleForPrediction': this.isEligibleForPrediction,
      'suggestedInvocationPhrase': this.suggestedInvocationPhrase,
      'persistentIdentifier': this.persistentIdentifier,
    };
  }

  @override
  String toString() {
    return "[FlutterSiriActivity] title:$title, key:$key, userInfo:$userInfo, contentDescription:$contentDescription, persistentIdentifier:$persistentIdentifier, isEligibleForSearch:$isEligibleForSearch, isEligibleForPrediction:$isEligibleForPrediction";
  }
}

class FlutterSiriSuggestionsResult {
  const FlutterSiriSuggestionsResult({
    required this.key,
    this.persistentIdentifier,
  });

  final String key;
  final String? persistentIdentifier;

  factory FlutterSiriSuggestionsResult.fromMap(Map payload) {
    return FlutterSiriSuggestionsResult(
        key: payload["key"],
        persistentIdentifier: payload["persistentIdentifier"]);
  }

  @override
  String toString() {
    return "[FlutterSiriSuggestionsResult] key:$key, persistentIdentifier:$persistentIdentifier";
  }
}

class FlutterSiriSuggestions {
  FlutterSiriSuggestions._();

  /// Singleton of [FlutterSiriSuggestions].

  static final FlutterSiriSuggestions instance = FlutterSiriSuggestions._();

  static const MethodChannel _channel =
      const MethodChannel('flutter_siri_suggestions');

  late MessageHandler _onLaunchDelegate;

  @Deprecated(
    'Use registerActivity instead.'
    'This feature was deprecated after v2.1.0',
  )
  Future<String> buildActivity(FlutterSiriActivity activity) async {
    debugPrint('[FlutterSiriSuggestions] buildActivity $activity');

    Map ret = await _channel.invokeMethod('becomeCurrent', <String, Object?>{
      'title': activity.title,
      'key': activity.key,
      'contentDescription': activity.contentDescription,
      'isEligibleForSearch': activity.isEligibleForSearch,
      'isEligibleForPrediction': activity.isEligibleForPrediction,
      'suggestedInvocationPhrase': activity.suggestedInvocationPhrase,
      'persistentIdentifier': activity.persistentIdentifier,
      'userInfo': activity.userInfo,
    });

    return ret["key"];
  }

  Future<FlutterSiriSuggestionsResult> registerActivity(
      FlutterSiriActivity activity) async {
    debugPrint('[FlutterSiriSuggestions] addActivity $activity');

    Map ret = await _channel.invokeMethod('becomeCurrent', <String, Object?>{
      'title': activity.title,
      'key': activity.key,
      'contentDescription': activity.contentDescription,
      'isEligibleForSearch': activity.isEligibleForSearch,
      'isEligibleForPrediction': activity.isEligibleForPrediction,
      'suggestedInvocationPhrase': activity.suggestedInvocationPhrase,
      'persistentIdentifier': activity.persistentIdentifier,
      'userInfo': activity.userInfo,
    });
    return FlutterSiriSuggestionsResult.fromMap(ret);
  }

  Future<void> deleteSavedUserActivitiesWithPersistentIdentifiers(
      List<String> identifiersList) async {
    debugPrint(
        '[FlutterSiriSuggestions] deleteSavedUserActivitiesWithPersistentIdentifiers identifiersList:$identifiersList');
    try {
      await _channel.invokeMethod(
          'deleteSavedUserActivitiesWithPersistentIdentifiers',
          identifiersList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSavedUserActivitiesWithPersistentIdentifier(
      String identifier) async {
    debugPrint(
        '[FlutterSiriSuggestions] deleteSavedUserActivitiesWithPersistentIdentifier identifier:$identifier');
    try {
      await _channel.invokeMethod(
          'deleteSavedUserActivitiesWithPersistentIdentifier', identifier);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAllSavedUserActivities() async {
    debugPrint('[FlutterSiriSuggestions] deleteAllSavedUserActivities');
    try {
      _channel.invokeMethod('deleteAllSavedUserActivities');
    } catch (e) {
      print(e);
    }
  }

  void configure({required MessageHandler onLaunch}) {
    _onLaunchDelegate = onLaunch;

    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onLaunch":
        return _onLaunchDelegate(call.arguments.cast<String, dynamic>());
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }
}
