import 'dart:typed_data';

import 'package:image_size_getter_heic/image_size_getter_heic.dart';
import 'package:bmff/bmff.dart';

import 'context.dart';

class HeicDecoder extends BaseDecoder {
  @override
  String get decoderName => 'heic';

  @override
  Size getSize(ImageInput input) {
    final bmff = BmffImageContext(input).bmff;
    final buffer = bmff['meta']['iprp']['ipco']['ispe'].getByteBuffer();

    final width = buffer.getUint32(1, Endian.big);
    final height = buffer.getUint32(2, Endian.big);

    return Size(width, height);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    MemoryAsyncBmffContext bmffContext = MemoryAsyncBmffContext(
      () {
        return input.length;
      },
      (start, end) => input.getRange(start, end),
    );

    final bmff = await Bmff.asyncContext(bmffContext);
    final iprp = bmff['meta']['iprp'];
    final ispe = await iprp.updateForceFullBox(false).then((value) async {
      final ipco = iprp['ipco'];
      await ipco.init();
      return ipco;
    }).then((value) => value['ispe']);
    final buffer = await ispe.getByteBuffer();

    final width = buffer.getUint32(1, Endian.big);
    final height = buffer.getUint32(2, Endian.big);

    return Size(width, height);
  }

  @override
  bool isValid(ImageInput input) {
    final bmff = BmffImageContext(input).bmff;
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

extension on AsyncBmffBox {
  AsyncBmffBox operator [](String key) {
    final matched = childBoxes.where((element) => element.type == key);
    if (matched.isEmpty) {
      throw Exception('Not found $key');
    }
    return matched.first;
  }
}
