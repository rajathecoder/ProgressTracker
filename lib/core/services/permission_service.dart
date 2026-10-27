import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// permissions_matrix.principle
///
/// "Never request a permission at onboarding for a feature the user has not yet
/// chosen to use. Ask at the moment of intent - acceptance rates roughly double
/// and the denial is recoverable."
class PermissionService {
  PermissionService();

  Future<bool> requestNotifications() async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> notificationsGranted() async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    return Permission.notification.isGranted;
  }

  /// Requested only when the steps habit is first enabled, never at onboarding.
  Future<bool> requestActivityRecognition() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<bool> activityRecognitionGranted() async {
    if (!Platform.isAndroid) return true;
    return Permission.activityRecognition.isGranted;
  }

  Future<void> openSettings() => openAppSettings();

  /// edge_case_handling.aggressive_oem_battery_management
  ///
  /// Xiaomi, Oppo, Vivo, Realme and OnePlus builds routinely kill background
  /// alarms. Detect the manufacturer so the primer names the actual setting the
  /// user has to find.
  static const Set<String> aggressiveOems = {
    'xiaomi',
    'redmi',
    'poco',
    'oppo',
    'realme',
    'vivo',
    'oneplus',
    'iqoo',
    'huawei',
    'honor',
    'meizu',
    'tecno',
    'infinix',
  };

  Future<String?> aggressiveOemName() async {
    if (!Platform.isAndroid) return null;
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final manufacturer = info.manufacturer.toLowerCase();
      final brand = info.brand.toLowerCase();
      for (final oem in aggressiveOems) {
        if (manufacturer.contains(oem) || brand.contains(oem)) {
          return info.manufacturer;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }
}
