import 'dart:io';

import 'package:image_size_getter/image_size_getter.dart';

void main(List<String> arguments) async {
  final file = File('asset/IMG_20180908_080245.jpg');
  final size = ImageSizGetter.getSize(file);
  print('jpg = $size');

  final pngFile = File('asset/ic_launcher.png');
  final pngSize = ImageSizGetter.getSize(pngFile);
  print('png = $pngSize');

  final webpFile = File('asset/demo.webp');
  final webpSize = ImageSizGetter.getSize(webpFile);
  print('webp = $webpSize');

  final gifFile = File('asset/dialog.gif');
  final gifSize = ImageSizGetter.getSize(gifFile);
  print('gif = $gifSize');
}
