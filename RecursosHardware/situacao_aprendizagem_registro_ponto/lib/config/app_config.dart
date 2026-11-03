import 'package:flutter/foundation.dart';

class AppConfig {
  static const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.isNotEmpty) return _configuredApiBaseUrl;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  static const attendanceRadiusMeters = 100.0;
  static const requestTimeout = Duration(seconds: 12);

  static bool isWithinAttendanceRadius(double distanceMeters) =>
      distanceMeters <= attendanceRadiusMeters;
}
