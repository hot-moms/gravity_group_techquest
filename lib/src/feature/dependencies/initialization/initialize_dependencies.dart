import 'dart:async';

import 'package:gravity_group_techquest/src/core/utils/logger.dart';
import 'package:gravity_group_techquest/src/feature/dependencies/initialization/platform/initialization_vm.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'package:gravity_group_techquest/src/feature/dependencies/initialization/platform/initialization_js.dart';
import 'package:gravity_group_techquest/src/feature/dependencies/model/dependencies.dart';
import 'package:gravity_group_techquest/src/feature/settings/repository/settings_dao.dart';
import 'package:gravity_group_techquest/src/feature/settings/repository/settings_repository.dart';
import 'package:gravity_group_techquest/src/feature/weather/data_provider/location_provider.dart';
import 'package:gravity_group_techquest/src/feature/weather/data_provider/weather_provider.dart';
import 'package:gravity_group_techquest/src/feature/weather/repository/weather_repository.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

typedef _InitializationStep = FutureOr<void> Function(
  $MutableDependencies dependencies,
);

@internal
mixin InitializeDependencies {
  /// Initializes the app and returns a [Dependencies] object
  @protected
  Future<Dependencies> $initializeDependencies({
    void Function(int progress, String message)? onProgress,
  }) async {
    final steps = _initializationSteps;
    final dependencies = $MutableDependencies();
    final totalSteps = steps.length;
    for (var currentStep = 0; currentStep < totalSteps; currentStep++) {
      final step = steps[currentStep];
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.$1);
      logger.verbose(
        'Initialization | $currentStep/$totalSteps ($percent%) | "${step.$1}"',
      );
      await step.$2(dependencies);
    }
    return dependencies.freeze();
  }

  List<(String, _InitializationStep)> get _initializationSteps =>
      <(String, _InitializationStep)>[
        ('Platform pre-initialization', (_) => $platformInitialization()),
        (
          'Shared Preferences',
          (dep) async =>
              dep.sharedPreferences = await SharedPreferences.getInstance()
        ),
        ('Rest Client', (dep) async => dep.restClient = RestClientBase()),
        (
          'Preferences driver',
          (dep) async => dep.preferencesDriver =
              PreferencesDriver(sharedPreferences: dep.sharedPreferences!)
        ),
        (
          'Settings Repository',
          (deps) async => deps.settingsRepository = SettingsRepository(
                settingsDao: SettingsDao(deps.preferencesDriver!),
              )
        ),
        (
          'Weather Repository',
          (deps) async => deps.weatherRepository = WeatherRepository(
                LocationProvider(),
                WeatherProvider(deps.restClient!),
              )
        ),
      ];
}
