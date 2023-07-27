import 'package:gravity_group_techquest/src/core/utils/logger.dart';
import 'package:meta/meta.dart';

/// {@template operation_state}
/// OperationState.
/// {@endtemplate}
sealed class OperationState<OperationEntity extends Object?>
    extends _$OperationStateBase<OperationEntity> {
  static Stream<OperationState<D>> mutateFromFuture<D extends Object?>({
    required Future<D> Function() body,
    Duration endDelay = Duration.zero,
    bool shouldRethrow = false,
  }) async* {
    D? data;
    yield OperationState.processing(data: data);

    try {
      data = await body();

      yield OperationState.successful(data: data);
    } on Object catch (e, s) {
      logger.error(
        'Error $e during mutating state',
        error: e,
        stackTrace: s,
      );
      yield OperationState.error(data: data, error: e);

      if (shouldRethrow) rethrow;
    } finally {
      await Future<void>.delayed(endDelay);
      yield OperationState.idle(data: data);
    }
  }

  /// {@macro operation_state}
  const OperationState({required super.data});

  /// Idling state
  /// {@macro operation_state}
  const factory OperationState.idle({
    required OperationEntity? data,
  }) = OperationState$Idle;

  /// Processing
  /// {@macro operation_state}
  const factory OperationState.processing({
    required OperationEntity? data,
  }) = OperationState$Processing;

  /// Successful
  /// {@macro operation_state}
  const factory OperationState.successful({
    required OperationEntity? data,
  }) = OperationState$Successful;

  /// An error has occurred
  /// {@macro operation_state}
  const factory OperationState.error({
    required OperationEntity? data,
    required Object error,
  }) = OperationState$Error;
}

/// Idling state
/// {@nodoc}
final class OperationState$Idle<OperationEntity extends Object?>
    extends OperationState<OperationEntity> {
  /// {@nodoc}
  const OperationState$Idle({required super.data});
}

/// Processing
/// {@nodoc}
final class OperationState$Processing<OperationEntity extends Object?>
    extends OperationState<OperationEntity> {
  /// {@nodoc}
  const OperationState$Processing({
    required super.data,
  });
}

/// Successful
/// {@nodoc}
final class OperationState$Successful<OperationEntity extends Object?>
    extends OperationState<OperationEntity> {
  /// {@nodoc}
  const OperationState$Successful({
    required super.data,
  });
}

/// Error
/// {@nodoc}
final class OperationState$Error<OperationEntity extends Object?>
    extends OperationState<OperationEntity> {
  final Object error;

  /// {@nodoc}
  const OperationState$Error({
    required super.data,
    required this.error,
  });

  @override
  int get hashCode => data.hashCode ^ error.hashCode;

  @override
  bool operator ==(covariant OperationState$Error other) =>
      data == other.data && error == other.error;
}

/// Pattern matching for [OperationState].
typedef OperationStateMatch<R, S extends OperationState> = R Function(
  S state,
);

/// {@nodoc}
@immutable
abstract base class _$OperationStateBase<OperationEntity extends Object?> {
  /// {@nodoc}
  const _$OperationStateBase({required this.data});

  /// Data entity payload.
  @nonVirtual
  final OperationEntity? data;

  /// Has data?
  bool get hasData => data != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [OperationState].
  R map<R>({
    required OperationStateMatch<R, OperationState$Idle> idle,
    required OperationStateMatch<R, OperationState$Processing> processing,
    required OperationStateMatch<R, OperationState$Successful> successful,
    required OperationStateMatch<R, OperationState$Error> error,
  }) =>
      switch (this) {
        final OperationState$Idle s => idle(s),
        final OperationState$Processing s => processing(s),
        final OperationState$Successful s => successful(s),
        final OperationState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [OperationState].
  R maybeMap<R>({
    OperationStateMatch<R, OperationState$Idle>? idle,
    OperationStateMatch<R, OperationState$Processing>? processing,
    OperationStateMatch<R, OperationState$Successful>? successful,
    OperationStateMatch<R, OperationState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [OperationState].
  R? mapOrNull<R>({
    OperationStateMatch<R, OperationState$Idle>? idle,
    OperationStateMatch<R, OperationState$Processing>? processing,
    OperationStateMatch<R, OperationState$Successful>? successful,
    OperationStateMatch<R, OperationState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
