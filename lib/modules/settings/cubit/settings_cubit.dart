import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/app_theme_mode.dart';
import '../../../domain/usecases/get_app_info_use_case.dart';
import '../../../domain/usecases/get_theme_mode_use_case.dart';
import '../../../domain/usecases/save_theme_mode_use_case.dart';

part 'settings_state.dart';

/// Preferências globais (tema e versão). Fica acima do MaterialApp porque
/// o tema afeta a app toda.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    GetThemeModeUseCase getThemeMode,
    this._saveThemeMode,
    this._getAppInfo, {
    required String appName,
    // O tema guardado é lido logo aqui, para a app abrir já com ele.
  }) : super(SettingsState(appName: appName, themeMode: getThemeMode()));

  final SaveThemeModeUseCase _saveThemeMode;
  final GetAppInfoUseCase _getAppInfo;

  Future<void> loadAppInfo() async {
    final info = await _getAppInfo();
    if (isClosed) return;
    emit(state.copyWith(appVersion: '${info.version} (${info.buildNumber})'));
  }

  /// Muda o tema na hora e depois guarda a escolha.
  Future<void> changeThemeMode(AppThemeMode mode) async {
    if (mode == state.themeMode) return;
    emit(state.copyWith(themeMode: mode));
    await _saveThemeMode(mode);
  }
}
