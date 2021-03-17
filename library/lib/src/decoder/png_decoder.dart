import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/core/size.dart';

import 'decoder.dart';

class PngDecoder extends ImageDecoder {
  final ImageInput input;

  PngDecoder(this.input);

  Size get size {
    final widthList = input.getRange(0x10, 0x14);
    final heightList = input.getRange(0x14, 0x18);

    final width = convertRadix16ToInt(widthList)!;
    final height = convertRadix16ToInt(heightList)!;

    return Size(width, height);
  }
}
