import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/core/size.dart';

import 'decoder.dart';

class WebpDecoder extends ImageDecoder {
  final ImageInput input;

  WebpDecoder(this.input);

  @override
  Future<Size> get size async {
    final widthList = input.getRange(0x1a, 0x1c);
    final heightList = input.getRange(0x1c, 0x1e);
    final width = convertRadix16ToInt(await widthList, reverse: true);
    final height = convertRadix16ToInt(await heightList, reverse: true);
    return Size(width, height);
  }

  Future<bool> isLossy() async {
    final v8Tag = await input.getRange(12, 16);
    return v8Tag[3] == 0x20;
  }
}
