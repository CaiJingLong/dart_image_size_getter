import 'dart:io';

import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

class FileInput extends ImageInput {
  final File file;

  FileInput(this.file);

  @override
  List<int> getRange(int start, int end) {
    final utils = FileUtils(file);
    return utils.getRangeSync(start, end);
  }

  @override
  int get length => file.lengthSync();

  @override
  bool exists() {
    return file.existsSync();
  }
}
