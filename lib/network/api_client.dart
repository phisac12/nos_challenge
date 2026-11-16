import 'package:dio/dio.dart';

import 'api_config.dart';
import 'interceptors/api_key_interceptor.dart';
import 'network_exception.dart';

/// Único ponto de contacto com HTTP. Encapsula o Dio para que o resto da app
/// não dependa da biblioteca (trocar por `http` mexe só aqui).
class ApiClient {
  ApiClient({required String apiKey, Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: ApiConfig.timeout,
              receiveTimeout: ApiConfig.timeout,
            )) {
    _dio.interceptors.add(ApiKeyInterceptor(apiKey));
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
      return response.data ?? const {};
    } on DioException catch (e) {
      throw NetworkException.fromDio(e);
    }
  }
}
