import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@immutable
class WeatherData {
  final double? temperature;
  final int? windspeed;
  final int? winddirection;
  final int? weathercode;
  final bool? isDay;
  final String? time;

  const WeatherData({
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.weathercode,
    this.isDay,
    this.time,
  });

  @override
  String toString() =>
      'WeatherData(temperature: $temperature, windspeed: $windspeed, winddirection: $winddirection, weathercode: $weathercode, isDay: $isDay, time: $time)';

  factory WeatherData.fromMap(Map<String, dynamic> data) => WeatherData(
        temperature: (data['temperature'] as num?)?.toDouble(),
        windspeed: data['windspeed'] as int?,
        winddirection: data['winddirection'] as int?,
        weathercode: data['weathercode'] as int?,
        isDay: (data['is_day'] as int?) == 1,
        time: data['time'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'temperature': temperature,
        'windspeed': windspeed,
        'winddirection': winddirection,
        'weathercode': weathercode,
        'is_day': isDay,
        'time': time,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WeatherData].
  factory WeatherData.fromJson(String data) =>
      WeatherData.fromMap(json.decode(data) as Map<String, dynamic>);

  /// `dart:convert`
  ///
  /// Converts [WeatherData] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! WeatherData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      temperature.hashCode ^
      windspeed.hashCode ^
      winddirection.hashCode ^
      weathercode.hashCode ^
      isDay.hashCode ^
      time.hashCode;
}
