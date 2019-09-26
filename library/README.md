# image_size_getter

Do not completely decode the image file, just read the metadata to get the image width and height.

Just support jpeg, git, png, webp.

## Usage

```dart
import 'dart:io';

import 'package:image_size_getter/image_size_getter.dart';

main(List<String> arguments) async {
  File file = File("asset/IMG_20180908_080245.jpg");
  final size = ImageSizGetter.getSize(file);
  print("jpg = $size");

  File pngFile = File("asset/ic_launcher.png");
  final pngSize = ImageSizGetter.getSize(pngFile);
  print("png = $pngSize");

  File webpFile = File("asset/demo.webp");
  final webpSize = ImageSizGetter.getSize(webpFile);
  print("webp = $webpSize");

  File gifFile = File("asset/dialog.gif");
  final gifSize = ImageSizGetter.getSize(gifFile);
  print("gif = $gifSize");
}

```
