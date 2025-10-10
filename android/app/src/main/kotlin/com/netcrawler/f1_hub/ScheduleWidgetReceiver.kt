package com.netcrawler.f1_hub

import HomeWidgetGlanceWidgetReceiver

class ScheduleWidgetReceiver: HomeWidgetGlanceWidgetReceiver<LazyCounterWidget> (){
    override val glanceAppWidget: LazyCounterWidget
        get() = LazyCounterWidget()

}