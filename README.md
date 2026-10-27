# Happy Days — Winter Arc & RPG Stat Tracker

A fully offline, claymorphic habit tracker that turns a 122-day arc into a
character sheet. Built to `arccore_spec_v1.3.0.json`.

No network calls, no account, no backend. Every number is derived on-device
from an embedded Isar database.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## What's here

| Spec phase | Status | Where |
|---|---|---|
| 1. Foundation, Isar DB & localization | done | `lib/data/`, `lib/l10n/` |
| 2. Claymorphic design system | done | `lib/ui/components/`, `lib/core/theme/` |
| 3. Offline notifications engine | done | `lib/core/services/notification_service.dart` |
| 4. Matrix grid & RPG character view | done | `lib/features/matrix/`, `lib/ui/components/stat_radar.dart` |
| 5. Journal, sensors, export | done | `lib/features/journal/`, `pedometer_service.dart` |
| 6. Habit library, custom habits, frequency | done | `lib/features/habit_library/`, `frequency_engine.dart` |
| 7. Gamification depth | done | `lib/domain/engines/`, `lib/features/trophy_hall/` |
| 8. Analytics & Insights Lab | done | `analytics_engine.dart`, `lib/features/analytics/` |
| 9. Platform integrations | Android done, **iOS widget needs Xcode** | `widget_service.dart`, `android/.../ArcCoreWidgetProvider.kt` |
| 10. Data integrity, app lock, backup | done | `backup_service.dart`, `migration_service.dart`, `app_lock_service.dart` |
| 11. Accessibility, localization QA, perf | done | goldens, semantics, `ClayTheme` high-contrast |
| 12. Arc recap, multi-arc, release prep | done | `lib/features/recap/`, `proguard-rules.pro` |

### The six v1.2 gaps the spec called out

1. **Numeric habits could only be a boolean** — `HabitEntry` stores `value`,
   `targetAtTime`, `completionRatio` and `awardedXp`. Metric habits open a
   `ClayStepper` sheet; 8,400 steps records as 8,400 with proportional XP.
2. **No frequency field** — `FrequencyEngine` implements daily / weekly_target /
   specific_days / interval, plus a `notScheduled` cell state. A 4×/week gym
   habit contributes 4 days to the denominator, not 7.
3. **Unbalanced stat XP** — the radar plots normalised 0–100 consistency
   (`StatEngine`), not raw XP. Raw XP is still stored on the profile.
4. **Undefined ARB keys** — all notification keys exist; `flutter gen-l10n`
   runs clean.
5. **No boot reschedule** — `RECEIVE_BOOT_COMPLETED` + the plugin's boot
   receiver, plus a belt-and-braces reschedule on every app foreground.
6. **No migration strategy** — `MigrationService` runs ordered steps inside a
   write transaction before the first read, with tests that assert no record
   loss.

---

## Architecture

```
lib/
  core/        theme (ClayTheme ThemeExtension), constants, services, providers
  data/        Isar models + repositories
  domain/      pure engines (frequency, xp, streak, stat, achievements,
               analytics, level) + TrackerService orchestration + ArcState
  ui/          Clay atomic component library
  features/    one folder per screen
```

**The engines are pure functions over data.** They take lists and maps, return
values, and never touch storage — which is why `test/unit/` can exercise the
whole rule set with no database. `TrackerService` is the only thing that
writes, so derived state is recomputed in exactly one place.

**Nothing derived is trusted from storage.** Streaks, stats, levels and
achievements are recomputed from the logs on every load, which is what makes
"recompute achievements after import so a restored backup unlocks correctly"
true by construction rather than by remembering to call something.

---

## Deviations from the spec, and why

Each of these is a deliberate call, not an oversight.

**`isar_community` instead of `isar`.** The original `isar 3.1.0+1` generator
pins `analyzer <6`; this toolchain is Dart 3.11 / analyzer 8. The maintained
community fork is API-identical (`package:isar_community/isar.dart`). Without
it the spec's stated database simply does not build here.

**Light-mode secondary text is `#5A6678`, not `#718096`.** The spec's own
`contrast_audit_required` note flags `#718096` on `#F0F5FA` at ~4.0:1 as a WCAG
AA failure and says to darken it before ship. Done.

**`flutter_vibrate` is not a dependency.** The spec's `dependency_notes` say to
prefer built-in `HapticFeedback` and reserve `flutter_vibrate` for multi-pulse
patterns. The two multi-pulse patterns (day-complete, achievement) are short
sequences of `HapticFeedback` calls, so the dependency earns nothing.

**Icons go through `AppIcons.resolve()`, not raw `IconData(codePoint)`.**
Models still persist an int, but rendering maps it back to a const `Icons.*`
reference. A raw codepoint that is not in the font renders an arbitrary wrong
glyph silently, and it also defeats icon tree-shaking (the release build shrinks
the icon font by 98.7%).

