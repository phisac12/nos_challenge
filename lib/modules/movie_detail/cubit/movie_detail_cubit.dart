import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/result.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_details.dart';
import '../../../domain/usecases/get_movie_details_use_case.dart';

part 'movie_detail_state.dart';

/// Regras do detalhe: carregar a informação extra e formatar os dados
/// apresentados (ano, duração), para o ecrã só desenhar.
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(this._getMovieDetails, {required Movie movie})
    : super(MovieDetailState(movie: movie));

  final GetMovieDetailsUseCase _getMovieDetails;

  Future<void> load() async {
    if (state.status is! DetailsLoading) {
      emit(state.copyWith(status: const DetailsLoading()));
    }
    final result = await _getMovieDetails(movieId: state.movie.id);
    if (isClosed) return;
    emit(
      state.copyWith(
        status: switch (result) {
          Success(:final data) => DetailsLoaded(data),
          Failure(:final message) => DetailsError(message),
        },
      ),
    );
  }

  /// 125 → "2h 5min"; 45 → "45min".
  static String? formatRuntime(int? minutes) {
    if (minutes == null || minutes <= 0) return null;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}min';
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  static String? formatYear(DateTime? date) => date?.year.toString();
}
