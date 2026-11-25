import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_details.dart';
import '../../../domain/usecases/get_movie_details_use_case.dart';

part 'movie_detail_state.dart';

/// Regras do detalhe: carregar a informação extra e formatar ano e duração,
/// para o ecrã só desenhar.
class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit(this._getMovieDetails, {required Movie movie})
    : super(MovieDetailState(movie: movie));

  final GetMovieDetailsUseCase _getMovieDetails;

  /// O estado inicial já é loading, por isso aqui só emitimos o resultado.
  Future<void> load() async {
    final result = await _getMovieDetails(movieId: state.movie.id);
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(status: DetailsStatus.error, errorMessage: error),
      ),
      (success) =>
          emit(state.copyWith(status: DetailsStatus.loaded, details: success)),
    );
  }

  /// Botão "Tentar novamente": volta a loading e carrega de novo.
  Future<void> retry() async {
    // Estado limpo: volta a loading sem a mensagem de erro anterior.
    emit(MovieDetailState(movie: state.movie));
    await load();
  }

  /// 125 → "2h 5min"; 120 → "2h"; 45 → "45min".
  static String? formatRuntime(int? totalMinutes) {
    if (totalMinutes == null || totalMinutes <= 0) return null;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}min';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}min';
  }

  /// 2024-05-01 → "2024".
  static String? formatYear(DateTime? date) => date?.year.toString();
}
