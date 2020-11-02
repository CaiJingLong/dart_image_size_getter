import 'dart:io';

import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

class FileInput extends ImageInput {
  final File file;

  FileInput(this.file);

  @override
  Future<List<int>> getRange(int start, int end) async {
    final utils = FileUtils(file);
    return utils.getRangeSync(start, end);
  }

  @override
  Future<int> get length async => file.lengthSync();

  @override
  Future<bool> exists() async {
    return file != null && file.existsSync();
  }
}
