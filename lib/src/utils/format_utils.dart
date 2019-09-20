import 'dart:io';
import 'dart:async';
import 'package:collection/equality.dart';

import 'package:image_size_getter/src/decoder/jpeg_decoder.dart';
import 'package:image_size_getter/src/decoder/png_decoder.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

import '../../image_size_getter.dart';
import '../core/completer.dart';

class FormatUtils {
  static Future<bool> isJpg(File file) async {
    if (file == null || !file.existsSync()) {
      return false;
    }

    final length = file.lengthSync();

    final completer = MyCompleter<bool>();

    void handleEnd() {
      file.openRead(length - 2, length).listen((data) {
        if (data[0] == 0xFF && data[1] == 0xD9) {
          completer.reply(true);
        } else {
          completer.reply(false);
        }
      });
    }

    void handleStart() async {
      file.openRead(0, 2).listen((data) {
        if (data[0] == 0xFF && data[1] == 0xD8) {
          handleEnd();
        } else {
          completer.reply(false);
        }
      });
    }

    handleStart();

    return completer.future;
  }

  static Future<bool> isPng(File file) async {
    final utils = FileUtils(file);
    final length = file.lengthSync();

    final start = await utils.readRange(0, 8);
    final end = await utils.readRange(length - 12, length);
    const eq = IterableEquality();
    if (eq.equals(start, _PngHeaders.sig) && eq.equals(end, _PngHeaders.iend)) {
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
