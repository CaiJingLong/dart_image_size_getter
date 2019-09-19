import 'dart:async';
import 'dart:io';

import 'package:image_size_getter/src/core/size.dart';

import '../core/completer.dart';

class JpegDecoder {
  final File file;

  JpegDecoder(this.file);

  Future<Size> get size {
    final completer = MyCompleter<Size>();
    final stream = file.openRead();
    StreamSubscription sub;

    sub = stream.listen((data) {
      var startIndex = 0;
      while (startIndex < data.length) {
        final current = data.indexOf(0xFF, startIndex);
        if (current == -1) {
          return;
        }
        if (current == data.length - 1) {
          return;
        }

        final next = data[current + 1];

        if (next != 0xC0) {
          startIndex = current + 1;
          continue;
        }

        int width = getIntFromRange(data, current + 5, current + 7);
        int height = getIntFromRange(data, current + 7, current + 9);
        completer.reply(Size(width, height));
        sub.cancel();
        return;
      }
      completer.reply(Size.zero);
      sub.cancel();
    });

    return completer.future;
  }

  int getIntFromRange(List<int> list, int start, int end) {
    final rangeInt = list.getRange(start, end);
    final sb = StringBuffer();
    for (final i in rangeInt) {
      sb.write(i.toRadixString(16).padLeft(2, '0'));
    }
    return int.tryParse(sb.toString(), radix: 16);
  }
}
