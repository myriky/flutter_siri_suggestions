import Flutter
import UIKit

public class SwiftFlutterSiriSuggestionsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_siri_suggestions", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSiriSuggestionsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
