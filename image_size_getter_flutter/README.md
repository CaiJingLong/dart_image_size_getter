# image_size_getter_flutter

A plugin for [image_size_getter](https://pub.dev/packages/image_size_getter).

To support flutter.

## Example

### FlutterAssetImageInput

```dart
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_flutter/image_size_getter_flutter.dart';

Future<Size> getAsset(String assetKey) async {
  final input = FlutterAssetImageInput(assetKey);
  final size = await ImageSizeGetter.getSizeAsync(input);
  print('size: $size');
  return size;
}
```
