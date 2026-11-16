import 'package:flutter_test/flutter_test.dart';
import 'package:nos_challenge/data/models/movie_details_model.dart';

void main() {
  test('mapeia /movie/{id} com credits para a entidade', () {
    final d = MovieDetailsModel.fromJson({
      'id': 1,
      'title': 'T',
      'overview': 'O',
      'tagline': '',
      'backdrop_path': '/b.jpg',
      'release_date': '2023-07-21',
      'runtime': 0,
      'vote_count': 42,
      'genres': [
        {'id': 1, 'name': 'Drama'},
      ],
      'credits': {
        'cast': List.generate(
          15,
          (i) => {'name': 'A$i', 'character': 'C$i', 'profile_path': null},
        ),
      },
    }).toEntity();

    expect(d.tagline, isNull); // vazio → null
    expect(d.runtimeMinutes, isNull); // 0 → null
    expect(d.releaseDate, DateTime(2023, 7, 21));
    expect(d.backdropUrl, 'https://image.tmdb.org/t/p/w780/b.jpg');
    expect(d.genres, ['Drama']);
    expect(d.cast.length, MovieDetailsModel.maxCast);
  });
}
