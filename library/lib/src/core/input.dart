abstract class ImageInput {
  const ImageInput();

  int get length;

  List<int> getRange(int start, int end);

  bool exists();
}