**`permission_handler` pinned to `^12.0.3`, `flutter_secure_storage` to
`^10.3.1`.** Their newest majors require AGP 9 / Kotlin 2.3 / compileSdk 37,
ahead of this project's Android toolchain. Bump them together with the
toolchain, not alone.

**Weekly-target habits are judged by week in the streak walk.** The spec says
"streak counts weeks satisfied, not days", so `StreakEngine` excludes them from
daily satisfaction and closes them out on Sunday. They still count normally in
the completion-rate denominator via the day snapshot.

**The matrix uses a lazy day-column list, not `TwoDimensionalScrollView`.** The
performance rule that matters — never build all 122 columns eagerly — is met by
making the horizontal axis the lazy one (one item per *day*, each a short column
of habit cells) with a ~20-column `cacheExtent`, a sticky label column, const
`ClayMatrixCell`s, `RepaintBoundary` per cell, and decorations memoised per
(state, colour, radius) in `ClayTheme`. A custom two-dimensional viewport would
add a lot of surface area for the same result at this scale.

---

## Known gaps

These are real and worth stating plainly.

- **iOS home-screen widget.** The Dart side and the whole Android side are
  done — five providers, one per surface, all blitting a PNG that Flutter
  renders. The iOS half needs a WidgetKit extension target and an App Group
  entitlement added to both targets in Xcode; that is a `project.pbxproj` change
  no script should make blind. `AppConstants.appGroupId` is already set.
- **iOS notification sound needs one Xcode step.** `notification.mp3` is copied
  to `ios/Runner/`, but it must be added to the Runner target's *Copy Bundle
  Resources* phase in Xcode or iOS will fall back to the default tone. Android
  is complete (`res/raw/notification.mp3`, wired to every reminder channel).
- **Translations cover 4 of the 43 offered languages.** English, Hindi, Tamil
  and Spanish have real ARB files; the picker marks those "Translated". The
  other 39 are selectable and fall back to English string by string, while
  Material's own widgets still localise wherever Flutter ships a translation.
  This is deliberate — a bad machine translation is worse than a clear fallback
  — but it is a gap, not a finished feature.
- **`workmanager` cannot render the widget images.** The background isolate has
  no rendering surface, so it pushes the scalar data (which the native layouts
  and the text fallback use) and the PNGs refresh on the next foreground. The
  two interactive widgets are unaffected — they are drawn natively.
- **iOS widgets are display-only.** Interactive widgets on iOS need AppIntents
  and iOS 17+; below that a tap can only deep-link. The Android interactivity
  described below has no iOS counterpart yet.
- **Lottie assets are not bundled.** Celebrations use Material glyphs plus
  `confetti`; `assets/lottie/` is declared and ready.
- **Hidden, not removed.** App lock, the backup/restore panel and background
  refresh are built, tested and still compiled in — they are switched off in
  `SettingsVisibility` in `lib/features/settings/settings_screen.dart`. Flip a
  flag to bring one back.
- **Release APK is large** because Isar ships native libraries for every ABI.
  Use `flutter build apk --split-per-abi` (or an app bundle) to distribute.
- **Release signing uses the debug key.** Replace `signingConfig` in
  `android/app/build.gradle.kts` before shipping.
- **Not profiled on a low-end device.** Verified on a Pixel 7a and a Pixel 9a
  emulator only. Shadow and blur cost is where this design will hurt, and it
  will not show up on good hardware.

## Home-screen widgets

Five surfaces, in two deliberately different styles.

**Display-only** (habit ring, streaks, metric progress) are PNGs rendered by
Flutter from the same widgets the app uses, so the styling exists once and
cannot drift. The native provider only blits the image.

