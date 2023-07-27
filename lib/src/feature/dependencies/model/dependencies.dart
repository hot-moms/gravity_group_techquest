import 'package:gravity_group_techquest/src/feature/settings/repository/settings_repository.dart';
import 'package:gravity_group_techquest/src/feature/weather/repository/weather_repository.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typed_preferences/typed_preferences.dart';

abstract interface class DependenciesBase {}

class Dependencies implements DependenciesBase {
  Dependencies({
    required this.settingsRepository,
    required this.weatherRepository,
  });
  final IWeatherRepository weatherRepository;
  final ISettingsRepository settingsRepository;
}

class $MutableDependencies implements DependenciesBase {
  IWeatherRepository? weatherRepository;
  ISettingsRepository? settingsRepository;

  SharedPreferences? sharedPreferences;
  PreferencesDriver? preferencesDriver;

  RestClient? restClient;

  Dependencies freeze() => Dependencies(
        weatherRepository: weatherRepository!,
        settingsRepository: settingsRepository!,
      );

  $MutableDependencies();
}
