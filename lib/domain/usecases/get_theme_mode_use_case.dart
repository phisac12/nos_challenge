import '../entities/app_theme_mode.dart';
import '../repositories/settings_repository.dart';

class GetThemeModeUseCase {
  const GetThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  AppThemeMode call() => _repository.getThemeMode();
}