**Interactive** (Today's checklist, focus timer) are drawn with real
RemoteViews. An image can carry exactly one tap target, so ticking off an
individual habit — or starting a timer — is impossible with the PNG approach.
This is the one place duplicating a little styling in XML buys something real.

How a tap becomes a change:

1. Each row gets a `PendingIntent` with its **own request code**. `home_widget`'s
   helper hard-codes request code 0, so with `FLAG_UPDATE_CURRENT` a second
   intent silently overwrites the first and every row fires the same action.
2. The broadcast wakes `HomeWidgetBackgroundReceiver`, which starts a fresh Dart
   isolate and calls `widgetInteractionCallback`.
3. That opens its own Isar handle, applies the change, republishes the widget
   state, and closes up — closing only the handle it opened, so calling the same
   code from the foreground cannot pull the database out from under the UI.

The focus timer is shared state, not two timers. `FocusSessionStore` keeps
`total / banked / startedAt` in the home-widget container where Kotlin can read
it directly, and elapsed time is always derived from the wall-clock anchor. So a
session started on the home screen keeps running with nothing on screen, and the
app adopts it on resume. Play, pause and stop are all on the widget; stop banks
the minutes exactly as the in-app button does, because both go through the same
`FocusSessionStore`. The widget counts down with a `Chronometer` rather than a
re-broadcast per second, which would be brutal on battery.

**Refreshing.** `HomeWidget.updateWidget` targets one provider at a time, so
`WidgetService.update()` fans out over `AppConstants.androidWidgetProviders`.
Refreshing only the first one is why Today's checklist sat empty until Android's
own half-hourly refresh happened to come round.

**Where a tap lands.** Each surface deep-links to the tab it is about — the
checklist to Matrix, the timer to Focus, the rings to Protocol — via
`widgetDeepLinkTabs`. Two things had to be true for that to stick:

- The selected tab lives in `shellTabProvider`, not in `State`. Launching from a
  widget recreates the Activity, and an index held in `State` was reset to the
  dashboard immediately after the deep link had correctly set it.
- The launch intent is consumed once (`_launchLinkConsumed`). Android leaves it
  attached to the Activity, so re-reading it on resume replayed the same link
  and dragged the user back to that widget's tab every time they returned. Taps
  arriving while the app is alive come down `widgetClicked` instead.

`test/unit/widget_deep_link_test.dart` scrapes the `happydays://` literals out
of the Kotlin providers and fails if a host is not a known tab or action, since
a rename on either side compiles cleanly and only shows up as a misrouted tap.

## Tests

```bash
flutter test                       # everything (189 tests)
flutter test test/unit             # pure engines, no database
flutter test test/integration      # real Isar in a temp directory
flutter test test/golden --update-goldens
```

- **Unit** — level curve and rank boundaries (9/10, 49/50), XP with partial
  credit and multipliers, `effectiveDateKey` across rollover and DST, all four
  frequency types, the streak/shield engine, stat normalisation with
  mixed-frequency habits, the achievement evaluator, backup checksums.
- **Integration** — Isar CRUD, the v1.2→v1.3 migration (seeds the old shape,
  asserts no record loss), a full backup → wipe → restore round trip with
  checksum and passphrase guards, and end-to-end writes through
  `TrackerService`.
- **Golden** — every Clay atom across light/dark × all six surface states, all
  four matrix cell states, high contrast, 200% text scale, and one dense panel
  per locale (en/ta/es/hi) to catch overflow.

Bugs found by running the app on a physical Pixel 7a, now covered by tests:

1. Mutating settings during startup disposed and recreated the arc-state
   notifier, flashing the boot skeleton over the whole app. Settings are now
   *listened* to, not watched, and resolved state is never replaced by the
   skeleton.
2. Isar returns **fixed-length** lists for embedded collections, so
   `entries.removeWhere(...)` threw on the second write to any day.
   `TrackerService.logHabit` now rebuilds the list.
3. `saveJournal` never ran the achievement evaluator, so `gratitude_100` could
   not advance no matter how many entries were written.
4. Journal photos were stored at the `image_picker` cache path, which the OS
   purges — they are now copied into the app's documents directory first.
5. `renderFlutterWidget` reuses one detached render boundary, so growing the
   canvas mid-batch left it needing a repaint and silently dropped the widest
   widget. Surfaces are now rendered largest-first.
6. A false-negative notification-permission probe (`areNotificationsEnabled()`
   returning null, defaulted to `false`) showed a phantom "notifications are
   blocked" warning.
7. `WidgetService.update()` refreshed a single provider, so Today's checklist
   rendered but never appeared on the launcher.
8. Widget deep links were applied and then immediately undone by the Activity
   being recreated, and afterwards replayed on every resume.
9. Two FABs live simultaneously inside the shell's `IndexedStack`, which threw
   "multiple heroes share the same tag" as soon as a deep link made both
   reachable. Both now carry explicit `heroTag`s.
10. `_GaugePainter` sized its arc off `size.width`, so on the wide metric
    surface the ring overlapped the day strip.
Regression tests live in `test/integration/tracker_service_test.dart` and
`test/unit/focus_controller_test.dart`.

---

## Permissions

Requested at the moment of intent, never up front — `permissions_matrix`
principle.

| Permission | Requested when |
|---|---|
| `POST_NOTIFICATIONS` | onboarding primer, then the system dialog |
| `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` | Settings → Exact alarms; degrades to inexact |
| `RECEIVE_BOOT_COMPLETED` | manifest only |
| `ACTIVITY_RECOGNITION` | first time the steps habit is enabled |
| `USE_BIOMETRIC` | when app lock is turned on |

`PermissionService.aggressiveOemName()` detects Xiaomi/Oppo/Vivo/Realme/
OnePlus-class builds and surfaces a battery-optimisation primer naming the
actual manufacturer.
