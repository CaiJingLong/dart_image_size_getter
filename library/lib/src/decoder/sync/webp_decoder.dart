part of 'decoder.dart';

class WebpDecoder extends ImageDecoder {
  final ImageInput input;

  WebpDecoder(this.input);

  @override
  Size get size {
    if (_isExtendedFormat()) {
      final widthList = input.getRange(0x18, 0x1b);
      final heightList = input.getRange(0x1b, 0x1d);
      final width = convertRadix16ToInt(widthList, reverse: true) + 1;
      final height = convertRadix16ToInt(heightList, reverse: true) + 1;
      return Size(width, height);
    } else {
      final widthList = input.getRange(0x1a, 0x1c);
      final heightList = input.getRange(0x1c, 0x1e);
      final width = convertRadix16ToInt(widthList, reverse: true);
      final height = convertRadix16ToInt(heightList, reverse: true);
      return Size(width, height);
    }
  }

  Future<bool> isLossy() async {
    final v8Tag = input.getRange(12, 16);
    return v8Tag[3] == 0x20;
  }

  bool _isExtendedFormat() {
    final chunkHeader = input.getRange(12, 16);
    return ListEquality().equals(chunkHeader, "VP8X".codeUnits);
  }
}
