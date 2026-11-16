import 'package:flutter_test/flutter_test.dart';
import 'package:nos_challenge/data/models/movie_model.dart';

void main() {
  test('mapeia JSON da API para entidade com URL de poster completa', () {
    final movie = MovieModel.fromJson({
      'id': 10,
      'title': 'X',
      'poster_path': '/abc.jpg',
      'vote_average': 7,
    }).toEntity();

    expect(movie.posterUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
    expect(movie.voteAverage, 7.0);
  });

  test('poster ausente resulta em posterUrl nulo', () {
    final movie = MovieModel.fromJson({'id': 1, 'poster_path': null, 'vote_average': null}).toEntity();
    expect(movie.posterUrl, isNull);
    expect(movie.voteAverage, 0);
  });
}
