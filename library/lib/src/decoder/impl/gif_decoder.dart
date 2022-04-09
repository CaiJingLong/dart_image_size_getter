import 'package:image_size_getter/image_size_getter.dart';

/// {@template image_size_getter.GifDecoder}
///
/// [GifDecoder] is a class for decoding gif image.
///
/// {@endtemplate}
class GifDecoder extends BaseDecoder with SimpleTypeValidator {
  /// {@macro image_size_getter.GifDecoder}
  const GifDecoder();

  String get decoderName => 'gif';

  Size _getSize(List<int> widthList, List<int> heightList) {
    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);

    return Size(width, height);
  }

  @override
  Size getSize(ImageInput input) {
    final widthList = input.getRange(6, 8);
    final heightList = input.getRange(8, 10);

    return _getSize(widthList, heightList);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    final widthList = await input.getRange(6, 8);
    final heightList = await input.getRange(8, 10);

    return _getSize(widthList, heightList);
  }

  @override
  SimpleFileHeaderAndFooter get simpleFileHeaderAndFooter => _GifInfo();
}

class _GifInfo with SimpleFileHeaderAndFooter {
  static const start = [
    0x47,
    0x49,
    0x46,
    0x38,
    0x39,
    0x61,
  ];

  static const end = [0x3B];

  @override
  List<int> get endBytes => end;

  @override
  List<int> get startBytes => start;
}
