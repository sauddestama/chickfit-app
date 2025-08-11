import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

enum LogUtilLevel { debug, info, warning, error }

class LogUtil {
  LogUtil._();

  static const apiExceptionErrorMsg = "api-exception-error";

  static bool get shouldLog => kDebugMode;

  // using logService interface so it more easily to change the dependency tools
  static final LogService _logService = LoggerService();

  static void debug(String message) {
    printLog(message, LogUtilLevel.debug);
  }

  static void info(String message) {
    printLog(message, LogUtilLevel.info);
  }

  static void warning(String message) {
    printLog(message, LogUtilLevel.warning);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    printLog(message, LogUtilLevel.error, error, stackTrace);
  }

  static void networkRequest(
    String method,
    String url, {
    dynamic headers,
    dynamic body,
  }) {
    printLog("📤 [REQUEST] $method $url", LogUtilLevel.info);
    if (headers != null) printLog("🔹 Headers: $headers", LogUtilLevel.info);
    if (body != null) printLog("📦 Body: $body", LogUtilLevel.info);
  }

  static void networkResponse(String url, int statusCode, dynamic data) {
    printLog("📥 [RESPONSE] $statusCode $url", LogUtilLevel.info);
    printLog("📦 Response Data: ${data is Map ? jsonEncode(data) : data}",
        LogUtilLevel.info);
  }

  static void networkError(String url,
      [dynamic error, StackTrace? stackTrace]) {
    printLog(
      "❌ [NETWORK ERROR] $url",
      LogUtilLevel.error,
      error,
      stackTrace,
    );
  }

  static printLog(message, LogUtilLevel level,
      [dynamic error, StackTrace? stackTrace]) {
    if (!shouldLog) return;

    switch (level) {
      case LogUtilLevel.debug:
        _logService.debug(message);
      case LogUtilLevel.info:
        _logService.info(message);
      case LogUtilLevel.warning:
        _logService.warning(message);
      case LogUtilLevel.error:
        _logService.error(message, error, stackTrace);
    }
  }
}

abstract class LogService {
  void debug(String message);

  void info(String message);

  void warning(String message);

  void error(String message, [dynamic error, StackTrace? stackTrace]);
}

class LoggerService implements LogService {
  @override
  void debug(String message) {
    log("DEBUG │ $message ", time: DateTime.now(), level: 500);
  }

  @override
  void info(String message) {
    log("INFO │ $message ", time: DateTime.now(), level: 800);
  }

  @override
  void warning(String message) {
    log("WARNING │ $message ", time: DateTime.now(), level: 900);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, error: error, stackTrace: stackTrace, level: 1000);
  }
}
