import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String? posterUrl;
  final double voteAverage;

  @override
  List<Object?> get props => [id, title, posterUrl, voteAverage];
}
