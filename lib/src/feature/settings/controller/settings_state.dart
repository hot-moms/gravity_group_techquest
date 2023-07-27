import 'package:gravity_group_techquest/src/feature/settings/model/settings_model.dart';
import 'package:meta/meta.dart';

/// {@template settings_state}
/// SettingsState.
/// {@endtemplate}
sealed class SettingsState extends _$SettingsStateBase {
  /// {@macro settings_state}
  const SettingsState({required super.data});

  /// Idling state
  /// {@macro settings_state}
  const factory SettingsState.idle({
    required SettingsEntity data,
  }) = SettingsState$Idle;

  /// Processing
  /// {@macro settings_state}
  const factory SettingsState.processing({
    required SettingsEntity data,
  }) = SettingsState$Processing;

  /// Successful
  /// {@macro settings_state}
  const factory SettingsState.successful({
    required SettingsEntity data,
  }) = SettingsState$Successful;

  /// An error has occurred
  /// {@macro settings_state}
  const factory SettingsState.error({
    required SettingsEntity data,
    required Object error,
  }) = SettingsState$Error;
}

/// Idling state
/// {@nodoc}
final class SettingsState$Idle extends SettingsState with _$SettingsState {
  /// {@nodoc}
  const SettingsState$Idle({required super.data});
}

/// Processing
/// {@nodoc}
final class SettingsState$Processing extends SettingsState
    with _$SettingsState {
  /// {@nodoc}
  const SettingsState$Processing({
    required super.data,
  });
}

/// Successful
/// {@nodoc}
final class SettingsState$Successful extends SettingsState
    with _$SettingsState {
  /// {@nodoc}
  const SettingsState$Successful({
    required super.data,
  });
}

/// Error
/// {@nodoc}
final class SettingsState$Error extends SettingsState with _$SettingsState {
  final Object error;

  /// {@nodoc}
  const SettingsState$Error({
    required super.data,
    required this.error,
  });
}

/// {@nodoc}
base mixin _$SettingsState on SettingsState {}

/// Pattern matching for [SettingsState].
typedef SettingsStateMatch<R, S extends SettingsState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$SettingsStateBase {
  /// {@nodoc}
  const _$SettingsStateBase({required this.data});

  /// Data entity payload.
  @nonVirtual
  final SettingsEntity data;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing =>
      maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [SettingsState].
  R map<R>({
    required SettingsStateMatch<R, SettingsState$Idle> idle,
    required SettingsStateMatch<R, SettingsState$Processing> processing,
    required SettingsStateMatch<R, SettingsState$Successful> successful,
    required SettingsStateMatch<R, SettingsState$Error> error,
  }) =>
      switch (this) {
        final SettingsState$Idle s => idle(s),
        final SettingsState$Processing s => processing(s),
        final SettingsState$Successful s => successful(s),
        final SettingsState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [SettingsState].
  R maybeMap<R>({
    SettingsStateMatch<R, SettingsState$Idle>? idle,
    SettingsStateMatch<R, SettingsState$Processing>? processing,
    SettingsStateMatch<R, SettingsState$Successful>? successful,
    SettingsStateMatch<R, SettingsState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [SettingsState].
  R? mapOrNull<R>({
    SettingsStateMatch<R, SettingsState$Idle>? idle,
    SettingsStateMatch<R, SettingsState$Processing>? processing,
    SettingsStateMatch<R, SettingsState$Successful>? successful,
    SettingsStateMatch<R, SettingsState$Error>? error,
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
