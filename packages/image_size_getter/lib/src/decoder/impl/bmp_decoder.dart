import 'package:image_size_getter/image_size_getter.dart';

/// {@template image_size_getter.BmpDecoder}
///
/// [BmpDecoder] is a class for decoding BMP file.
///
/// {@endtemplate}
class BmpDecoder extends BaseDecoder {
  /// {@macro image_size_getter.BmpDecoder}
  const BmpDecoder();

  @override
  String get decoderName => 'bmp';

  @override
  Size getSize(ImageInput input) {
    final widthList = input.getRange(0x12, 0x16);
    final heightList = input.getRange(0x16, 0x1a);

    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    final widthList = await input.getRange(0x12, 0x16);
    final heightList = await input.getRange(0x16, 0x1a);

    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  @override
  bool isValid(ImageInput input) {
    final list = input.getRange(0, 2);
    return _isBmp(list);
  }

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final list = await input.getRange(0, 2);
    return _isBmp(list);
  }

  bool _isBmp(List<int> startList) {
    return startList[0] == 66 && startList[1] == 77;
  }
}
