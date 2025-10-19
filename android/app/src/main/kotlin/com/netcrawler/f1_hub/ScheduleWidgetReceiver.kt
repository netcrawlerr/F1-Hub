package com.netcrawler.f1_hub

import HomeWidgetGlanceWidgetReceiver

class ScheduleWidgetReceiver: HomeWidgetGlanceWidgetReceiver<ScheduleAppWidget> (){
    override val glanceAppWidget: ScheduleAppWidget
        get() = ScheduleAppWidget()

}