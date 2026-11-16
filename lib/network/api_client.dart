import 'package:dio/dio.dart';

import 'api_config.dart';
import 'interceptors/api_key_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_exception.dart';

/// Único ponto de contacto com HTTP. Encapsula o Dio para que o resto da app
/// não dependa da biblioteca (trocar por `http` mexe só aqui).
class ApiClient {
  ApiClient({required String apiKey, bool enableLogs = false, Dio? dio})
    : _hasApiKey = apiKey.isNotEmpty,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: ApiConfig.timeout,
              receiveTimeout: ApiConfig.timeout,
            ),
          ) {
    _dio.interceptors.add(ApiKeyInterceptor(apiKey));
    if (enableLogs) _dio.interceptors.add(LoggingInterceptor());
  }

  final Dio _dio;
  final bool _hasApiKey;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    if (!_hasApiKey) {
      throw const NetworkException(
        'API key não configurada. Executa com --dart-define-from-file=env/<flavor>.json',
      );
    }
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      throw NetworkException.fromDio(e);
    }
  }
}
