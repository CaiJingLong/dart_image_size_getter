import 'dart:io';

import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';

void main(List<String> arguments) async {
  final file = File('asset/IMG_20180908_080245.jpg');
  final size = await ImageSizeGetter.getSize(FileInput(file));
  print('jpg = $size');

  final pngFile = File('asset/ic_launcher.png');
  final pngSize = await ImageSizeGetter.getSize(FileInput(pngFile));
  print('png = $pngSize');

  final webpFile = File('asset/demo.webp');
  final webpSize = await ImageSizeGetter.getSize(FileInput(webpFile));
  print('webp = $webpSize');

  final gifFile = File('asset/dialog.gif');
  final gifSize = await ImageSizeGetter.getSize(FileInput(gifFile));
  print('gif = $gifSize');

  // errorExample();
}

void errorExample() {
  final input = FileInput(File(
      '/Users/jinglongcai/Desktop/96068243-1d25cb00-0ece-11eb-9f2c-6b958756c769.jpg'));

  final size = ImageSizeGetter.getSize(input);
  print(size);
}
