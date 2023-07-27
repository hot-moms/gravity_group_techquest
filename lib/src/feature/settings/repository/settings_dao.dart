import 'package:typed_preferences/typed_preferences.dart';

abstract class ISettingsDao {
  PreferencesEntry<String> get themeMode;
  PreferencesEntry<String> get locale;
}

class SettingsDao extends TypedPreferencesDao implements ISettingsDao {
  SettingsDao(super.driver);

  @override
  PreferencesEntry<String> get themeMode => stringEntry('theme');

  @override
  PreferencesEntry<String> get locale => stringEntry('locale');
}
