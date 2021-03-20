part of 'decoder.dart';

class GifDecoder extends AsyncImageDecoder {
  GifDecoder(AsyncImageInput input) : super(input);

  @override
  Future<Size> get size async {
    final widthList = await input.getRange(6, 8);
    final heightList = await input.getRange(8, 10);

    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);

    return Size(width, height);
  }
}
