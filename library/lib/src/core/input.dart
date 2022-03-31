abstract class ImageInput {
  const ImageInput();

  int get length;

  List<int> getRange(int start, int end);

  bool exists();
}

class HaveResourceImageInput extends ImageInput {
  const HaveResourceImageInput({
    required this.innerInput,
    this.onRelease,
  });

  final ImageInput innerInput;

  final void Function()? onRelease;

  void release() {
    onRelease?.call();
  }

  @override
  bool exists() {
    return innerInput.exists();
  }

  @override
  List<int> getRange(int start, int end) {
    return innerInput.getRange(start, end);
  }

  @override
  int get length => innerInput.length;
}

abstract class AsyncImageInput {
  const AsyncImageInput();

  factory AsyncImageInput.input(ImageInput input) = _SyncInputWrapper;

  Future<bool> supportRangeLoad();

  Future<HaveResourceImageInput> delegateInput();

  Future<int> get length;

  Future<List<int>> getRange(int start, int end);

  Future<bool> exists();
}

class _SyncInputWrapper extends AsyncImageInput {
  final ImageInput _input;

  const _SyncInputWrapper(this._input);

  @override
  Future<bool> supportRangeLoad() async {
    return true;
  }

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

  @override
  Future<HaveResourceImageInput> delegateInput() async {
    return HaveResourceImageInput(innerInput: _input);
  }
}
