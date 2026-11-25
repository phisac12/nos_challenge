import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nos_challenge/network/network_exception.dart';

DioException _dio(DioExceptionType type, {int? status}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response(requestOptions: options, statusCode: status),
  );
}

void main() {
  test('timeout', () {
    final exception = NetworkException.fromDio(
      _dio(DioExceptionType.receiveTimeout),
    );
    expect(exception.message, contains('demorou'));
  });

  test('sem ligação', () {
    final exception = NetworkException.fromDio(
      _dio(DioExceptionType.connectionError),
    );
    expect(exception.message, 'Sem ligação à internet.');
  });

  test('401 → API key inválida', () {
    final exception = NetworkException.fromDio(
      _dio(DioExceptionType.badResponse, status: 401),
    );
    expect(exception.statusCode, 401);
    expect(exception.message, 'API key inválida.');
  });

  test('outro status → erro do servidor com o código', () {
    final exception = NetworkException.fromDio(
      _dio(DioExceptionType.badResponse, status: 500),
    );
    expect(exception.statusCode, 500);
    expect(exception.message, 'Erro do servidor (500).');
  });
}
