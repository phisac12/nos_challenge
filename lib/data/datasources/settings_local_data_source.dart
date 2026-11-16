import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local de preferências. Só esta classe conhece o SharedPreferences.
abstract interface class SettingsLocalDataSource {
  String? readThemeMode();

  Future<void> writeThemeMode(String value);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._prefs);

  static const themeModeKey = 'settings.theme_mode';

  final SharedPreferences _prefs;

  @override
  String? readThemeMode() => _prefs.getString(themeModeKey);

  @override
  Future<void> writeThemeMode(String value) =>
      _prefs.setString(themeModeKey, value);
}
