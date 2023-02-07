import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter_heic/image_size_getter_heic.dart';
import 'package:test/test.dart';

void main() {
  group('', () {
    test('Test heic decoder', () {
      final decoder = HeicDecoder();
      final input = FileInput(File('example/asset/example.heic'));
      // expect(decoder.isValid(input), equals(true));

      final asyncInput = AsyncImageInput.input(input);
      expect(decoder.isValidAsync(asyncInput), completion(equals(true)));
    });
  });

  test('Test get heic size', () async {
    final decoder = HeicDecoder();
    ImageSizeGetter.registerDecoder(decoder);
    final input = FileInput(File('example/asset/example.heic'));
    expect(decoder.getSize(input), equals(Size(1440, 960)));

    final asyncInput = AsyncImageInput.input(input);
    final size = await decoder.getSizeAsync(asyncInput);
    expect(size, equals(Size(1440, 960)));
  });
}
