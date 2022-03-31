import 'dart:io';

import 'package:http/http.dart';
import 'package:image_size_getter/file_input.dart';

import 'image_size_getter_http_input_base.dart';

Future<ImageInputWrapper> createDelegateInput(Uri uri) async {
  if (httpCachePath.isEmpty) {
    throw UnsupportedError(
        'You must set httpCachePath before using http input.');
  }

  String pathSplitter = '/';

  if (Platform.isWindows) {
    pathSplitter = '\\';
  }

  final response = await get(uri);
  final bodyBytes = response.bodyBytes;
  final file = File('$httpCachePath$pathSplitter${uri.pathSegments.last}');
  await file.writeAsBytes(bodyBytes);

  return ImageInputWrapper(
    FileInput(file),
    () async {
      await file.delete();
    },
  );
}
