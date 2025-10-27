package com.example.planoroma

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class RoutineWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.routine_widget)

        val sharedPreferences = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val routinesJson = sharedPreferences.getString("routines", null)

        val dayOfWeek = SimpleDateFormat("EEEE", Locale.getDefault()).format(Date())
        views.setTextViewText(R.id.day, dayOfWeek)

        if (routinesJson != null) {
            val routines = JSONObject(routinesJson)
            val dayRoutines = routines.optJSONArray(dayOfWeek)

            views.removeAllViews(R.id.routines_container)

            if (dayRoutines != null && dayRoutines.length() > 0) {
                for (i in 0 until dayRoutines.length()) {
                    val routineItem = dayRoutines.getString(i)
                    val itemView = RemoteViews(context.packageName, R.layout.routine_item)
                    itemView.setTextViewText(R.id.routine_text, routineItem)
                    views.addView(R.id.routines_container, itemView)
                }
            } else {
                views.setTextViewText(R.id.day, "No routine for today.")
            }
        } else {
            views.setTextViewText(R.id.day, "No data.")
        }

        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}