import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Log de pedidos para DEV/QA. Mostra método, path, página e status,
/// mas nunca a query completa — para não expor a api_key nos logs.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
      '→ ${options.method} ${options.path} page=${options.queryParameters['page']}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint('← ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '✕ ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.path}',
    );
    handler.next(err);
  }
}
