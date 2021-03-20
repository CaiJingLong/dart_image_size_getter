part of 'decoder.dart';

class WebpDecoder extends AsyncImageDecoder {
  WebpDecoder(AsyncImageInput input) : super(input);

  @override
  Future<Size> get size async {
    final widthList = await input.getRange(0x1a, 0x1c);
    final heightList = await input.getRange(0x1c, 0x1e);
    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  Future<bool> isLossy() async {
    final v8Tag = await input.getRange(12, 16);
    return v8Tag[3] == 0x20;
  }
}
