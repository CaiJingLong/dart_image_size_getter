import 'dart:io';

import 'package:image_size_getter/src/core/size.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

import 'decoder.dart';

class WebpDecoder extends ImageDecoder {
  final File file;
  final FileUtils fileUtils;

  WebpDecoder(this.file) : fileUtils = FileUtils(file);

  @override
  Size get size {
    final widthList = fileUtils.getRangeSync(0x1a, 0x1c);
    final heightList = fileUtils.getRangeSync(0x1c, 0x1e);
    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  Future<bool> isLossy() async {
    final v8Tag = await fileUtils.getRange(12, 16);
    return v8Tag[3] == 0x20;
  }
}
