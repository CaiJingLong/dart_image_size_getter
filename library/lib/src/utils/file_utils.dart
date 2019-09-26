import 'dart:io';


class FileUtils {
  File file;

  FileUtils(this.file);

  Future<List<int>> getRange(int start, int end) async {
    return getRangeSync(start, end);
  }

  List<int> getRangeSync(int start, int end) {
    final accessFile = file.openSync();
    try {
      accessFile.setPositionSync(start);
      return accessFile.readSync(end - start).toList();
    } finally {
      accessFile.closeSync();
    }
  }
}

class FileNotExistsError extends Error {}
