import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/entities/app_info.dart';

abstract interface class AppInfoDataSource {
  Future<AppInfo> getAppInfo();
}

/// Lê versão e build do `pubspec.yaml` (via binário instalado).
class AppInfoDataSourceImpl implements AppInfoDataSource {
  const AppInfoDataSourceImpl();

  @override
  Future<AppInfo> getAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    return AppInfo(version: info.version, buildNumber: info.buildNumber);
  }
}
