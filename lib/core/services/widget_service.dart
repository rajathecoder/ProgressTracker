import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_widget/home_widget.dart';

import '../constants/app_constants.dart';

/// core_features.home_screen_widgets
///
/// The spec's key implementation decision: render the clay surfaces with
/// `HomeWidget.renderFlutterWidget()` into the shared container as a PNG rather
/// than reimplementing dual-shadow claymorphism in SwiftUI and Jetpack Glance.
/// One source of visual truth.
class WidgetService {
  WidgetService();

  bool get supported => Platform.isAndroid || Platform.isIOS;

  Future<void> init() async {
    if (!supported) return;
    try {
      await HomeWidget.setAppGroupId(AppConstants.appGroupId);
    } catch (e) {
      debugPrint('ArcCore: app group not configured ($e)');
    }
  }

  /// Renders a Flutter widget to a PNG in the shared container and stores its
  /// path under [key], so the native widget just draws an ImageView.
  Future<void> renderSurface(
    Widget widget, {
    required String key,
    required Size size,
  }) async {
    if (!supported) return;

    // renderFlutterWidget rasterises through a detached pipeline and asserts
    // if the layer has not finished painting. Waiting for the frame to commit
    // fixes most of it; a second attempt covers the rest, which is cheaper and
    // far less brittle than trying to predict when the pipeline is settled.
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        await SchedulerBinding.instance.endOfFrame;
        if (attempt > 0) {
          await Future<void>.delayed(const Duration(milliseconds: 120));
        }
        final path = await HomeWidget.renderFlutterWidget(
          widget,
          key: key,
          logicalSize: size,
          pixelRatio: 3,
        );
        await HomeWidget.saveWidgetData<String>('${key}_path', path);
        return;
      } catch (e) {
        if (attempt == 1) {
          // A failed render is cosmetic: the native provider falls back to its
          // text layout, so this must never take the app down with it.
          debugPrint('ArcCore: widget render failed for $key ($e)');
        }
      }
    }
  }

  /// Renders a batch, then refreshes the launcher once at the end rather than
  /// after every single surface.
  Future<void> renderBatch(Map<String, (Widget, Size)> surfaces) async {
    if (!supported) return;
    // Widest first, deliberately.
    //
    // renderFlutterWidget reuses a single detached render boundary across
    // calls. Growing the canvas mid-batch leaves that boundary needing a
    // repaint when toImage runs, which asserts `!debugNeedsPaint` and drops the
    // surface - reproducibly, and only for whichever surface was the widest.
    // Rendering large-to-small means the boundary only ever shrinks.
    final ordered = surfaces.entries.toList()
      ..sort((a, b) => b.value.$2.width.compareTo(a.value.$2.width));
    for (final entry in ordered) {
      final (widget, size) = entry.value;
      await renderSurface(widget, key: entry.key, size: size);
    }
    await update();
  }

  /// Tells every provider to redraw.
  ///
  /// updateWidget targets a single provider, so this has to fan out - missing
  /// one means that widget silently keeps stale content until Android's own
  /// half-hourly refresh happens to fire.
  Future<void> update() async {
    if (!supported) return;
    if (Platform.isIOS) {
      try {
        await HomeWidget.updateWidget(iOSName: AppConstants.iOSWidgetName);
      } catch (e) {
        debugPrint('Happy Days: widget update failed ($e)');
      }
      return;
    }
    for (final provider in AppConstants.androidWidgetProviders) {
      try {
        await HomeWidget.updateWidget(androidName: provider);
      } catch (e) {
        debugPrint('Happy Days: widget update failed for $provider ($e)');
      }
    }
  }

  /// Below iOS 17 the widget is display-only and taps deep-link into the app
  /// (home_screen_widgets.interactivity_caveat). This is the deep-link hook.
  Future<Uri?> initiallyLaunchedFromWidget() async {
    if (!supported) return null;
    try {
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (_) {
      return null;
    }
  }

  Stream<Uri?> get widgetClicked => HomeWidget.widgetClicked;
}
