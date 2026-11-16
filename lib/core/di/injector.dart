import 'package:get_it/get_it.dart';

import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_discover_movies_use_case.dart';
import '../../modules/catalog/cubit/catalog_cubit.dart';
import '../../network/api_client.dart';
import '../env.dart';
import '../flavor/flavor_config.dart';

final getIt = GetIt.instance;

void setupInjector(FlavorConfig config) {
  getIt.registerSingleton<FlavorConfig>(config);

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

  // Domain
  getIt.registerFactory(() => GetDiscoverMoviesUseCase(getIt()));

  // Cubits (factory: cada ecrã recebe uma instância nova)
  getIt.registerFactory(() => CatalogCubit(getIt()));
}
