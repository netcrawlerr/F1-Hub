package com.netcrawler.f1_hub


import HomeWidgetGlanceWidgetReceiver

class NextRaceWidget : HomeWidgetGlanceWidgetReceiver<NextRaceAppWidget>() {

    override val glanceAppWidget: NextRaceAppWidget
        get() = NextRaceAppWidget()
}