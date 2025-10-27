package com.example.planoroma

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import com.example.planoroma.RoutineWidgetProvider
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.widget/updater"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "updateWidget") {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = ComponentName(context, RoutineWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                // Request that the widget be updated
                appWidgetManager.updateAppWidget(appWidgetIds, null)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
