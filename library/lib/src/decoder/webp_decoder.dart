import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/core/size.dart';

import 'decoder.dart';

class WebpDecoder extends ImageDecoder {
  final ImageInput input;

  WebpDecoder(this.input);

  @override
  Size get size {
    final widthList = input.getRange(0x1a, 0x1c);
    final heightList = input.getRange(0x1c, 0x1e);
    final width = convertRadix16ToInt(widthList, reverse: true)!;
    final height = convertRadix16ToInt(heightList, reverse: true)!;
    return Size(width, height);
  }

  Future<bool> isLossy() async {
    final v8Tag = input.getRange(12, 16);
    return v8Tag[3] == 0x20;
  }
}
