import 'package:http/http.dart';
import 'package:image_size_getter/image_size_getter.dart';

import 'image_size_getter_http_input_base.dart';

Future<ImageInputWrapper> createDelegateInput(Uri uri) async {
  final response = await get(uri);
  final bodyBytes = response.bodyBytes;
  return ImageInputWrapper(
    MemoryInput(bodyBytes),
    () async {},
  );
}
