import 'dart:io';

import 'package:image_size_getter/src/utils/format_utils.dart';

main(List<String> arguments) async {
  File file = File("asset/IMG_20180908_080245.jpg");
  final size = await FormatUtils.getSize(file);
  print("jpg = $size");

  File pngFile = File("asset/ic_launcher.png");
  final pngSize = await FormatUtils.getSize(pngFile);
  print("png = $pngSize");
}
