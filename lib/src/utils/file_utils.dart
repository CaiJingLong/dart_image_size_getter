import 'dart:io';

import 'package:image_size_getter/src/core/completer.dart';

class FileUtils {
  File file;

  FileUtils(this.file);

  Future<List<int>> readRange(int start, int end) async {
    if (file == null || !file.existsSync()) {
      throw FileNotExistsError();
    }
    if (start < 0) {
      throw RangeError.range(start, 0, file.lengthSync());
    }
    if (end > file.lengthSync()) {
      throw RangeError.range(end, 0, file.lengthSync());
    }

    final c = MyCompleter<List<int>>();

    List<int> result = [];
    file.openRead(start, end).listen((data) {
      result.addAll(data);
    }).onDone(() {
      c.reply(result);
    });

    return c.future;
  }
}

class FileNotExistsError extends Error {}
