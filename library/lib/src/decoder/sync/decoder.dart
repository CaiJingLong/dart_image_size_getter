import 'package:image_size_getter/src/core/size.dart';

import 'package:image_size_getter/src/entity/block_entity.dart';

import 'package:image_size_getter/src/core/input.dart';

part 'gif_decoder.dart';
part 'jpeg_decoder.dart';
part 'png_decoder.dart';
part 'webp_decoder.dart';

abstract class ImageDecoder {
  Size get size;

  int convertRadix16ToInt(List<int> list, {bool reverse = false}) {
    final sb = StringBuffer();
    if (reverse) {
      list = list.toList().reversed.toList();
    }

    for (final i in list) {
      sb.write(i.toRadixString(16).padLeft(2, '0'));
    }
    final numString = sb.toString();
    return int.tryParse(numString, radix: 16) ?? 0;
  }
}
