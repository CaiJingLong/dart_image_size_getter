import 'package:collection/collection.dart';
import 'package:image_size_getter/image_size_getter.dart';

/// {@template image_size_getter.WebpDecoder}
///
/// [WebpDecoder] is a class for decoding webp image.
///
/// {@endtemplate}
class WebpDecoder extends BaseDecoder {
  /// {@macro image_size_getter.WebpDecoder}
  const WebpDecoder();

  @override
  String get decoderName => 'webp';

  @override
  Size getSize(ImageInput input) {
    final chunkHeader = input.getRange(12, 16);
    if (_isExtendedFormat(chunkHeader)) {
      final widthList = input.getRange(0x18, 0x1b);
      final heightList = input.getRange(0x1b, 0x1d);
      return _createExtendedFormatSize(widthList, heightList);
    } else if (_isLosslessFormat(chunkHeader)) {
      final sizeList = input.getRange(0x15, 0x19);
      return _createLosslessFormatSize(sizeList);
    } else {
      final widthList = input.getRange(0x1a, 0x1c);
      final heightList = input.getRange(0x1c, 0x1e);
      return _createNormalSize(widthList, heightList);
    }
  }

  Size _createNormalSize(List<int> widthList, List<int> heightList) {
    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  Size _createExtendedFormatSize(List<int> widthList, List<int> heightList) {
    final width = convertRadix16ToInt(widthList, reverse: true) + 1;
    final height = convertRadix16ToInt(heightList, reverse: true) + 1;
    return Size(width, height);
  }

  Size _createLosslessFormatSize(List<int> sizeList) {
    final bits = sizeList
        .map(
          (i) => i.toRadixString(2).split('').reversed.join().padRight(8, '0'),
        )
        .join()
        .split('');
    final width =
        (int.tryParse(bits.sublist(0, 14).reversed.join(), radix: 2) ?? 0) + 1;
    final height =
        (int.tryParse(bits.sublist(14, 28).reversed.join(), radix: 2) ?? 0) + 1;
    return Size(width, height);
  }

  bool _isExtendedFormat(List<int> chunkHeader) {
    return ListEquality().equals(chunkHeader, "VP8X".codeUnits);
  }

  bool _isLosslessFormat(List<int> chunkHeader) {
    return ListEquality().equals(chunkHeader, "VP8L".codeUnits);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    final chunkHeader = await input.getRange(12, 16);
    if (_isExtendedFormat(chunkHeader)) {
      final widthList = await input.getRange(0x18, 0x1b);
      final heightList = await input.getRange(0x1b, 0x1d);
      return _createExtendedFormatSize(widthList, heightList);
    } else if (_isLosslessFormat(chunkHeader)) {
      final sizeList = await input.getRange(0x15, 0x19);
      return _createLosslessFormatSize(sizeList);
    } else {
      final widthList = await input.getRange(0x1a, 0x1c);
      final heightList = await input.getRange(0x1c, 0x1e);
      return _createNormalSize(widthList, heightList);
    }
  }

  @override
  bool isValid(ImageInput input) {
    final sizeStart = input.getRange(0, 4);
    final sizeEnd = input.getRange(8, 12);

    const eq = ListEquality();

    if (eq.equals(sizeStart, _WebpHeaders.fileSizeStart) &&
        eq.equals(sizeEnd, _WebpHeaders.fileSizeEnd)) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final sizeStart = await input.getRange(0, 4);
    final sizeEnd = await input.getRange(8, 12);

    const eq = ListEquality();

    if (eq.equals(sizeStart, _WebpHeaders.fileSizeStart) &&
        eq.equals(sizeEnd, _WebpHeaders.fileSizeEnd)) {
      return true;
    }
    return false;
  }
}

class _WebpHeaders with SimpleFileHeaderAndFooter {
  static const fileSizeStart = [
    0x52,
    0x49,
    0x46,
    0x46,
  ];

  static const fileSizeEnd = [
    0x57,
    0x45,
    0x42,
    0x50,
  ];

  @override
  List<int> get endBytes => fileSizeEnd;

  @override
  List<int> get startBytes => fileSizeStart;
}
