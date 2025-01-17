import 'package:image_size_getter/image_size_getter.dart';
import 'package:test/test.dart';

void main() {
  group('Test decoder extension', () {
    test('Test gif decoder', () {
      final GifDecoder decoder = GifDecoder();
      expect(decoder.isExtensionSupported('gif'), true);
      expect(decoder.isExtensionSupported('GIF'), true);

      expect(decoder.isExtensionSupported('jpg'), false);
      expect(decoder.isExtensionSupported('JPG'), false);
    });

    test('Test jpeg decoder', () {
      final JpegDecoder decoder = JpegDecoder();
      expect(decoder.isExtensionSupported('jpg'), true);
      expect(decoder.isExtensionSupported('JPG'), true);
      expect(decoder.isExtensionSupported('jpeg'), true);
      expect(decoder.isExtensionSupported('JPEG'), true);

      expect(decoder.isExtensionSupported('gif'), false);
      expect(decoder.isExtensionSupported('GIF'), false);
    });

    test('Test png decoder', () {
      final PngDecoder decoder = PngDecoder();
      expect(decoder.isExtensionSupported('png'), true);
      expect(decoder.isExtensionSupported('PNG'), true);

      expect(decoder.isExtensionSupported('jpg'), false);
      expect(decoder.isExtensionSupported('JPG'), false);
    });

    test('Test webp decoder', () {
      final WebpDecoder decoder = WebpDecoder();
      expect(decoder.isExtensionSupported('webp'), true);
      expect(decoder.isExtensionSupported('WEBP'), true);

      expect(decoder.isExtensionSupported('jpg'), false);
      expect(decoder.isExtensionSupported('JPG'), false);
    });

    test('Test bmp decoder', () {
      final BmpDecoder decoder = BmpDecoder();
      expect(decoder.isExtensionSupported('bmp'), true);
      expect(decoder.isExtensionSupported('BMP'), true);

      expect(decoder.isExtensionSupported('jpg'), false);
      expect(decoder.isExtensionSupported('JPG'), false);
    });
  });
}
