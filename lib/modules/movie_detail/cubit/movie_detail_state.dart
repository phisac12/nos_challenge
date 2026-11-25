part of 'movie_detail_cubit.dart';

enum DetailsStatus { loading, loaded, error }

/// [movie] vem do catálogo e mostra logo o poster e a nota.
/// [status], [details] e [errorMessage] são a informação extra que vem da API.
class MovieDetailState extends Equatable {
  const MovieDetailState({
    required this.movie,
    this.status = DetailsStatus.loading,
    this.details,
    this.errorMessage,
  });

  final Movie movie;
  final DetailsStatus status;

  /// Só tem valor quando o status é loaded.
  final MovieDetails? details;

  /// Só tem valor quando o status é error.
  final String? errorMessage;

  MovieDetailState copyWith({
    DetailsStatus? status,
    MovieDetails? details,
    String? errorMessage,
  }) {
    return MovieDetailState(
      movie: movie,
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [movie, status, details, errorMessage];
}
