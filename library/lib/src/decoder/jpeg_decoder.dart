import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/core/size.dart';
import 'package:image_size_getter/src/entity/block_entity.dart';

import 'decoder.dart';

class JpegDecoder extends ImageDecoder {
  final ImageInput input;

  JpegDecoder(this.input);

  @override
  Size get size {
    int start = 2;
    BlockEntity? block;

    while (true) {
      block = getBlockInfo(start);
      if (block == null) {
        return Size(-1, -1);
      }

      if (block.type == 0xC0 || block.type == 0xC2) {
        final widthList = input.getRange(start + 7, start + 9);
        final heightList = input.getRange(start + 5, start + 7);
        final width = convertRadix16ToInt(widthList)!;
        final height = convertRadix16ToInt(heightList)!;
        return Size(width, height);
      } else {
        start += block.length;
      }
    }
  }

  int? getIntFromRange(List<int> list, int start, int end) {
    final rangeInt = list.getRange(start, end);
    final sb = StringBuffer();
    for (final i in rangeInt) {
      sb.write(i.toRadixString(16).padLeft(2, '0'));
    }
    return int.tryParse(sb.toString(), radix: 16);
  }

  BlockEntity? getBlockInfo(int blackStart) {
    try {
      final blockInfoList = input.getRange(blackStart, blackStart + 4);

      if (blockInfoList[0] != 0xFF) {
        return null;
      }

      final radix16List = input.getRange(blackStart + 2, blackStart + 4);
      final blockLength = convertRadix16ToInt(radix16List)! + 2;
      final typeInt = blockInfoList[1];

      return BlockEntity(typeInt, blockLength);
    } catch (e) {
      return null;
    }
  }
}
