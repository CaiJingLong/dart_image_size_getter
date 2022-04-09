import 'dart:io';

import 'package:image_size_getter/src/core/input.dart';
import 'package:image_size_getter/src/utils/file_utils.dart';

///
/// {@template image_size_getter.file_input}
///
/// [ImageInput] using file as input source.
///
/// {@endtemplate}
///
class FileInput extends ImageInput {
  /// {@macro image_size_getter.file_input}
  const FileInput(this.file);

  final File file;

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
