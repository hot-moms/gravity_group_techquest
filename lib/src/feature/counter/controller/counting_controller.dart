import 'package:streamed_controller/streamed_controller.dart';

final class CounterController extends BaseStreamedController<int>
    with ConcurrentConcurrencyMixin {
  CounterController({this.bounds = (0, 10)})
      : assert(bounds.$1 < bounds.$2),
        super(initialState: 0);

  final (int, int) bounds;

  bool get isMaximum => state == bounds.$2;
  bool get isMinimum => state == bounds.$1;

  void increment() => _mutate((state) => state + 1);
  void decrement() => _mutate((state) => state - 1);

  void _mutate(int Function(int) mutator) => handle(() async* {
        final newState = mutator(state);
        final (lowerBound, upperBound) = bounds;

        yield newState.clamp(lowerBound, upperBound);
      }());
}
