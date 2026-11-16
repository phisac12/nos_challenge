import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory NetworkException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        const NetworkException('O servidor demorou demasiado a responder.'),
      DioExceptionType.connectionError =>
        const NetworkException('Sem ligação à internet.'),
      DioExceptionType.badResponse when status == 401 =>
        const NetworkException('API key inválida.', statusCode: 401),
      DioExceptionType.badResponse =>
        NetworkException('Erro do servidor ($status).', statusCode: status),
      _ => const NetworkException('Erro inesperado de rede.'),
    };
  }

  @override
  String toString() => 'NetworkException($statusCode): $message';
}
