import 'package:flutter_test/flutter_test.dart';
import 'package:nos_challenge/data/models/movie_details_model.dart';

void main() {
  test('mapeia /movie/{id} com credits para a entidade', () {
    final details = MovieDetailsModel.fromJson({
      'id': 1,
      'title': 'T',
      'overview': 'O',
      'tagline': '',
      'release_date': '2023-07-21',
      'runtime': 0,
      'vote_count': 42,
      'genres': [
        {'id': 1, 'name': 'Drama'},
      ],
      'credits': {
        'cast': List.generate(
          15,
          (index) => {
            'name': 'A$index',
            'character': 'C$index',
            'profile_path': null,
          },
        ),
      },
    }).toEntity();

    expect(details.tagline, isNull); // vazio → null
    expect(details.runtimeMinutes, isNull); // 0 → null
    expect(details.releaseDate, DateTime(2023, 7, 21));
    expect(details.genres, ['Drama']);
    expect(details.cast.length, MovieDetailsModel.maxCast);
  });
}
