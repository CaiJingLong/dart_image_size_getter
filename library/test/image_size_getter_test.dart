import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:test/test.dart';

void main() {
  test('Test webp size', () async {
    final file = File('../example/asset/demo.webp');
    final size = ImageSizeGetter.getSize(FileInput(file));
    print('size = $size');
    await expectLater(size, Size(988, 466));
  });

  test('Test jpeg size', () async {
    final file = File('../example/asset/IMG_20180908_080245.jpg');
    final size = ImageSizeGetter.getSize(FileInput(file));
    print('size = $size');
    await expectLater(size, Size(4032, 3024));
  });

  test('Test gif size', () async {
    final file = File('../example/asset/dialog.gif');
    final size = ImageSizeGetter.getSize(FileInput(file));
    print('size = $size');
    await expectLater(size, Size(688, 1326));
  });

  test('Test png size', () async {
    final file = File('../example/asset/ic_launcher.png');
    final size = ImageSizeGetter.getSize(FileInput(file));
    print('size = $size');
    await expectLater(size, Size(96, 96));
  });

  test('Test png size with memory', () async {
    final file = File('../example/asset/ic_launcher.png');
    final bytes = file.readAsBytesSync();
    final size = ImageSizeGetter.getSize(MemoryInput(bytes));
    print('size = $size');
    await expectLater(size, Size(96, 96));
  });
}
