import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nos_challenge/core/result.dart';
import 'package:nos_challenge/data/datasources/movie_remote_data_source.dart';
import 'package:nos_challenge/data/models/movie_details_model.dart';
import 'package:nos_challenge/data/models/movie_model.dart';
import 'package:nos_challenge/data/repositories/movie_repository_impl.dart';
import 'package:nos_challenge/network/network_exception.dart';

class _MockRemote extends Mock implements MovieRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late MovieRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = MovieRepositoryImpl(remote);
  });

  group('getDiscoverMovies', () {
    test('converte models em entidades', () async {
      when(() => remote.discoverMovies(page: 1)).thenAnswer(
        (_) async => const [
          MovieModel(id: 1, title: 'A', posterPath: '/a.jpg', voteAverage: 7),
        ],
      );

      final result = await repository.getDiscoverMovies(page: 1);

      final movies = (result as Success).data;
      expect(movies.single.posterUrl, 'https://image.tmdb.org/t/p/w500/a.jpg');
    });

    test('NetworkException vira Failure com a mensagem dela', () async {
      when(() => remote.discoverMovies(page: 1))
          .thenThrow(const NetworkException('Sem ligação à internet.'));

      final result = await repository.getDiscoverMovies(page: 1);

      expect((result as Failure).message, 'Sem ligação à internet.');
    });

    test('erro inesperado vira Failure genérica', () async {
      when(() => remote.discoverMovies(page: 1))
          .thenThrow(const FormatException());

      final result = await repository.getDiscoverMovies(page: 1);

      expect(
        (result as Failure).message,
        'Não foi possível carregar os filmes.',
      );
    });
  });

  group('getMovieDetails', () {
    test('converte o model em entidade', () async {
      when(() => remote.movieDetails(movieId: 9)).thenAnswer(
        (_) async => const MovieDetailsModel(
          id: 9,
          title: 'D',
          overview: '',
          tagline: null,
          releaseDate: '2020-01-01',
          runtime: 90,
          genres: ['Drama'],
          voteCount: 3,
          cast: [],
        ),
      );

      final result = await repository.getMovieDetails(movieId: 9);

      final details = (result as Success).data;
      expect(details.id, 9);
      expect(details.runtimeMinutes, 90);
    });

    test('erro inesperado vira Failure de detalhe', () async {
      when(() => remote.movieDetails(movieId: 9)).thenThrow(Exception());

      final result = await repository.getMovieDetails(movieId: 9);

      expect(
        (result as Failure).message,
        'Não foi possível carregar o detalhe do filme.',
      );
    });
  });
}
