part of 'movie_detail_cubit.dart';

sealed class DetailsStatus extends Equatable {
  const DetailsStatus();
  @override
  List<Object?> get props => [];
}

final class DetailsLoading extends DetailsStatus {
  const DetailsLoading();
}

final class DetailsLoaded extends DetailsStatus {
  const DetailsLoaded(this.details);
  final MovieDetails details;
  @override
  List<Object?> get props => [details];
}

final class DetailsError extends DetailsStatus {
  const DetailsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// [movie] vem do catálogo e mostra logo o poster e a nota.
/// [status] é só a informação extra que vem da API.
class MovieDetailState extends Equatable {
  const MovieDetailState({
    required this.movie,
    this.status = const DetailsLoading(),
  });

  final Movie movie;
  final DetailsStatus status;

  MovieDetailState copyWith({DetailsStatus? status}) =>
      MovieDetailState(movie: movie, status: status ?? this.status);

  @override
  List<Object?> get props => [movie, status];
}
