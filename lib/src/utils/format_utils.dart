import 'dart:io';
import 'dart:async';

import 'package:image_size_getter/src/decoder/jpeg_decoder.dart';

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


  static Future<Size> getSize(File file) async {
    if(await isJpg(file)){
      return JpegDecoder(file).size;
    }
    return Size.zero;
  }


}

