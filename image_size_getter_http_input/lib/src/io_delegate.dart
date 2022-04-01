import 'dart:io';

import 'package:http/http.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

import 'image_size_getter_http_input_base.dart';

Future<ImageInputWrapper> createDelegateInput(Uri uri) async {
  ImageInput input;

  final response = await get(uri);
  final bodyBytes = response.bodyBytes;

  if (httpCachePath.isEmpty) {
    input = MemoryInput(bodyBytes);
  } else {
    final file =
        File('$httpCachePath${Platform.pathSeparator}${uri.pathSegments.last}');
    if (file.parent.existsSync() == false) {
      file.parent.createSync(recursive: true);
    }
    file.writeAsBytesSync(bodyBytes);
    input = FileInput(file);
  }

  return ImageInputWrapper(
    input,
    () async {
      if (input is FileInput) {
        input.file.deleteSync();
      }
    },
  );
}
