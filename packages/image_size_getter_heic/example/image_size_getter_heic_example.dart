import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter_heic/image_size_getter_heic.dart';

void main() {
  final decoder = HeicDecoder();
  ImageSizeGetter.registerDecoder(decoder);

  final input = FileInput(File('example/asset/example.heic'));
  final size = ImageSizeGetter.getSizeResult(input);

  print('heic size: ${size.size} (decoded by ${size.decoder.decoderName})');
}
