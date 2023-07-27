import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gravity_group_techquest/src/core/utils/error_util.dart';
import 'package:gravity_group_techquest/src/core/utils/logger.dart';
import 'package:gravity_group_techquest/src/feature/settings/controller/settings_state.dart';
import 'package:gravity_group_techquest/src/feature/settings/model/settings_model.dart';
import 'package:gravity_group_techquest/src/feature/settings/repository/settings_repository.dart';
import 'package:pure/pure.dart';
import 'package:streamed_controller/streamed_controller.dart';

final class SettingsController extends BaseStreamedController<SettingsState>
    with ConcurrentConcurrencyMixin {
  final ISettingsRepository _settingsRepository;

  SettingsController({
    required ISettingsRepository repository,
  })  : _settingsRepository = repository,
        super(initialState: SettingsState.idle(data: repository.currentData()));

  Future<void> _performMutation(Future<void> Function() body) async =>
      handle(() async* {
        logger.info('Обновляем настройки');

        try {
          await body();
          yield SettingsState.successful(
            data: _settingsRepository.currentData(),
          );
        } on Object catch (e, s) {
          await ErrorUtil.logError(
            e,
            s,
            hint: 'Во время обновления настроек произошла ошибка',
          );
          yield SettingsState.error(
            data: state.data,
            error: e,
          );
          rethrow;
        } finally {
          yield SettingsState.idle(
            data: state.data,
          );
        }
      }());

  Future<void> setTheme(ThemeMode themeMode) async => _performMutation(
        () => _settingsRepository.setTheme(themeMode),
      );

  Future<void> updateSettings(SettingsEntity settings) async =>
      _performMutation(() async {
        await _settingsRepository.setTheme(settings.themeMode);
        await settings.locale?.pipe(_settingsRepository.setLocale);
      });

  Future<void> setLocale(AppLocale locale) async => _performMutation(
        () => _settingsRepository.setLocale(locale),
      );
}
