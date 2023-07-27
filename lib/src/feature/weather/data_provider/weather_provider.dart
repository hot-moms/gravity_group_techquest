import 'package:gravity_group_techquest/src/feature/weather/model/weather_data.dart';
import 'package:rest_client/rest_client.dart';

abstract interface class IWeatherProvider {
  Future<WeatherData> fetchByCoords((double, double) coordinates);
}

class WeatherProvider implements IWeatherProvider {
  final RestClient restClient;

  const WeatherProvider(this.restClient);

  @override
  Future<WeatherData> fetchByCoords((double, double) coordinates) async {
    final (inputLat, inputLong) = coordinates;

    final response = await restClient.get(
      'https://api.open-meteo.com/v1/forecast?latitude=$inputLat&longitude=$inputLong&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m',
    );

    return WeatherData.fromMap(response);
  }
}
