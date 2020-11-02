import 'package:collection/collection.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/decoder/gif_decoder.dart';

import 'package:image_size_getter/src/decoder/jpeg_decoder.dart';
import 'package:image_size_getter/src/decoder/png_decoder.dart';
import 'package:image_size_getter/src/decoder/webp_decoder.dart';
export 'core/input.dart';

class ImageSizeGetter {
  static Future<bool> isJpg(ImageInput input) async {
    if (input == null || !await input.exists()) {
      return false;
    }

    const start = [0xFF, 0xD8];
    final startList = await input.getRange(0, 2);
    const eq = ListEquality();

    if (input.runtimeType != NetworkInput) {
      const end = [0xFF, 0xD9];
      final length = await input.length;
      final endList = await input.getRange(length - 2, length);
      return eq.equals(start, startList) && eq.equals(end, endList);
    } else {
      return eq.equals(start, startList);
    }
  }

  static Future<bool> isPng(ImageInput input) async {
    final length = await input.length;

    final start = await input.getRange(0, 8);
    const eq = IterableEquality();
    if (input.runtimeType != NetworkInput) {
      final end = await input.getRange(length - 12, length);
      if (eq.equals(start, _PngHeaders.sig) &&
          eq.equals(end, _PngHeaders.iend)) {
        return true;
      }
    } else if (eq.equals(start, _PngHeaders.sig)) {
      return true;
    }
    return false;
  }

  static Future<bool> isWebp(ImageInput input) async {
    final sizeStart = await input.getRange(0, 4);
    final sizeEnd = await input.getRange(8, 12);

    const eq = ListEquality();

    if (eq.equals(sizeStart, _WebpHeaders.fileSizeStart) &&
        eq.equals(sizeEnd, _WebpHeaders.fileSizeEnd)) {
      return true;
    }
    return false;
  }

  static Future<bool> isGif(ImageInput input) async {
    const eq = ListEquality();
    final length = await input.length;

    final sizeStart = await input.getRange(0, 6);
    if (input.runtimeType != NetworkInput) {
      final sizeEnd = await input.getRange(length - 1, length);
      return eq.equals(sizeStart, _GifHeaders.start) &&
          eq.equals(sizeEnd, _GifHeaders.end);
    } else {
      return eq.equals(sizeStart, _GifHeaders.start);
    }
  }

  static Future<Size> getSize(ImageInput input) async {
    if (await isJpg(input)) {
      return JpegDecoder(input).size;
    }
    if (await isPng(input)) {
      return PngDecoder(input).size;
    }
    if (await isWebp(input)) {
      return WebpDecoder(input).size;
    }
    if (await isGif(input)) {
      return GifDecoder(input).size;
    }
    return Size.zero;
  }
}

class _PngHeaders {
  static const sig = [
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
  ];

  static const iend = [
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82
  ];
}

class _WebpHeaders {
  static const fileSizeStart = [
    0x52,
    0x49,
    0x46,
    0x46,
  ];

  static const fileSizeEnd = [
    0x57,
    0x45,
    0x42,
    0x50,
  ];
}

class _GifHeaders {
  static const start = [
    0x47,
    0x49,
    0x46,
    0x38,
    0x39,
    0x61,
  ];

  static const end = [0x3B];
}
