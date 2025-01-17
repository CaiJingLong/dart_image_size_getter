import 'package:image_size_getter/image_size_getter.dart';
import 'package:test/test.dart';

void main() {
  group('Test decoder extension', () {
    test('Test gif decoder', () {
      final GifDecoder decoder = GifDecoder();
      expect(decoder.isSupportExtension('gif'), true);
      expect(decoder.isSupportExtension('GIF'), true);

      expect(decoder.isSupportExtension('jpg'), false);
      expect(decoder.isSupportExtension('JPG'), false);
    });

    test('Test jpeg decoder', () {
      final JpegDecoder decoder = JpegDecoder();
      expect(decoder.isSupportExtension('jpg'), true);
      expect(decoder.isSupportExtension('JPG'), true);
      expect(decoder.isSupportExtension('jpeg'), true);
      expect(decoder.isSupportExtension('JPEG'), true);

      expect(decoder.isSupportExtension('gif'), false);
      expect(decoder.isSupportExtension('GIF'), false);
    });

    test('Test png decoder', () {
      final PngDecoder decoder = PngDecoder();
      expect(decoder.isSupportExtension('png'), true);
      expect(decoder.isSupportExtension('PNG'), true);

      expect(decoder.isSupportExtension('jpg'), false);
      expect(decoder.isSupportExtension('JPG'), false);
    });

    test('Test webp decoder', () {
      final WebpDecoder decoder = WebpDecoder();
      expect(decoder.isSupportExtension('webp'), true);
      expect(decoder.isSupportExtension('WEBP'), true);

      expect(decoder.isSupportExtension('jpg'), false);
      expect(decoder.isSupportExtension('JPG'), false);
    });

    test('Test bmp decoder', () {
      final BmpDecoder decoder = BmpDecoder();
      expect(decoder.isSupportExtension('bmp'), true);
      expect(decoder.isSupportExtension('BMP'), true);

      expect(decoder.isSupportExtension('jpg'), false);
      expect(decoder.isSupportExtension('JPG'), false);
    });
  });
}
