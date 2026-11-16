import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nos_challenge/network/api_client.dart';
import 'package:nos_challenge/network/network_exception.dart';

/// Adapter falso: responde sem rede e guarda o último pedido.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.status = 200});

  static const body = {'ok': true};
  final int status;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  ApiClient client(_FakeAdapter adapter, {String apiKey = 'k123'}) =>
      ApiClient(apiKey: apiKey, dio: Dio()..httpClientAdapter = adapter);

  test('anexa a api_key e mantém a query original', () async {
    final adapter = _FakeAdapter();

    final json = await client(adapter)
        .get('/discover/movie', query: {'page': 2});

    expect(json, {'ok': true});
    expect(adapter.lastRequest!.queryParameters, {
      'page': 2,
      'api_key': 'k123',
    });
  });

  test('401 lança NetworkException de API key inválida', () async {
    final adapter = _FakeAdapter(status: 401);

    expect(
      () => client(adapter).get('/x'),
      throwsA(
        isA<NetworkException>().having((e) => e.statusCode, 'status', 401),
      ),
    );
  });

  test('sem api key falha antes de fazer o pedido', () async {
    final adapter = _FakeAdapter();

    await expectLater(
      () => client(adapter, apiKey: '').get('/x'),
      throwsA(isA<NetworkException>()),
    );
    expect(adapter.lastRequest, isNull);
  });
}
