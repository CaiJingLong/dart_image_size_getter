import 'dart:io';

import 'package:image_size_getter/src/core/size.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

import 'decoder.dart';

class PngDecoder extends ImageDecoder {
  final File file;
  final FileUtils fileUtils;

  PngDecoder(this.file) : fileUtils = FileUtils(file);

  Size get size {
    final widthList = fileUtils.getRangeSync(0x10, 0x14);
    final heightList = fileUtils.getRangeSync(0x14, 0x18);

    final width = convertRadix16ToInt(widthList);
    final height = convertRadix16ToInt(heightList);

    return Size(width, height);
  }
}
