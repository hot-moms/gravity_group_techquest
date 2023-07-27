import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gravity_group_techquest/src/core/utils/logger.dart';
import 'package:gravity_group_techquest/src/feature/app/widget/app.dart';
import 'package:gravity_group_techquest/src/feature/dependencies/initialization/initialization.dart';
import 'package:gravity_group_techquest/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:gravity_group_techquest/src/feature/settings/widget/settings_scope.dart';

void main() => logger.runLogging(
      () => runZonedGuarded<void>(
        () async {
          final dependencies =
              await InitializationExecutor().call(deferFirstFrame: true);
          runApp(
            DependenciesScope(
              dependencies: dependencies,
              child: const SettingsScope(child: App()),
            ),
          );
        },
        (e, s) => logger.error(
          'Error $e during initialization',
          error: e,
          stackTrace: s,
        ),
      ),
      const LogOptions(

          // handlePrint: true,
          // messageFormatting: LoggerUtil.messageFormatting,
          // outputInRelease: false,
          // printColors: true,
          ),
    );
