abstract class ImageInput {
  const ImageInput();

  int get length;

  List<int> getRange(int start, int end);

  bool exists();
}

abstract class AsyncImageInput {
  const AsyncImageInput();

  factory AsyncImageInput.input(ImageInput input) = _SyncInputWrapper;

  Future<int> get length;

  Future<List<int>> getRange(int start, int end);

  Future<bool> exists();
}

class _SyncInputWrapper extends AsyncImageInput {
  final ImageInput _input;

  const _SyncInputWrapper(this._input);

  @override
  Future<bool> exists() async {
    return _input.exists();
  }

  @override
  Future<List<int>> getRange(int start, int end) async {
    return _input.getRange(start, end);
  }

  @override
  Future<int> get length async => _input.length;
}
