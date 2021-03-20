abstract class ImageInput {
  const ImageInput();

  int get length;

  List<int> getRange(int start, int end);

  bool exists();
}

abstract class AsyncImageInput {
  const AsyncImageInput();

  Future<int> get length;

  Future<List<int>> getRange(int start, int end);

  Future<bool> exists();
}
