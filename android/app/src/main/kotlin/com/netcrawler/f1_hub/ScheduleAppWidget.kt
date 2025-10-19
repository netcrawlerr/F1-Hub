package com.netcrawler.f1_hub

import android.annotation.SuppressLint
import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.netcrawler.f1_hub.models.ScheduleWidgetDataModel
import com.netcrawler.f1_hub.models.getScheduleWidgetData


class ScheduleAppWidget : GlanceAppWidget() {
    override suspend fun provideGlance(
        context: Context,
        id: GlanceId
    ) {
        val data = getScheduleWidgetData(context)
        provideContent {
            if (data != null) {
                RaceScheduleCard(data)
            } else {
                PlaceholderCard()
            }
        }
    }
}

@SuppressLint("RestrictedApi")
@Composable
private fun RaceScheduleCard(data: ScheduleWidgetDataModel) {
    Row(
        modifier = GlanceModifier
            .fillMaxSize()
            .cornerRadius(10.dp)
            .background(Color(0xFF0D0D0D)),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // --- LEFT PNL ---

        Column(
            modifier = GlanceModifier
                .width(180.dp)
                .fillMaxHeight()
                .padding(horizontal = 16.dp, vertical = 8.dp)
        ) {

            // race Name
            Text(
                text = data.raceName,
                style = TextStyle(
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(Color.White)
                )
            )

            Spacer(modifier = GlanceModifier.defaultWeight())
            // Circuit Name
            Text(
                text = data.circuitName,
                style = TextStyle(
                    fontSize = 12.sp,
                    color = ColorProvider(Color(0xFF4CAF50))
                )
            )

            Spacer(modifier = GlanceModifier.defaultWeight())
            // dt Range
            Text(
                modifier = GlanceModifier.padding(top = 6.dp),
                text = data.dateRange,
                style = TextStyle(
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(Color.Gray)
                )
            )


            Spacer(modifier = GlanceModifier.defaultWeight())

            val lastSession = data.sessions.lastOrNull()
            if (lastSession != null) {
                Row(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .padding(horizontal = 5.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // --- Left ---
                    Text(
                        text = data.round,
                        style = TextStyle(
                            fontSize = 48.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(Color.Gray)
                        )
                    )


                    Spacer(GlanceModifier.defaultWeight())

                    // --- Right ---
                    Column(
                        horizontalAlignment = Alignment.End
                    ) {
                        Text(
                            text = lastSession.label,
                            style = TextStyle(
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Bold,
                                color = ColorProvider(Color.White)
                            )
                        )
                        Text(
                            text = lastSession.time,
                            style = TextStyle(
                                fontSize = 12.sp,
                                color = ColorProvider(Color.LightGray)
                            )
                        )
                    }
                }


            }
        }

        // --- RIGHT PNL ---

        Column(
            modifier = GlanceModifier
                .defaultWeight()
                .fillMaxHeight()
                .background(Color(0xFF1A1A1A))
                .padding(horizontal = 16.dp, vertical = 8.dp)
        ) {

            data.sessions.forEach { session ->
                SessionItem(
                    day = session.day,
                    session = session.label,
                    time = session.time
                )
            }
        }
    }
}


@SuppressLint("RestrictedApi")
@Composable
private fun SessionItem(day: String, session: String, time: String, isUpcoming: Boolean = true) {
    val textColor = if (isUpcoming) Color.White else Color.Gray

    Row(
        modifier = GlanceModifier.padding(bottom = 6.dp),
        verticalAlignment = Alignment.Top
    ) {
        Text(
            text = day,
            style = TextStyle(
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = ColorProvider(textColor)
            )
        )
        Spacer(GlanceModifier.width(12.dp))
        Column(
            modifier = GlanceModifier.defaultWeight()
        ) {
            Text(
                text = session,
                style = TextStyle(
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(textColor)
                )
            )
            Text(
                text = time,
                style = TextStyle(
                    fontSize = 12.sp,
                    color = ColorProvider(Color.DarkGray)
                )
            )
        }
    }
}


@Composable
fun PlaceholderCard() {
    Column() {
        Text("DATA Couldn't be loaded")
    }
}