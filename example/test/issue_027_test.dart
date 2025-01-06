import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:test/test.dart';

class MyJpegDecoder extends JpegDecoder {
  @override
  bool isValid(ImageInput input) {
    final header = input.getRange(0, 2);
    return _checkHeader(header);
  }

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final header = await input.getRange(0, 2);
    return _checkHeader(header);
  }

  bool _checkHeader(List<int> bytes) {
    return bytes[0] == 0xFF && bytes[1] == 0xD8;
  }
}

void main() {
  ImageSizeGetter.registerDecoder(MyJpegDecoder());

  test('valid jpeg test', () {
    final dir = Directory('asset/issue27');
    final files = dir.listSync();
    for (final file in files) {
      if (file.path.endsWith('jpg')) {
        var fileInput = FileInput(File(file.path));
        final isJpg = MyJpegDecoder().isValid(fileInput);
        expect(isJpg, true);

        final result = ImageSizeGetter.getSizeResult(fileInput);
        print(
            'jpg size: ${result.size} (decoded by ${result.decoder.decoderName})');
      }
    }
  });
}
