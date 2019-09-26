import 'dart:io';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/src/decoder/gif_decoder.dart';

import 'package:image_size_getter/src/decoder/jpeg_decoder.dart';
import 'package:image_size_getter/src/decoder/png_decoder.dart';
import 'package:image_size_getter/src/decoder/webp_decoder.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

class ImageSizGetter {
  static bool isJpg(File file) {
    if (file == null || !file.existsSync()) {
      return false;
    }

    const start = [0xFF, 0xD8];
    const end = [0xFF, 0xD9];

    final util = FileUtils(file);
    final length = file.lengthSync();

    final startList = util.getRangeSync(0, 2);
    final endList = util.getRangeSync(length - 2, length);

    const eq = ListEquality();

    return eq.equals(start, startList) && eq.equals(end, endList);
  }

  static bool isPng(File file) {
    final utils = FileUtils(file);
    final length = file.lengthSync();

    final start = utils.getRangeSync(0, 8);
    final end = utils.getRangeSync(length - 12, length);
    const eq = IterableEquality();
    if (eq.equals(start, _PngHeaders.sig) && eq.equals(end, _PngHeaders.iend)) {
      return true;
    }

    return false;
  }

  static bool isWebp(File file) {
    final utils = FileUtils(file);

    final sizeStart = utils.getRangeSync(0, 4);
    final sizeEnd = utils.getRangeSync(8, 12);

    const eq = ListEquality();

    if (eq.equals(sizeStart, _WebpHeaders.fileSizeStart) &&
        eq.equals(sizeEnd, _WebpHeaders.fileSizeEnd)) {
      return true;
    }
    return false;
  }

  static bool isGif(File file) {
    final utils = FileUtils(file);

    const eq = ListEquality();
    final length = file.lengthSync();

    final sizeStart = utils.getRangeSync(0, 6);
    final sizeEnd = utils.getRangeSync(length - 1, length);

    return eq.equals(sizeStart, _GifHeaders.start) &&
        eq.equals(sizeEnd, _GifHeaders.end);
  }

  static Size getSize(File file) {
    if (isJpg(file)) {
      return JpegDecoder(file).size;
    }
    if (isPng(file)) {
      return PngDecoder(file).size;
    }
    if (isWebp(file)) {
      return WebpDecoder(file).size;
    }
    if (isGif(file)) {
      return GifDecoder(file).size;
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
