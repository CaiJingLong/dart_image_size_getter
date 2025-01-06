# image_size_getter

[![pub package](https://img.shields.io/pub/v/image_size_getter.svg)](https://pub.dev/packages/image_size_getter)
[![likes](https://img.shields.io/pub/likes/image_size_getter)](https://pub.dev/packages/image_size_getter/score)
[![popularity](https://img.shields.io/pub/popularity/image_size_getter)](https://pub.dev/packages/image_size_getter/score)
[![pub points](https://img.shields.io/pub/points/image_size_getter)](https://pub.dev/packages/image_size_getter/score)

[![GitHub stars](https://img.shields.io/github/stars/CaiJingLong/dart_image_size_getter.svg)](https://github.com/CaiJingLong/dart_image_size_getter)
[![GitHub forks](https://img.shields.io/github/forks/CaiJingLong/dart_image_size_getter.svg)](https://github.com/CaiJingLong/dart_image_size_getter)
[![GitHub license](https://img.shields.io/github/license/CaiJingLong/dart_image_size_getter.svg)](https://github.com/CaiJingLong/dart_image_size_getter/blob/master/LICENSE)

Do not completely decode the image file, just read the metadata to get the image width and height.

Just support jpeg, gif, png, webp, bmp.

## Install

```yaml
dependencies:
  image_size_getter: ^2.3.0
```

## Usage

### Image of File

```dart
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

```

### Image of Memory

```dart
import 'package:image_size_getter/image_size_getter.dart';

void foo(Uint8List image){
  final memoryImageSizeResult = ImageSizeGetter.getSizeResult(MemoryInput(image));
  final size = memoryImageSizeResult.size;
  final decoder = memoryImageSizeResult.decoder;
  print('size = $size, decoder = ${decoder.decoderName}');
}
```

### Image of Http

See [HttpInput][].

## About Size

The size contains width and height.

But some image have orientation.
Such as jpeg, when the orientation of exif is 5, 6, 7 or 8, the width and height will be swapped.

We can use next code to get width and height.

```dart
void foo(File file) {
  final sizeResult = ImageSizeGetter.getSizeResult(FileInput(file));
  final size = sizeResult.size;
  if (size.needRotate) {
    final width = size.height;
    final height = size.width;
    print('width = $width, height = $height');
  } else {
    print('width = ${size.width}, height = ${size.height}');
  }
  print('decoder = ${sizeResult.decoder.decoderName}');
}
```

## AsyncImageInput

If your data source is read asynchronously, consider using `AsyncImageInput`.

A typical use case is [http_input][HttpInput].

## Custom

We can implement our own input or decoder.

In addition to several built-in implementations, subsequent implementations will also be added to the project through plugin.

### Custom Input

Such as: [http_input](https://github.com/CaiJingLong/dart_image_size_getter/tree/master/image_size_getter_http_input).

In addition, if your picture has verification, for example, you need to use the request header to access it, or you need a post request to get it, you need to customize input.

### Custom Decoder

Such as bmp decoder

Check the file type:

![VPMMfA](https://cdn.jsdelivr.net/gh/kikt-blog/image@branch-2/uPic/VPMMfA.png)

The width and height:

![AZnx9I](https://cdn.jsdelivr.net/gh/kikt-blog/image@branch-2/uPic/AZnx9I.png)

So, we can write code with:

```dart
import 'package:image_size_getter/image_size_getter.dart';

class BmpDecoder extends BaseDecoder {
  const BmpDecoder();

  @override
  String get decoderName => 'bmp';

  @override
  Size getSize(ImageInput input) {
    final widthList = input.getRange(0x12, 0x16);
    final heightList = input.getRange(0x16, 0x1a);

    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    final widthList = await input.getRange(0x12, 0x16);
    final heightList = await input.getRange(0x16, 0x1a);

    final width = convertRadix16ToInt(widthList, reverse: true);
    final height = convertRadix16ToInt(heightList, reverse: true);
    return Size(width, height);
  }

  @override
  bool isValid(ImageInput input) {
    final list = input.getRange(0, 2);
    return _isBmp(list);
  }

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final list = await input.getRange(0, 2);
    return _isBmp(list);
  }

  bool _isBmp(List<int> startList) {
    return startList[0] == 66 && startList[1] == 77;
  }
}

```

Use it:

```dart
final bmp = File('../../example/asset/demo.bmp');

const BmpDecoder decoder = BmpDecoder();
final input = FileInput(bmp);

assert(decoder.isValid(input));
expect(decoder.getSizeResult(input).size, Size(256, 256));
```

#### Register custom decoder to image size getter

```dart
ImageSizeGetter.registerDecoder(const BmpDecoder());
```

The method can also be used to replace the default decoder.

For example, you think the existing JPEG format is not rigorous enough.

```dart
ImageSizeGetter.registerDecoder(const MyJpegDecoder());
```

#### Use decoder alone

Each decoder can be used alone.

```dart
void decodeWithImageInput(ImageInput input) {
  BaseDecoder decoder = const GifDecoder();
  final isGif = decoder.isValid(input);
  print('isGif: $isGif');

  if (isGif) {
    final sizeResult = decoder.getSizeResult(input);
    final size = sizeResult.size;
    print('size: $size');
  }
}

void decodeWithAsyncImageInput(AsyncImageInput input) async {
  BaseDecoder decoder = const PngDecoder();
  final isPng = await decoder.isValidAsync(input);
  print('isPng: $isPng');

  if (isPng) {
    final sizeResult = await decoder.getSizeResultAsync(input);
    final size = sizeResult.size;
    print('size: $size');
  }
}
```

## migrate

See [migrate](https://github.com/CaiJingLong/dart_image_size_getter/blob/master/library/migrate.md)

## Other question

The package is dart package, no just flutter package.
So, if you want to get flutter asset image size, you must convert it to memory(Uint8List).

```dart
final buffer = await rootBundle.load('assets/logo.png'); // get the byte buffer
final memoryImageSizeResult = ImageSizeGetter.getSizeResult(MemoryInput.byteBuffer(buffer));
final size = memoryImageSizeResult.size;
print('size = $size');
```

## LICENSE

Apache 2.0

[HttpInput]: https://pub.dev/packages/image_size_getter_http_input
