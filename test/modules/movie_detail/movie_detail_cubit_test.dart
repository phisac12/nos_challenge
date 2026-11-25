import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nos_challenge/core/result.dart';
import 'package:nos_challenge/domain/entities/movie.dart';
import 'package:nos_challenge/domain/entities/movie_details.dart';
import 'package:nos_challenge/domain/usecases/get_movie_details_use_case.dart';
import 'package:nos_challenge/modules/movie_detail/cubit/movie_detail_cubit.dart';

class _MockUseCase extends Mock implements GetMovieDetailsUseCase {}

const movie = Movie(id: 7, title: 'X', posterUrl: null, voteAverage: 7.5);
final details = MovieDetails(
  id: 7,
  title: 'X',
  overview: 'Sinopse',
  tagline: null,
  releaseDate: DateTime(2024, 5, 1),
  runtimeMinutes: 125,
  genres: const ['Ação'],
  voteCount: 100,
  cast: const [],
);

void main() {
  late _MockUseCase useCase;
  setUp(() => useCase = _MockUseCase());

  MovieDetailCubit build() => MovieDetailCubit(useCase, movie: movie);

  test('começa com o filme do catálogo e detalhe em loading', () {
    final state = build().state;
    expect(state.movie, movie);
    expect(state.status, isA<DetailsLoading>());
  });

  blocTest<MovieDetailCubit, MovieDetailState>(
    'carrega o detalhe com o id do filme',
    setUp: () =>
        when(() => useCase(movieId: 7))
            .thenAnswer((_) async => Success(details)),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      MovieDetailState(movie: movie, status: DetailsLoaded(details)),
    ],
    verify: (_) => verify(() => useCase(movieId: 7)).called(1),
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'falha mantém poster e nota e expõe o erro',
    setUp: () =>
        when(() => useCase(movieId: 7))
            .thenAnswer((_) async => const Failure('erro')),
    build: build,
    act: (cubit) => cubit.load(),
    expect: () => [
      const MovieDetailState(movie: movie, status: DetailsError('erro')),
    ],
  );

  blocTest<MovieDetailCubit, MovieDetailState>(
    'retry após erro volta a loading e carrega',
    setUp: () =>
        when(() => useCase(movieId: 7))
            .thenAnswer((_) async => Success(details)),
    build: build,
    seed: () =>
        const MovieDetailState(movie: movie, status: DetailsError('erro')),
    act: (cubit) => cubit.retry(),
    expect: () => [
      const MovieDetailState(movie: movie),
      MovieDetailState(movie: movie, status: DetailsLoaded(details)),
    ],
  );

  test('formata duração e ano', () {
    expect(MovieDetailCubit.formatRuntime(125), '2h 5min');
    expect(MovieDetailCubit.formatRuntime(120), '2h');
    expect(MovieDetailCubit.formatRuntime(45), '45min');
    expect(MovieDetailCubit.formatRuntime(null), isNull);
    expect(MovieDetailCubit.formatYear(DateTime(2024)), '2024');
  });
}
