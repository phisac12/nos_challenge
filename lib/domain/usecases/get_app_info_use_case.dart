import '../entities/app_info.dart';
import '../repositories/settings_repository.dart';

class GetAppInfoUseCase {
  const GetAppInfoUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AppInfo> call() => _repository.getAppInfo();
}
