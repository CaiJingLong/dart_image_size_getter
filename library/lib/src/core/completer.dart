import 'dart:async';

class MyCompleter<T> {
  Completer<T> completer = Completer();

  MyCompleter();

  Future<T> get future => completer.future;

  void reply(T result) {
    if (!completer.isCompleted) {
      completer.complete(result);
    }
  }
}
