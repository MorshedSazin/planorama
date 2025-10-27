import 'package:flutter/services.dart';

class WidgetUpdater {
  static const MethodChannel _channel = MethodChannel('com.example.widget/updater');

  static Future<void> updateWidget() async {
    try {
      await _channel.invokeMethod('updateWidget');
    } on PlatformException catch (e) {
      print("Failed to update widget: '${e.message}'.");
    }
  }
}
