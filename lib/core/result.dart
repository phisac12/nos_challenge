/// Resultado de uma operação: [Success] com os dados ou [Failure] com a mensagem.
abstract class Result<T> {
  const Result();

  /// Chama [onError] se falhou, ou [onSuccess] se deu certo.
  void fold(
    void Function(String error) onError,
    void Function(T success) onSuccess,
  ) {
    final result = this;
    if (result is Failure<T>) {
      onError(result.message);
    } else if (result is Success<T>) {
      onSuccess(result.data);
    }
  }
}

/// Deu certo: guarda os dados.
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Deu errado: guarda a mensagem de erro.
class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}
