import 'package:dio/dio.dart';

/// Anexa a api_key a todos os pedidos — nenhum datasource precisa de a conhecer.
class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['api_key'] = apiKey;
    handler.next(options);
  }
}
