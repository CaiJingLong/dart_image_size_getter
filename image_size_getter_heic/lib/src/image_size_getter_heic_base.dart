import 'dart:typed_data';

import 'package:image_size_getter_bmff/image_size_getter_bmff.dart';
import 'package:image_size_getter_heic/image_size_getter_heic.dart';
import 'package:bmff/bmff.dart';

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
  Future<Size> getSizeAsync(AsyncImageInput input) {
    throw UnimplementedError();
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
