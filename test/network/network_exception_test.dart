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
    final e = NetworkException.fromDio(_dio(DioExceptionType.receiveTimeout));
    expect(e.message, contains('demorou'));
  });

  test('sem ligação', () {
    final e = NetworkException.fromDio(_dio(DioExceptionType.connectionError));
    expect(e.message, 'Sem ligação à internet.');
  });

  test('401 → API key inválida', () {
    final e = NetworkException.fromDio(
      _dio(DioExceptionType.badResponse, status: 401),
    );
    expect(e.statusCode, 401);
    expect(e.message, 'API key inválida.');
  });

  test('outro status → erro do servidor com o código', () {
    final e = NetworkException.fromDio(
      _dio(DioExceptionType.badResponse, status: 500),
    );
    expect(e.statusCode, 500);
    expect(e.message, 'Erro do servidor (500).');
  });
}
