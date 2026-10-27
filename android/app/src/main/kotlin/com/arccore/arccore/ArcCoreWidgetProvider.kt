package com.arccore.arccore

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundReceiver
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

/**
 * Shared plumbing for every Happy Days widget.
 */
object WidgetIntents {
    private const val BACKGROUND_ACTION = "es.antonborri.home_widget.action.BACKGROUND"

    /**
     * A background tap that actually survives having siblings.
     *
     * home_widget's own helper builds every PendingIntent with request code 0,
     * so with FLAG_UPDATE_CURRENT a second one overwrites the first and every
     * row ends up firing the same action. Passing a distinct request code per
     * target is what keeps four checkboxes independent.
     */
    fun background(context: Context, uri: Uri, requestCode: Int): PendingIntent {
        val intent = Intent(context, HomeWidgetBackgroundReceiver::class.java)
        intent.data = uri
        intent.action = BACKGROUND_ACTION

        var flags = PendingIntent.FLAG_UPDATE_CURRENT
        if (Build.VERSION.SDK_INT >= 23) {
            flags = flags or PendingIntent.FLAG_IMMUTABLE
        }
        return PendingIntent.getBroadcast(context, requestCode, intent, flags)
    }

    /**
     * Opens the app on a specific screen.
     *
     * Built here rather than through home_widget's helper so each target gets
     * its own request code: that helper uses 0 for everything, and with
     * FLAG_UPDATE_CURRENT any two intents Android considers equivalent collapse
     * into one - so every widget would open whichever screen was registered
     * last.
     */
    fun launch(context: Context, deepLink: String, requestCode: Int): PendingIntent {
        val intent = Intent(context, MainActivity::class.java)
        intent.data = Uri.parse(deepLink)
        intent.action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
        // SINGLE_TOP so an already-running app receives onNewIntent with the new
        // link instead of being brought forward on whatever screen it was on.
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP

        var flags = PendingIntent.FLAG_UPDATE_CURRENT
        if (Build.VERSION.SDK_INT >= 23) {
            flags = flags or PendingIntent.FLAG_IMMUTABLE
        }
        return PendingIntent.getActivity(context, requestCode, intent, flags)
    }
}

/**
 * core_features.home_screen_widgets
 *
 * Display-only surfaces. Each one is a PNG rendered by Flutter, so the
 * claymorphic styling exists once in Dart instead of being reimplemented here
 * and drifting away from the app.
 */
