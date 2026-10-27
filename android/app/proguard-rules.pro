# Isar (community fork) - the generated schemas are reached reflectively from
# native code, so R8 must not strip or rename them.
-keep class com.isar.** { *; }
-keep class dev.isar.** { *; }
-keepclassmembers class * extends java.lang.Object { native <methods>; }

# flutter_local_notifications keeps its receivers alive across a reboot.
-keep class com.dexterous.** { *; }

# home_widget provider is instantiated by the system from the manifest.
-keep class com.arccore.arccore.ArcCore*WidgetProvider { *; }
-keep class com.arccore.arccore.ArcCoreBaseWidgetProvider { *; }
-keep class es.antonborri.home_widget.** { *; }
# The widget interactivity callback is reached only through a raw handle.
-keepclassmembers class * { @pragma <methods>; }

# workmanager entry point.
-keep class be.tramckrijte.workmanager.** { *; }
-keep class dev.fluttercommunity.workmanager.** { *; }

# Keep Flutter's own plugin registrant.
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**
