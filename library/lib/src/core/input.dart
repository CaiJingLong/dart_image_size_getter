abstract class ImageInput {
  const ImageInput();

  Future<int> get length;

  Future<List<int>> getRange(int start, int end);

  Future<bool> exists();
}
