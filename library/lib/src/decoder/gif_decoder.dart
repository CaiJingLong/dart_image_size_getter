import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/core/size.dart';

import 'decoder.dart';

class GifDecoder extends ImageDecoder {
  final ImageInput input;

  GifDecoder(this.input);

  @override
  Size get size {
    final widthList = input.getRange(6, 8);
    final heightList = input.getRange(8, 10);

    final width = convertRadix16ToInt(widthList, reverse: true)!;
    final height = convertRadix16ToInt(heightList, reverse: true)!;

    return Size(width, height);
  }
}
