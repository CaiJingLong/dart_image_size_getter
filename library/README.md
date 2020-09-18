# image_size_getter

Do not completely decode the image file, just read the metadata to get the image width and height.

Just support jpeg, gif, png, webp.

## Usage

```dart
import 'dart:io';

import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart'; // For compatibility with flutter web.

void main(List<String> arguments) async {
  final file = File('asset/IMG_20180908_080245.jpg');
  final size = ImageSizGetter.getSize(FileInput(file));
  print('jpg = $size');

  final pngFile = File('asset/ic_launcher.png');
  final pngSize = ImageSizGetter.getSize(FileInput(pngFile));
  print('png = $pngSize');

  final webpFile = File('asset/demo.webp');
  final webpSize = ImageSizGetter.getSize(FileInput(webpFile));
  print('webp = $webpSize');

  final gifFile = File('asset/dialog.gif');
  final gifSize = ImageSizGetter.getSize(FileInput(gifFile));
  print('gif = $gifSize');
}

```

MemoryImage

```dart
import 'package:image_size_getter/image_size_getter.dart';

void foo(Uint8List image){
  final memoryImageSize = ImageSizeGetter.getSize(MemoryInput(image));
  print('memoryImageSize = $memoryImageSize');
}
```

## migrate

See [migrate](https://github.com/CaiJingLong/dart_image_size_getter/blob/master/library/migrate.md)

## Other question

The package is dart package, no just flutter package.
So, if you want to get flutter asset image size, you must convert it to memory(Uint8List).

```dart
final buffer = await rootBundle.load('assets/logo.png'); // get the byte buffer
final memoryImageSize = ImageSizeGetter.getSize(MemoryInput.byteBuffer(buffer));
print('memoryImageSize = $memoryImageSize');
```

## LICENSE

Apache 2.0
