import '../../domain/entities/app_info.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/app_info_data_source.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local, this._appInfo);

  final SettingsLocalDataSource _local;
  final AppInfoDataSource _appInfo;

  /// Valor desconhecido ou ausente → segue o sistema.
  @override
  AppThemeMode getThemeMode() => AppThemeMode.values.firstWhere(
    (mode) => mode.name == _local.readThemeMode(),
    orElse: () => AppThemeMode.system,
  );

  @override
  Future<void> saveThemeMode(AppThemeMode mode) =>
      _local.writeThemeMode(mode.name);

  @override
  Future<AppInfo> getAppInfo() => _appInfo.getAppInfo();
}
