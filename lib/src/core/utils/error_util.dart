import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart'
    show BuildContext, Colors, ScaffoldMessenger, SnackBar, Text;
import 'package:gravity_group_techquest/src/core/utils/extensions/context_extension.dart';
import 'package:gravity_group_techquest/src/core/utils/logger.dart';
import 'package:gravity_group_techquest/src/core/utils/platform/error_util_vm.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:gravity_group_techquest/src/core/utils/platform/error_util_js.dart';

/// Error util.
sealed class ErrorUtil {
  /// Log the error to the console and to Crashlytics.
  static Future<void> logError(
    Object exception,
    StackTrace stackTrace, {
    String? hint,
    bool fatal = false,
  }) async {
    try {
      if (exception is String) {
        return await logMessage(
          exception,
          stackTrace: stackTrace,
          hint: hint,
          warning: true,
        );
      }
      $captureException(exception, stackTrace, hint, fatal).ignore();
      logger.error(exception, stackTrace: stackTrace);
    } on Object catch (error, stackTrace) {
      logger.error(
        'Error while logging error "$error" inside ErrorUtil.logError',
        stackTrace: stackTrace,
      );
    }
  }

  /// Logs a message to the console and to Crashlytics.
  static Future<void> logMessage(
    String message, {
    StackTrace? stackTrace,
    String? hint,
    bool warning = false,
  }) async {
    try {
      logger.error(message, stackTrace: stackTrace ?? StackTrace.current);
      $captureMessage(message, stackTrace, hint, warning).ignore();
    } on Object catch (error, stackTrace) {
      logger.error(
        'Error while logging error "$error" inside ErrorUtil.logMessage',
        stackTrace: stackTrace,
      );
    }
  }

  /// Rethrows the error with the stack trace.
  static Never throwWithStackTrace(Object error, StackTrace stackTrace) =>
      Error.throwWithStackTrace(error, stackTrace);

  @pragma('vm:prefer-inline')
  static String _localizedError(String fallback, String? localized) =>
      localized ?? fallback;

  // Also we can add current localization to this method
  static String formatMessage(
    BuildContext context,
    Object error, [
    String fallback = 'An error has occurred',
  ]) =>
      switch (error) {
        final String e => e,
        FormatException _ =>
          _localizedError('Invalid format', context.localized.errInvalidFormat),
        TimeoutException _ => _localizedError(
            'Timeout exceeded',
            context.localized.errTimeOutExceeded,
          ),
        UnimplementedError _ => _localizedError(
            'Not implemented yet',
            context.localized.errNotImplementedYet,
          ),
        UnsupportedError _ => _localizedError(
            'Unsupported operation',
            context.localized.errUnsupportedOperation,
          ),
        FileSystemException _ => _localizedError(
            'File system error',
            context.localized.errFileSystemException,
          ),
        AssertionError _ => _localizedError(
            'Assertion error',
            context.localized.errAssertionError,
          ),
        Error _ => _localizedError(
            'An error has occurred',
            context.localized.errAnErrorHasOccurred,
          ),
        Exception _ => _localizedError(
            'An exception has occurred',
            context.localized.errAnExceptionHasOccurred,
          ),
        _ => fallback,
      };

  /// Shows a error snackbar with the given message.
  static void showSnackBar(BuildContext context, Object message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(formatMessage(context, message)),
          backgroundColor: Colors.red,
        ),
      );
}
