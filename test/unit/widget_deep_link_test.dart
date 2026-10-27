import 'dart:io';

import 'package:arccore/core/constants/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the Kotlin <-> Dart deep-link contract.
///
/// The launcher hosts live as string literals in the widget providers, so a
/// rename on either side compiles fine and only shows up as a widget tap that
/// silently drops the user on the dashboard. This test fails instead.
void main() {
  final hostPattern = RegExp(r'happydays://([a-zA-Z]+)');

  /// Hosts handled as background actions rather than as a tab change.
  const actionHosts = {'toggle'};

  test('every Kotlin deep-link host is a known tab or action', () {
    final dir = Directory('android/app/src/main/kotlin/com/arccore/arccore');
    final sources = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.kt'))
        .toList();
    expect(sources, isNotEmpty, reason: 'widget providers should be findable');

    final hosts = <String>{};
    for (final file in sources) {
      for (final match in hostPattern.allMatches(file.readAsStringSync())) {
        hosts.add(match.group(1)!);
      }
    }

    expect(hosts, isNotEmpty);
    final known = {...AppConstants.widgetDeepLinkTabs.keys, ...actionHosts};
    expect(hosts.difference(known), isEmpty);
  });

  test('deep-link targets are within the shell and unique per sub-tab', () {
    // The shell has 5 tabs; Focus/Journal holds a sub-tab, so multiple hosts
    // may legitimately share an outer tab as long as their (tab, sub) pair
    // is unique. Hosts with no sub (tab: n, sub: null) may repeat - they are
    // aliases into the same merged screen (e.g. 'dashboard' and 'insights'
    // both land on the single Protocol/Insights tab).
    const tabCount = 5;
    final seenPerTab = <int, Set<int>>{};
    for (final target in AppConstants.widgetDeepLinkTabs.values) {
      expect(target.tab, inInclusiveRange(0, tabCount - 1));
      if (target.sub == null) continue;
      final seen = seenPerTab.putIfAbsent(target.tab, () => {});
      expect(
        seen.add(target.sub!),
        isTrue,
        reason: 'duplicate deep-link sub-target for tab ${target.tab}',
      );
    }
  });

  test('each widget provider is registered for the update fan-out', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    for (final provider in AppConstants.androidWidgetProviders) {
      expect(
        manifest.contains(provider),
        isTrue,
        reason: '$provider is refreshed but never declared',
      );
    }
  });
}
