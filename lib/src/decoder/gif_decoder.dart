import 'dart:async';
import 'dart:io';

import 'package:image_size_getter/src/core/size.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

import 'decoder.dart';

class GifDecoder extends ImageDecoder {
  final File file;
  final FileUtils fileUtils;

  GifDecoder(this.file) : fileUtils = FileUtils(file);

  @override
  Size get size {
    final widthList = fileUtils.getRangeSync(6, 8);
    final heightList = fileUtils.getRangeSync(8, 10);

    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);

    return Size(width, height);
  }
}
