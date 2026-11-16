import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_theme_mode.dart';
import '../../../domain/usecases/get_app_info_use_case.dart';
import '../../../domain/usecases/get_theme_mode_use_case.dart';
import '../../../domain/usecases/save_theme_mode_use_case.dart';

part 'settings_state.dart';

/// Estado global de preferências (tema, versão). Fornecido acima do MaterialApp.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    GetThemeModeUseCase getThemeMode,
    this._saveThemeMode,
    this._getAppInfo, {
    required String appName,
  }) : super(SettingsState(appName: appName, themeMode: getThemeMode()));

  final SaveThemeModeUseCase _saveThemeMode;
  final GetAppInfoUseCase _getAppInfo;

  Future<void> loadAppInfo() async {
    final info = await _getAppInfo();
    if (isClosed) return;
    emit(state.copyWith(appVersion: '${info.version} (${info.buildNumber})'));
  }

  /// Atualiza a UI de imediato e persiste em seguida.
  Future<void> changeThemeMode(AppThemeMode mode) async {
    if (mode == state.themeMode) return;
    emit(state.copyWith(themeMode: mode));
    await _saveThemeMode(mode);
  }
}
