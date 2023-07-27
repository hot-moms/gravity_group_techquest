import 'package:gravity_group_techquest/src/core/controller/controller.dart';
import 'package:gravity_group_techquest/src/core/utils/logger.dart';

class ControllerObserver implements IControllerObserver {
  @override
  void onCreate(IController controller) {
    logger.verbose('Controller | ${controller.runtimeType} | Created');
  }

  @override
  void onDispose(IController controller) {
    logger.verbose('Controller | ${controller.runtimeType} | Disposed');
  }

  @override
  void onStateChanged(
    IController controller,
    Object prevState,
    Object nextState,
  ) {
    logger.debug(
      'Controller | ${controller.runtimeType} | $prevState -> $nextState',
    );
  }

  @override
  void onError(IController controller, Object error, StackTrace stackTrace) {
    logger.error(
      'Controller | ${controller.runtimeType} | $error',
      stackTrace: stackTrace,
    );
  }
}
