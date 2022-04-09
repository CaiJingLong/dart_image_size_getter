import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/src/entity/block_entity.dart';

/// {@template image_size_getter.JpegDecoder}
///
/// [JpegDecoder] is a class for decoding JPEG image.
///
/// {@endtemplate}
class JpegDecoder extends BaseDecoder with SimpleTypeValidator {
  /// {@macro image_size_getter.JpegDecoder}
  const JpegDecoder();

  @override
  String get decoderName => 'jpeg';

  @override
  Size getSize(ImageInput input) {
    int start = 2;
    BlockEntity? block;

    while (true) {
      block = _getBlockSync(input, start);

      if (block == null) {
        throw Exception('Invalid jpeg file');
      }

      if (block.type == 0xC0 || block.type == 0xC2) {
        final widthList = input.getRange(start + 7, start + 9);
        final heightList = input.getRange(start + 5, start + 7);
        return _getSize(widthList, heightList);
      } else {
        start += block.length;
      }
    }
  }

  Size _getSize(List<int> widthList, List<int> heightList) {
    final width = convertRadix16ToInt(widthList);
    final height = convertRadix16ToInt(heightList);
    return Size(width, height);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    int start = 2;
    BlockEntity? block;

    while (true) {
      block = await _getBlockAsync(input, start);

      if (block == null) {
        throw Exception('Invalid jpeg file');
      }

      if (block.type == 0xC0 || block.type == 0xC2) {
        final widthList = await input.getRange(start + 7, start + 9);
        final heightList = await input.getRange(start + 5, start + 7);
        return _getSize(widthList, heightList);
      } else {
        start += block.length;
      }
    }
  }

  BlockEntity? _getBlockSync(ImageInput input, int blackStart) {
    try {
      final blockInfoList = input.getRange(blackStart, blackStart + 4);

      if (blockInfoList[0] != 0xFF) {
        return null;
      }

      final radix16List = input.getRange(blackStart + 2, blackStart + 4);

      return _createBlock(radix16List, blackStart, blockInfoList);
    } catch (e) {
      return null;
    }
  }

  Future<BlockEntity?> _getBlockAsync(
      AsyncImageInput input, int blackStart) async {
    try {
      final blockInfoList = await input.getRange(blackStart, blackStart + 4);

      if (blockInfoList[0] != 0xFF) {
        return null;
      }

      final sizeList = await input.getRange(blackStart + 2, blackStart + 4);

      return _createBlock(sizeList, blackStart, blockInfoList);
    } catch (e) {
      return null;
    }
  }

  BlockEntity _createBlock(
      List<int> sizeList, int blackStart, List<int> blockInfoList) {
    final blockLength = convertRadix16ToInt(sizeList) + 2;
    final typeInt = blockInfoList[1];

    return BlockEntity(typeInt, blockLength);
  }

  @override
  SimpleFileHeaderAndFooter get simpleFileHeaderAndFooter => _JpegInfo();
}

class _JpegInfo with SimpleFileHeaderAndFooter {
  static const start = [0xFF, 0xD8];
  static const end = [0xFF, 0xD9];

  @override
  List<int> get endBytes => end;

  @override
  List<int> get startBytes => start;
}
