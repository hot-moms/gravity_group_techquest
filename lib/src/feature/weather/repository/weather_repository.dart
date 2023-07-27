import 'package:gravity_group_techquest/src/feature/weather/data_provider/location_provider.dart';
import 'package:gravity_group_techquest/src/feature/weather/data_provider/weather_provider.dart';
import 'package:gravity_group_techquest/src/feature/weather/model/weather_data.dart';

abstract interface class IWeatherRepository {
  ILocationProvider get locationProvider;
  IWeatherProvider get weatherProvider;

  Future<WeatherData> getWeatherData();
}

class WeatherRepository implements IWeatherRepository {
  @override
  final ILocationProvider locationProvider;
  @override
  final IWeatherProvider weatherProvider;

  WeatherRepository(this.locationProvider, this.weatherProvider);

  @override
  Future<WeatherData> getWeatherData() async {
    final coords = await locationProvider.getMyPosition();
    final data = await weatherProvider.fetchByCoords(coords);

    return data;
  }
}
