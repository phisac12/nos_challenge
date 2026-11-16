/// Resultado explícito de uma operação: sucesso ou falha.
/// Evita exceções a atravessar camadas e obriga quem consome a tratar os dois casos.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}
