import 'package:gravity_group_techquest/src/feature/weather/model/weather_data.dart';
import 'package:gravity_group_techquest/src/feature/weather/repository/weather_repository.dart';
import 'package:gravity_group_techquest/src/shared/state/operation_state.dart';
import 'package:streamed_controller/streamed_controller.dart';

final class WeatherController
    extends BaseStreamedController<OperationState<WeatherData>>
    with StreamedSingleSubMixin, RestartableConcurrencyMixin {
  WeatherController({required IWeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(initialState: const OperationState.idle(data: null));

  final IWeatherRepository _weatherRepository;

  void updateWeather() => handle(
        OperationState.mutateFromFuture<WeatherData>(
          body: _weatherRepository.getWeatherData,
          endDelay: const Duration(milliseconds: 600),
        ),
      );
}
