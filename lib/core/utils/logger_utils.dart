import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error, debug }

class LoggerService {
  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toString().split(' ').last;
    final prefix = level.name.toUpperCase();
    final tagStr = tag != null ? '[$tag]' : '';

    final fullMessage = '$timestamp $prefix $tagStr: $message';

    if (kDebugMode) {
      print(fullMessage);
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }

    // Also send to developer log for Search/Filter in DevTools
    dev.log(
      message,
      name: tag ?? 'APP',
      level: _getDevLogLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(String message, {String? tag}) =>
      log(message, level: LogLevel.info, tag: tag);

  static void warning(String message, {String? tag}) =>
      log(message, level: LogLevel.warning, tag: tag);

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        message,
        level: LogLevel.error,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  static void debug(String message, {String? tag}) =>
      log(message, level: LogLevel.debug, tag: tag);

  static int _getDevLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 0;
      case LogLevel.warning:
        return 500;
      case LogLevel.error:
        return 1000;
      case LogLevel.debug:
        return 0;
    }
  }
}
