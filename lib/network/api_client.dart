import 'package:dio/dio.dart';

import 'api_config.dart';
import 'interceptors/api_key_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_exception.dart';

/// Único sítio que conhece o Dio. O resto da app só chama [get].
class ApiClient {
  ApiClient({required this.apiKey, bool enableLogs = false, Dio? dio})
    : _dio = dio ?? _createDio() {
    _dio.interceptors.add(ApiKeyInterceptor(apiKey));
    if (enableLogs) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  final String apiKey;
  final Dio _dio;

  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.timeout,
        receiveTimeout: ApiConfig.timeout,
      ),
    );
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    if (apiKey.isEmpty) {
      throw const NetworkException(
        'API key não configurada. Executa com --dart-define-from-file=env/<flavor>.json',
      );
    }
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      throw NetworkException.fromDio(e);
    }
  }
}
