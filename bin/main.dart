import 'dart:io';

import 'package:image_size_getter/src/utils/format_utils.dart';

main(List<String> arguments) async {
  File file = File("/Users/caijinglong/Pictures/拍照/18-9-8/IMG_20180908_071849.jpg");
  final size = await FormatUtils.getSize(file);
  print(size);
}