abstract class ArcCoreBaseWidgetProvider(
    private val imageKey: String,
    private val deepLink: String,
    private val launchCode: Int,
) : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val data = HomeWidgetPlugin.getData(context)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.arccore_widget)
            val path = data.getString("${imageKey}_path", null)
            val rendered = path?.let { File(it) }

            if (rendered != null && rendered.exists()) {
                views.setImageViewBitmap(
                    R.id.widget_image,
                    BitmapFactory.decodeFile(rendered.absolutePath),
                )
                views.setViewVisibility(R.id.widget_image, View.VISIBLE)
                views.setViewVisibility(R.id.widget_fallback, View.GONE)
            } else {
                // Before the first render - or if the file was evicted - fall
                // back to text rather than an empty box.
                val day = data.getInt("arc_day", 0)
                val length = data.getInt("arc_length", 0)
                val completed = data.getInt("completed", 0)
                val scheduled = data.getInt("scheduled", 0)

                views.setViewVisibility(R.id.widget_image, View.GONE)
                views.setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                views.setTextViewText(
                    R.id.widget_day,
                    if (length > 0) "Day $day / $length" else "Happy Days",
                )
                views.setTextViewText(
                    R.id.widget_progress,
                    if (scheduled > 0) "$completed of $scheduled done" else "",
                )
            }

            views.setOnClickPendingIntent(
                R.id.widget_root,
                WidgetIntents.launch(context, deepLink, requestCode = launchCode),
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

/** Habit ring - streak gauge plus this week's dots. */
class ArcCoreWidgetProvider :
    ArcCoreBaseWidgetProvider("w_ring", "happydays://dashboard", 3001)

/** The two longest-running habits. */
class ArcCoreStreaksWidgetProvider :
    ArcCoreBaseWidgetProvider("w_streaks", "happydays://dashboard", 3002)

/** A metric habit's progress for the day. */
class ArcCoreMetricWidgetProvider :
    ArcCoreBaseWidgetProvider("w_metric", "happydays://matrix", 3003)

/**
 * Today's checklist - the one widget you can actually tick things off in.
 *
 * Drawn with real RemoteViews rather than a rendered image, because each row
 * needs its own PendingIntent and an ImageView can only carry one.
 */
class ArcCoreTodayWidgetProvider : AppWidgetProvider() {

    private val rowIds = intArrayOf(R.id.row_0, R.id.row_1, R.id.row_2, R.id.row_3)
    private val checkIds =
        intArrayOf(R.id.check_0, R.id.check_1, R.id.check_2, R.id.check_3)
    private val titleIds =
        intArrayOf(R.id.title_0, R.id.title_1, R.id.title_2, R.id.title_3)

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val data = HomeWidgetPlugin.getData(context)
        val count = data.getInt("today_count", 0)
        val remaining = data.getInt("today_remaining", 0)

        appWidgetIds.forEach { widgetId ->
            val views =
                RemoteViews(context.packageName, R.layout.arccore_today_widget)
            views.setTextViewText(R.id.today_count, remaining.toString())

            for (i in rowIds.indices) {
                if (i >= count) {
                    views.setViewVisibility(rowIds[i], View.GONE)
                    continue
                }
                views.setViewVisibility(rowIds[i], View.VISIBLE)

                val id = data.getInt("today_${i}_id", -1)
                val title = data.getString("today_${i}_title", "") ?: ""
                val done = data.getBoolean("today_${i}_done", false)
                val metric = data.getBoolean("today_${i}_metric", false)

                views.setTextViewText(titleIds[i], title)
                views.setImageViewResource(
                    checkIds[i],
                    if (done) R.drawable.ic_check_box_filled
                    else R.drawable.ic_check_box_blank,
                )
                views.setInt(
                    titleIds[i],
                    "setTextColor",
                    context.getColor(
                        if (done) R.color.widget_muted else R.color.widget_ink,
                    ),
                )

                // A habit with a numeric target cannot be completed by a tap -
                // it needs a value - so those rows open the app instead of
                // silently doing the wrong thing.
                val intent =
                    if (metric || id < 0) {
                        WidgetIntents.launch(context, "happydays://matrix", 3011)
                    } else {
                        WidgetIntents.background(
                            context,
                            Uri.parse("happydays://toggle?id=$id"),
                            requestCode = 1000 + i,
                        )
                    }
                views.setOnClickPendingIntent(rowIds[i], intent)
            }

            // Tapping the header opens the full grid rather than the
            // dashboard - that is the screen this widget is a summary of.
            views.setOnClickPendingIntent(
                R.id.today_add,
                WidgetIntents.launch(context, "happydays://matrix", 3010),
            )
            views.setOnClickPendingIntent(
                R.id.today_title,
                WidgetIntents.launch(context, "happydays://matrix", 3010),
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

/**
 * Concentration timer you can start and pause without opening the app.
 *
 * The countdown is a Chronometer so it ticks on its own from a fixed base -
 * a widget cannot run code to update a clock, and broadcasting once a second to
 * redraw a number would be a battery disaster.
 */
class ArcCoreFocusWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val data = HomeWidgetPlugin.getData(context)
        val remaining = data.getInt("focus_remaining_seconds", 0)
        val running = data.getBoolean("focus_running", false)
        val totalMinutes = data.getInt("focus_total_minutes", 25)

        val seconds = if (remaining > 0) remaining else totalMinutes * 60

        appWidgetIds.forEach { widgetId ->
            val views =
                RemoteViews(context.packageName, R.layout.arccore_focus_widget)

            // setChronometerCountDown is API 24+. Below that the Chronometer
            // would count *up* from the base, which is worse than useless on a
            // timer, so those devices get a static "MM:SS" instead.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                views.setChronometerCountDown(R.id.focus_clock, true)
                views.setChronometer(
                    R.id.focus_clock,
                    SystemClock.elapsedRealtime() + seconds * 1000L,
                    null,
                    running,
                )
            } else {
                views.setChronometer(
                    R.id.focus_clock,
                    SystemClock.elapsedRealtime(),
                    null,
                    false,
                )
                views.setTextViewText(
                    R.id.focus_clock,
                    String.format("%02d:%02d", seconds / 60, seconds % 60),
                )
            }

            // Play and pause are separate buttons rather than one toggle: on a
            // home screen you glance, you do not read state before tapping.
            views.setViewVisibility(
                R.id.focus_play,
                if (running) View.GONE else View.VISIBLE,
            )
            views.setViewVisibility(
                R.id.focus_pause,
                if (running) View.VISIBLE else View.GONE,
            )

            views.setOnClickPendingIntent(
                R.id.focus_play,
                WidgetIntents.background(
                    context,
                    Uri.parse("happydays://focus?action=start"),
                    requestCode = 2001,
                ),
            )
            views.setOnClickPendingIntent(
                R.id.focus_pause,
                WidgetIntents.background(
                    context,
                    Uri.parse("happydays://focus?action=pause"),
                    requestCode = 2002,
                ),
            )
            views.setOnClickPendingIntent(
                R.id.focus_stop,
                WidgetIntents.background(
                    context,
                    Uri.parse("happydays://focus?action=stop"),
                    requestCode = 2003,
                ),
            )
            views.setOnClickPendingIntent(
                R.id.widget_root,
                WidgetIntents.launch(context, "happydays://focus", 3020),
            )
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
