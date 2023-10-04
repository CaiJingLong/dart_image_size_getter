import 'dart:typed_data';

import 'package:image_size_getter_heic/image_size_getter_heic.dart';
import 'package:bmff/bmff.dart';

import 'context.dart';
import 'types.dart';

class HeicDecoder extends BaseDecoder {
  HeicDecoder({this.fullTypeBox = defaultFullBoxTypes});

  final List<String> fullTypeBox;

  @override
  String get decoderName => 'heic';

  @override
  Size getSize(ImageInput input) {
    final bmff = BmffImageContext(input, fullBoxTypes: fullTypeBox).bmff;
    final ipcoBox = bmff['meta']['iprp']['ipco'];

    int width = 0;
    int height = 0;

    for (final childBox in ipcoBox.childBoxes) {
      if (childBox.type != 'ispe') {
        continue;
      }

      final buffer = childBox.getByteBuffer();
      final boxWidth = buffer.getUint32(0, Endian.big);
      final boxHeight = buffer.getUint32(1, Endian.big);
      if (boxWidth * boxHeight > width * height) {
        width = boxWidth;
        height = boxHeight;
      }
    }

    return Size(width, height);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    final context = AsyncBmffContext.common(
      () {
        return input.length;
      },
      (start, end) => input.getRange(start, end),
      fullBoxTypes: fullTypeBox,
    );

    final bmff = await Bmff.asyncContext(context);
    // final iprp = bmff['meta']['iprp'];
    // final ispe = await iprp.updateForceFullBox(false).then((value) async {
    //   final ipco = iprp['ipco'];
    //   await ipco.init();
    //   return ipco;
    // }).then((value) => value['ispe']);

    final ispe = bmff['meta']['iprp']['ipco']['ispe'];

    final buffer = await ispe.getByteBuffer();

    final width = buffer.getUint32(0, Endian.big);
    final height = buffer.getUint32(1, Endian.big);

    return Size(width, height);
  }

  @override
  bool isValid(ImageInput input) {
    final bmff = BmffImageContext(input, fullBoxTypes: fullTypeBox).bmff;
    return _checkHeic(bmff);
  }

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final lengthBytes = await input.getRange(0, 4);
    final length = lengthBytes.toBigEndian();
    final typeBoxBytes = await input.getRange(0, length);

    final bmff = Bmff.memory(typeBoxBytes);
    return _checkHeic(bmff);
  }

  bool _checkHeic(Bmff bmff) {
    final typeBox = bmff.typeBox;
    final compatibleBrands = typeBox.compatibleBrands;
    return compatibleBrands.contains('heic');
  }
}
