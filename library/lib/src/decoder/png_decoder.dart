import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/core/size.dart';

import 'decoder.dart';

class PngDecoder extends ImageDecoder {
  final ImageInput input;

  PngDecoder(this.input);

  Future<Size> get size async {
    final widthList = await input.getRange(0x10, 0x14);
    final heightList = await input.getRange(0x14, 0x18);

    final width = convertRadix16ToInt(widthList);
    final height = convertRadix16ToInt(heightList);

    return Size(width, height);
  }
}
