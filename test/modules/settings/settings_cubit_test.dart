import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nos_challenge/domain/entities/app_info.dart';
import 'package:nos_challenge/domain/entities/app_theme_mode.dart';
import 'package:nos_challenge/domain/usecases/get_app_info_use_case.dart';
import 'package:nos_challenge/domain/usecases/get_theme_mode_use_case.dart';
import 'package:nos_challenge/domain/usecases/save_theme_mode_use_case.dart';
import 'package:nos_challenge/modules/settings/cubit/settings_cubit.dart';

class _MockGetTheme extends Mock implements GetThemeModeUseCase {}

class _MockSaveTheme extends Mock implements SaveThemeModeUseCase {}

class _MockGetAppInfo extends Mock implements GetAppInfoUseCase {}

void main() {
  late _MockGetTheme getTheme;
  late _MockSaveTheme saveTheme;
  late _MockGetAppInfo getAppInfo;

  setUpAll(() => registerFallbackValue(AppThemeMode.system));

  setUp(() {
    getTheme = _MockGetTheme();
    saveTheme = _MockSaveTheme();
    getAppInfo = _MockGetAppInfo();
    when(() => getTheme()).thenReturn(AppThemeMode.system);
    when(() => saveTheme(any())).thenAnswer((_) async {});
  });

  SettingsCubit build() =>
      SettingsCubit(getTheme, saveTheme, getAppInfo, appName: 'App');

  test('estado inicial usa o tema guardado', () {
    when(() => getTheme()).thenReturn(AppThemeMode.dark);
    expect(build().state.themeMode, AppThemeMode.dark);
    expect(build().state.appName, 'App');
  });

  blocTest<SettingsCubit, SettingsState>(
    'mudar tema emite e persiste',
    build: build,
    act: (cubit) => cubit.changeThemeMode(AppThemeMode.light),
    expect: () => [
      const SettingsState(appName: 'App', themeMode: AppThemeMode.light),
    ],
    verify: (_) => verify(() => saveTheme(AppThemeMode.light)).called(1),
  );

  blocTest<SettingsCubit, SettingsState>(
    'escolher o mesmo tema não emite nem persiste',
    build: build,
    act: (cubit) => cubit.changeThemeMode(AppThemeMode.system),
    expect: () => <SettingsState>[],
    verify: (_) => verifyNever(() => saveTheme(any())),
  );

  blocTest<SettingsCubit, SettingsState>(
    'carrega a versão formatada',
    setUp: () => when(() => getAppInfo()).thenAnswer(
      (_) async => const AppInfo(version: '1.0.0', buildNumber: '1'),
    ),
    build: build,
    act: (cubit) => cubit.loadAppInfo(),
    expect: () => [
      const SettingsState(
        appName: 'App',
        themeMode: AppThemeMode.system,
        appVersion: '1.0.0 (1)',
      ),
    ],
  );
}
