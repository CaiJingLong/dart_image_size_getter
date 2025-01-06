import 'dart:io';

import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';

void main(List<String> arguments) async {
  final file = File('asset/IMG_20180908_080245.jpg');
  final jpgResult = ImageSizeGetter.getSizeResult(FileInput(file));
  print(
      'jpg = ${jpgResult.size} (decoded by ${jpgResult.decoder.decoderName})');

  final pngFile = File('asset/ic_launcher.png');
  final pngResult = ImageSizeGetter.getSizeResult(FileInput(pngFile));
  print(
      'png = ${pngResult.size} (decoded by ${pngResult.decoder.decoderName})');

  final webpFile = File('asset/demo.webp');
  final webpResult = ImageSizeGetter.getSizeResult(FileInput(webpFile));
  print(
      'webp = ${webpResult.size} (decoded by ${webpResult.decoder.decoderName})');

  final gifFile = File('asset/dialog.gif');
  final gifResult = ImageSizeGetter.getSizeResult(FileInput(gifFile));
  print(
      'gif = ${gifResult.size} (decoded by ${gifResult.decoder.decoderName})');

  // errorExample();
}

void errorExample() {
  final input = FileInput(File(
      '/Users/jinglongcai/Desktop/96068243-1d25cb00-0ece-11eb-9f2c-6b958756c769.jpg'));

  final result = ImageSizeGetter.getSizeResult(input);
  print('${result.size} (decoded by ${result.decoder.decoderName})');
}
