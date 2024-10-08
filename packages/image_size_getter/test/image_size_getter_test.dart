import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:test/test.dart';

void main() {
  group('Test decoders', () {
    test('Test gif decoder', () {
      final gif = File('../../example/asset/dialog.gif');

      const GifDecoder decoder = GifDecoder();
      final input = FileInput(gif);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(688, 1326));
    });

    test('Test jpeg decoder', () {
      final jpeg = File('../../example/asset/IMG_20180908_080245.jpg');

      const JpegDecoder decoder = JpegDecoder();
      final input = FileInput(jpeg);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(4032, 3024));
    });


    test('Test non-standard jpeg decoder', () {
      final jpeg = File('../../example/asset/test.MP.jpg');

      const JpegDecoder decoder = JpegDecoder(isStandardJpeg: false);
      final input = FileInput(jpeg);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(3840, 2160, needRotate: true));
    });


    test('Test png decoder', () {
      final png = File('../../example/asset/ic_launcher.png');

      const PngDecoder decoder = PngDecoder();
      final input = FileInput(png);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(96, 96));
    });

    test('Test webp decoder', () {
      final webp = File('../../example/asset/demo.webp');

      const WebpDecoder decoder = WebpDecoder();
      final input = FileInput(webp);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(988, 466));
    });

    test('Test bmp decoder', () {
      final bmp = File('../../example/asset/demo.bmp');

      const BmpDecoder decoder = BmpDecoder();
      final input = FileInput(bmp);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(256, 256));
    });

    test('Test have orientation jpeg', () {
      final orientation3 = File('../../example/asset/have_orientation_exif_3.jpg');

      const JpegDecoder decoder = JpegDecoder();
      final input = FileInput(orientation3);

      assert(decoder.isValid(input));
      expect(decoder.getSize(input), Size(533, 799));

      final orientation6 = File('../../example/asset/have_orientation_exif_6.jpg');
      final input2 = FileInput(orientation6);

      assert(decoder.isValid(input2));
      final size = decoder.getSize(input2);
      expect(size, Size(3264, 2448, needRotate: true));
    });
  });

  group('Test get size.', () {
    test('Test webp size', () async {
      final file = File('../../example/asset/demo.webp');
      final size = ImageSizeGetter.getSize(FileInput(file));
      print('size = $size');
      await expectLater(size, Size(988, 466));
    });

    test('Test webp extended format size', () async {
      final file = File('../../example/asset/demo_extended.webp');
      final size = ImageSizeGetter.getSize(FileInput(file));
      print('size = $size');
      await expectLater(size, Size(988, 466));
    });

    test('Test webp lossless format size', () async {
      final file = File('../../example/asset/demo_lossless.webp');
      final size = ImageSizeGetter.getSize(FileInput(file));
      print('size = $size');
      await expectLater(size, Size(988, 466));
    });

    test('Test jpeg size', () async {
      final file = File('../../example/asset/IMG_20180908_080245.jpg');
      final size = ImageSizeGetter.getSize(FileInput(file));
      print('size = $size');
      await expectLater(size, Size(4032, 3024));
    });

    test('Test non-standard jpeg size', () async {
      final file = File('../../example/asset/test.MP.jpg');
      final size = ImageSizeGetter.getSize(FileInput(file));
      print('size = $size');
      await expectLater(size, Size(3840, 2160, needRotate: true));
    });

    group('Test gif size', () {
      test('89a', () async {
        final file = File('../../example/asset/dialog.gif');
        final size = ImageSizeGetter.getSize(FileInput(file));
        print('size = $size');
        await expectLater(size, Size(688, 1326));
      });

      test('87a', () async {
        final file = File('../../example/asset/87a.gif');
        final size = ImageSizeGetter.getSize(FileInput(file));
        print('size = $size');
        await expectLater(size, Size(200, 150));
      });
    });

    test('Test png size', () async {
      final file = File('../../example/asset/ic_launcher.png');
      final size = ImageSizeGetter.getSize(FileInput(file));
      print('size = $size');
      await expectLater(size, Size(96, 96));
    });

    test('Test png size with memory', () async {
      final file = File('../../example/asset/ic_launcher.png');
      final bytes = file.readAsBytesSync();
      final size = ImageSizeGetter.getSize(MemoryInput(bytes));
      print('size = $size');
      await expectLater(size, Size(96, 96));
    });
  });
}
