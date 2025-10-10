package com.netcrawler.f1_hub.models

import android.content.Context
import com.google.gson.Gson

data class ScheduleWidgetDataModel(
    val round: String,
    val raceName: String,
    val circuitName: String,
    val country: String,
    val dateRange: String,
    val sessions: List<WidgetSession>
)

data class WidgetSession(
    val label: String,
    val day: String,
    val time: String
)

fun getScheduleWidgetData(context: Context): ScheduleWidgetDataModel? {
    val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    val json = prefs.getString("flutter.race_widget_data", null)

    return json?.let {
        Gson().fromJson(it, ScheduleWidgetDataModel::class.java)
    }
}