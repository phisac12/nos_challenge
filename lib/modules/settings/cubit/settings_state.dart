part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.appName,
    required this.themeMode,
    this.appVersion,
  });

  final String appName;
  final AppThemeMode themeMode;

  /// Ex.: "1.0.0 (1)". Nulo enquanto carrega.
  final String? appVersion;

  SettingsState copyWith({AppThemeMode? themeMode, String? appVersion}) =>
      SettingsState(
        appName: appName,
        themeMode: themeMode ?? this.themeMode,
        appVersion: appVersion ?? this.appVersion,
      );

  @override
  List<Object?> get props => [appName, themeMode, appVersion];
}
