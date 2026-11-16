import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nos_challenge/data/datasources/app_info_data_source.dart';
import 'package:nos_challenge/data/datasources/settings_local_data_source.dart';
import 'package:nos_challenge/data/repositories/settings_repository_impl.dart';
import 'package:nos_challenge/domain/entities/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAppInfo extends Mock implements AppInfoDataSource {}

Future<SettingsRepositoryImpl> _repo(Map<String, Object> stored) async {
  SharedPreferences.setMockInitialValues(stored);
  final prefs = await SharedPreferences.getInstance();
  return SettingsRepositoryImpl(
    SettingsLocalDataSourceImpl(prefs),
    _MockAppInfo(),
  );
}

void main() {
  const key = SettingsLocalDataSourceImpl.themeModeKey;

  test('sem valor guardado segue o sistema', () async {
    expect((await _repo({})).getThemeMode(), AppThemeMode.system);
  });

  test('valor inválido segue o sistema', () async {
    expect((await _repo({key: 'roxo'})).getThemeMode(), AppThemeMode.system);
  });

  test('guarda e volta a ler o tema', () async {
    final repo = await _repo({});
    await repo.saveThemeMode(AppThemeMode.dark);
    expect(repo.getThemeMode(), AppThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(key), 'dark');
  });
}
