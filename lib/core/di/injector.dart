import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/app_info_data_source.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_app_info_use_case.dart';
import '../../domain/usecases/get_theme_mode_use_case.dart';
import '../../domain/usecases/save_theme_mode_use_case.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_discover_movies_use_case.dart';
import '../../domain/usecases/get_movie_details_use_case.dart';
import '../../modules/catalog/cubit/catalog_cubit.dart';
import '../../modules/movie_detail/cubit/movie_detail_cubit.dart';
import '../../modules/settings/cubit/settings_cubit.dart';
import '../../network/api_client.dart';
import '../env.dart';
import '../flavor/flavor_config.dart';

final getIt = GetIt.instance;

void setupInjector(FlavorConfig config, SharedPreferences prefs) {
  getIt.registerSingleton<FlavorConfig>(config);
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Network
  getIt.registerLazySingleton<ApiClient>(
    () =>
        ApiClient(apiKey: Env.tmdbApiKey, enableLogs: config.enableNetworkLogs),
  );

  // Data
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AppInfoDataSource>(
    () => const AppInfoDataSourceImpl(),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt(), getIt()),
  );

  // Domain
  getIt.registerFactory(() => GetDiscoverMoviesUseCase(getIt()));
  getIt.registerFactory(() => GetMovieDetailsUseCase(getIt()));
  getIt.registerFactory(() => GetThemeModeUseCase(getIt()));
  getIt.registerFactory(() => SaveThemeModeUseCase(getIt()));
  getIt.registerFactory(() => GetAppInfoUseCase(getIt()));

  // Cubits (factory: cada ecrã recebe uma instância nova)
  getIt.registerFactory(
    () => SettingsCubit(getIt(), getIt(), getIt(), appName: config.appName),
  );
  getIt.registerFactory(() => CatalogCubit(getIt()));
  // Recebe o filme selecionado como parâmetro em runtime.
  getIt.registerFactoryParam<MovieDetailCubit, Movie, void>(
    (movie, _) => MovieDetailCubit(getIt(), movie: movie),
  );
}
