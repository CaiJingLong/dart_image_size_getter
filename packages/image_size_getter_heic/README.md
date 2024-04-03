# Heic support

heic support for [image_size_getter](https://pub.dev/packages/image_size_getter)

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  image_size_getter_heic: ^1.0.0
```

## Usage

```dart
import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter_heic/image_size_getter_heic.dart';

void main() {
  final decoder = HeicDecoder();
  ImageSizeGetter.registerDecoder(decoder);

  final input = FileInput(File('example/asset/example.heic'));
  final size = ImageSizeGetter.getSize(input);

  print(size);
}

```

## License

[APACHE LICENSE, VERSION 2.0](LICENSE)
