import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nos_challenge/core/result.dart';
import 'package:nos_challenge/domain/entities/movie.dart';
import 'package:nos_challenge/domain/usecases/get_discover_movies_use_case.dart';
import 'package:nos_challenge/modules/catalog/cubit/catalog_cubit.dart';

class _MockUseCase extends Mock implements GetDiscoverMoviesUseCase {}

const good = Movie(id: 1, title: 'Good', posterUrl: null, voteAverage: 7.2);
const edge = Movie(id: 2, title: 'Edge', posterUrl: null, voteAverage: 6.0);
const bad = Movie(id: 3, title: 'Bad', posterUrl: null, voteAverage: 5.9);

void main() {
  late _MockUseCase useCase;

  setUp(() => useCase = _MockUseCase());

  CatalogCubit build() => CatalogCubit(useCase);

  test('estado inicial: todas as secções em loading', () {
    expect(build().state.sections.values, everyElement(isA<SectionLoading>()));
  });

  test('cada secção aparece assim que a sua página responde, sem esperar pelas outras', () async {
    final completers = {
      for (final p in [1, 2, 3]) p: Completer<Result<List<Movie>>>(),
    };
    when(() => useCase(page: any(named: 'page')))
        .thenAnswer((inv) => completers[inv.namedArguments[#page]]!.future);

    final cubit = build()..loadSections();

    completers[2]!.complete(const Success([good]));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.sections[1], isA<SectionLoading>());
    expect(cubit.state.sections[2], isA<SectionLoaded>());
    expect(cubit.state.sections[3], isA<SectionLoading>());

    completers[3]!.complete(const Failure('erro'));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.sections[3], const SectionError('erro'));
  });

  blocTest<CatalogCubit, CatalogState>(
    'marca como destaque filmes com classificação >= 6.0',
    setUp: () =>
        when(() => useCase(page: 1))
            .thenAnswer((_) async => const Success([good, edge, bad])),
    build: build,
    act: (c) => c.loadSection(1),
    verify: (c) {
      final items = (c.state.sections[1] as SectionLoaded).items;
      expect(items.map((i) => i.isHighlighted), [true, true, false]);
    },
  );

  blocTest<CatalogCubit, CatalogState>(
    'filme >= 6.0 abre o detalhe',
    build: build,
    act: (c) => c.onMovieSelected(edge),
    expect: () => [
      isA<CatalogState>().having(
        (s) => s.effect,
        'effect',
        const OpenMovieDetail(edge),
      ),
    ],
  );

  blocTest<CatalogCubit, CatalogState>(
    'filme < 6.0 mostra aviso e não abre o detalhe',
    build: build,
    act: (c) => c.onMovieSelected(bad),
    expect: () => [
      isA<CatalogState>().having(
        (s) => s.effect,
        'effect',
        const ShowLowRatingWarning(bad),
      ),
    ],
  );
}
