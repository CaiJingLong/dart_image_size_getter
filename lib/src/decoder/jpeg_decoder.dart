import 'dart:async';
import 'dart:io';

import 'package:image_size_getter/src/core/size.dart';
import 'package:image_size_getter/src/entity/block_entity.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

import '../core/completer.dart';
import 'decoder.dart';

class JpegDecoder extends ImageDecoder {
  final File file;
  final FileUtils fileUtils;

  JpegDecoder(this.file) : fileUtils = FileUtils(file);

  @override
  Size get size {
    int start = 2;
    BlockEntity block;

    while (true) {
      block = getBlockInfo(start);
      if (block == null) {
        return Size(-1, -1);
      }

      if (block.type == 0xC0) {
        final widthList = fileUtils.getRangeSync(start + 7, start + 9);
        final heightList = fileUtils.getRangeSync(start + 5, start + 7);
        final width = convertRadix16ToInt(widthList);
        final height = convertRadix16ToInt(heightList);
        return Size(width, height);
      } else {
        start += block.length;
      }
    }
  }

  int getIntFromRange(List<int> list, int start, int end) {
    final rangeInt = list.getRange(start, end);
    final sb = StringBuffer();
    for (final i in rangeInt) {
      sb.write(i.toRadixString(16).padLeft(2, '0'));
    }
    return int.tryParse(sb.toString(), radix: 16);
  }

  BlockEntity getBlockInfo(int blackStart) {
    try {
      final blockInfoList = fileUtils.getRangeSync(blackStart, blackStart + 4);

      if (blockInfoList[0] != 0xFF) {
        return null;
      }

      final radix16List =
          fileUtils.getRangeSync(blackStart + 2, blackStart + 4);
      final blockLength = convertRadix16ToInt(radix16List) + 2;
      final typeInt = blockInfoList[1];

      return BlockEntity(typeInt, blockLength);
    } catch (e) {
      return null;
    }
  }
}
