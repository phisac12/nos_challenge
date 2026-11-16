import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/app_info_data_source.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_app_info_use_case.dart';
import '../../domain/usecases/get_discover_movies_use_case.dart';
import '../../domain/usecases/get_movie_details_use_case.dart';
import '../../domain/usecases/get_theme_mode_use_case.dart';
import '../../domain/usecases/save_theme_mode_use_case.dart';
import '../../modules/catalog/cubit/catalog_cubit.dart';
import '../../modules/movie_detail/cubit/movie_detail_cubit.dart';
import '../../modules/settings/cubit/settings_cubit.dart';
import '../../network/api_client.dart';
import '../env.dart';
import '../flavor/flavor_config.dart';

final getIt = GetIt.instance;

/// Regista as dependências por camada, de baixo para cima.
/// Dentro de cada grupo, por ordem alfabética.
void setupInjector(FlavorConfig config, SharedPreferences prefs) {
  _registerCore(config, prefs);
  _registerNetwork(config);
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerCubits(config);
}

void _registerCore(FlavorConfig config, SharedPreferences prefs) {
  getIt
    ..registerSingleton<FlavorConfig>(config)
    ..registerSingleton<SharedPreferences>(prefs);
}

void _registerNetwork(FlavorConfig config) {
  getIt.registerLazySingleton<ApiClient>(
    () =>
        ApiClient(apiKey: Env.tmdbApiKey, enableLogs: config.enableNetworkLogs),
  );
}

void _registerDataSources() {
  getIt
    ..registerLazySingleton<AppInfoDataSource>(
      () => const AppInfoDataSourceImpl(),
    )
    ..registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(getIt()),
    );
}

void _registerRepositories() {
  getIt
    ..registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(getIt()))
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(getIt(), getIt()),
    );
}

void _registerUseCases() {
  getIt
    ..registerFactory(() => GetAppInfoUseCase(getIt()))
    ..registerFactory(() => GetDiscoverMoviesUseCase(getIt()))
    ..registerFactory(() => GetMovieDetailsUseCase(getIt()))
    ..registerFactory(() => GetThemeModeUseCase(getIt()))
    ..registerFactory(() => SaveThemeModeUseCase(getIt()));
}

/// Factory: cada ecrã recebe uma instância nova.
void _registerCubits(FlavorConfig config) {
  getIt
    ..registerFactory(() => CatalogCubit(getIt()))
    // Recebe o filme selecionado como parâmetro em runtime.
    ..registerFactoryParam<MovieDetailCubit, Movie, void>(
      (movie, _) => MovieDetailCubit(getIt(), movie: movie),
    )
    ..registerFactory(
      () => SettingsCubit(getIt(), getIt(), getIt(), appName: config.appName),
    );
}
