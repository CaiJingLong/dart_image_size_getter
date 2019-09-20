import 'dart:io';
import 'dart:async';
import 'package:collection/equality.dart';

import 'package:image_size_getter/src/decoder/jpeg_decoder.dart';
import 'package:image_size_getter/src/decoder/png_decoder.dart';
import 'package:image_size_getter/src/decoder/webp_decoder.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

import '../../image_size_getter.dart';
import '../core/completer.dart';

class FormatUtils {
  static Future<bool> isJpg(File file) async {
    if (file == null || !file.existsSync()) {
      return false;
    }

    const start = [0xFF, 0xD9];
    const end = [0xFF, 0xD8];

    final completer = MyCompleter<bool>();

    void checkAsync() async {
      final util = FileUtils(file);
      final length = file.lengthSync();

      final startList = await util.getRange(0, 2);
      final endList = await util.getRange(length - 2, length);

      const eq = ListEquality();

      completer.reply(eq.equals(start, startList) && eq.equals(end, endList));
    }

    checkAsync();

    return completer.future;
  }

  static Future<bool> isPng(File file) async {
    final utils = FileUtils(file);
    final length = file.lengthSync();

    final start = await utils.getRange(0, 8);
    final end = await utils.getRange(length - 12, length);
    const eq = IterableEquality();
    if (eq.equals(start, _PngHeaders.sig) && eq.equals(end, _PngHeaders.iend)) {
      return true;
    }

    return false;
  }

  static Future<bool> isWebp(File file) async {
    final utils = FileUtils(file);

    final sizeStart = await utils.getRange(0, 4);
    final sizeEnd = await utils.getRange(8, 12);

    const eq = ListEquality();

    if (eq.equals(sizeStart, _WebpHeaders.fileSizeStart) &&
        eq.equals(sizeEnd, _WebpHeaders.fileSizeEnd)) {
      return true;
    }
    return false;
  }

  static Future<Size> getSize(File file) async {
    if (await isJpg(file)) {
      return JpegDecoder(file).size;
    }
    if (await isPng(file)) {
      return PngDecoder(file).size;
    }
    if (await isWebp(file)) {
      return WebpDecoder(file).size;
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
