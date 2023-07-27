import 'package:flutter/material.dart';
import 'package:gravity_group_techquest/src/feature/settings/model/settings_model.dart';
import 'package:gravity_group_techquest/src/feature/settings/repository/settings_dao.dart';
import 'package:pure/pure.dart';

abstract class ISettingsRepository {
  SettingsEntity currentData();

  Future<void> setTheme(ThemeMode value);
  Future<void> setLocale(AppLocale value);
}

class SettingsRepository implements ISettingsRepository {
  final ISettingsDao _settingsDao;

  SettingsRepository({
    required ISettingsDao settingsDao,
  }) : _settingsDao = settingsDao;

  ThemeMode? get _theme =>
      ThemeMode.values.byName.nullable(_settingsDao.themeMode.value);

  AppLocale? get _locale =>
      AppLocale.values.byName.nullable(_settingsDao.locale.value);

  @override
  SettingsEntity currentData() => SettingsEntity(
        themeMode: _theme ?? ThemeMode.light,
        locale: _locale,
      );

  @override
  Future<void> setTheme(ThemeMode value) =>
      _settingsDao.themeMode.setValue(value.name);

  @override
  Future<void> setLocale(AppLocale value) =>
      _settingsDao.locale.setValue(value.name);
}
