/// Resultado de uma operação: sucesso com dados ou falha com mensagem.
sealed class Result<T> {
  const Result();

  /// Trata os dois casos de uma vez:
  /// `result.fold((error) => ..., (success) => ...)`.
  R fold<R>(
    R Function(String error) onFailure,
    R Function(T success) onSuccess,
  ) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Failure(:final message) => onFailure(message),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}
