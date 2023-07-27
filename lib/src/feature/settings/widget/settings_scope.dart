import 'package:flutter/material.dart';
import 'package:gravity_group_techquest/src/feature/dependencies/widget/dependencies_scope.dart';
import 'package:gravity_group_techquest/src/feature/settings/controller/settings_controller.dart';
import 'package:gravity_group_techquest/src/feature/settings/model/settings_model.dart';
import 'package:pure/pure.dart';

@immutable
class SettingsScope extends StatefulWidget {
  const SettingsScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static SettingsController controllerOf(final BuildContext context) =>
      _InheritedSettings.stateOf(context)!.settingsBLoC;

  /// Обновить настройки приложения
  static void updateOf(
    final BuildContext context, {
    required final SettingsEntity settings,
  }) =>
      controllerOf(context).updateSettings(settings);

  static void setLocale(BuildContext context, AppLocale locale) =>
      controllerOf(context).setLocale(locale);

  static void toggleLocale(BuildContext context) =>
      controllerOf(context).setLocale(
        switch (settingsOf(context).locale) {
          AppLocale.ru => AppLocale.en,
          _ => AppLocale.ru,
        },
      );

  static void toggleTheme(BuildContext context) =>
      controllerOf(context).setTheme(
        switch (settingsOf(context).themeMode) {
          ThemeMode.dark => ThemeMode.light,
          _ => ThemeMode.dark,
        },
      );

  /// Получить текущие настройки приложения
  static SettingsEntity settingsOf(
    final BuildContext context, {
    bool listen = true,
  }) =>
      _InheritedSettings.settingsOf(context, listen: listen)!;

  /// Получить и подписаться на текущую локаль приложения
  static Locale? localeOf(final BuildContext context) =>
      _InheritedSettings.aspectOf(context, 'locale')
          .locale
          ?.name
          .pipe(Locale.new);

  /// Получить и подписаться на текущую тему приложения
  static ThemeMode themeOf(final BuildContext context) =>
      _InheritedSettings.aspectOf(context, 'themeMode').themeMode;

  @override
  State<StatefulWidget> createState() => _SettingsScopeState();
}

class _SettingsScopeState extends State<SettingsScope> {
  late SettingsController settingsBLoC = SettingsController(
    repository: DependenciesScope.of(context).settingsRepository,
  );

  @override
  void dispose() {
    settingsBLoC.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
        listenable: settingsBLoC,
        builder: (context, _) => _InheritedSettings(
          state: this,
          settings: settingsBLoC.state.data,
          child: widget.child,
        ),
      );
}

class _InheritedSettings extends InheritedModel<String> {
  final _SettingsScopeState state;
  final SettingsEntity settings;
  const _InheritedSettings({
    required this.state,
    required this.settings,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant final _InheritedSettings oldWidget) =>
      oldWidget.settings != settings;

  @override
  bool updateShouldNotifyDependent(
    covariant final _InheritedSettings oldWidget,
    final Set<String> dependencies,
  ) =>
      oldWidget.settings != settings &&
      ((dependencies.contains('locale') &&
              oldWidget.settings.locale != settings.locale) ||
          (dependencies.contains('themeMode') &&
              oldWidget.settings.themeMode != settings.themeMode));

  static SettingsEntity aspectOf(
    final BuildContext context,
    final String aspect,
  ) =>
      InheritedModel.inheritFrom<_InheritedSettings>(context, aspect: aspect)
          ?.settings ??
      const SettingsEntity(themeMode: ThemeMode.system);

  static _SettingsScopeState? stateOf(
    final BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<_InheritedSettings>()
              ?.state
          : (context
                  .getElementForInheritedWidgetOfExactType<_InheritedSettings>()
                  ?.widget as _InheritedSettings?)
              ?.state;

  static SettingsEntity? settingsOf(
    final BuildContext context, {
    bool listen = false,
  }) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<_InheritedSettings>()
              ?.settings
          : (context
                  .getElementForInheritedWidgetOfExactType<_InheritedSettings>()
                  ?.widget as _InheritedSettings?)
              ?.settings;
}
