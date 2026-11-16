import '../entities/app_info.dart';
import '../entities/app_theme_mode.dart';

abstract interface class SettingsRepository {
  /// Síncrono: lido no arranque para a app abrir já com o tema certo.
  AppThemeMode getThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);

  Future<AppInfo> getAppInfo();
}
