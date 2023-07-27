import 'package:flutter/material.dart';

enum AppLocale {
  ru,
  en,
}

@immutable
class SettingsEntity {
  const SettingsEntity({
    this.locale,
    required this.themeMode,
  });

  final AppLocale? locale;
  final ThemeMode themeMode;
  SettingsEntity copyWith({
    AppLocale? locale,
    ThemeMode? themeMode,
  }) =>
      SettingsEntity(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  int get hashCode => locale?.index ?? 0 + themeMode.index;

  @override
  bool operator ==(covariant SettingsEntity other) =>
      other.locale == locale && other.themeMode == themeMode;
}
