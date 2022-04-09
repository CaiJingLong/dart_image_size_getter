# http_input

HttpInput for [image_size_getter](https://pub.dev/packages/image_size_getter)

## Example

Tips:

1. normally, you should use the api provided by your application server or image server to get the image size instead of using this method.

1. If you don't have an application server or if the server can't provide the information, then there is another suggestion.
   - The server support range header and provide content-length header.
   - Image files larger than 5m or even 10m, as range fetching may require 5 ~ 20 interactions with the server to get the image size.

Example:

```dart
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_http_input/image_size_getter_http_input.dart';

Future<void> foo() async{
  final testUrl =
      'https://cdn.jsdelivr.net/gh/CaiJingLong/some_asset@master/flutter_photo2.png';
  final httpInput = await HttpInput.createHttpInput(testUrl);

  final size = await ImageSizeGetter.getSizeAsync(httpInput);
  print('size: $size');
}

```

### issues

If you are using a non-web environment, then when you request a server that does not support range load, if you are worried about using too much memory, then you can use file as a cache, use `httpCachePath` to set it, or if not, it will use the memory cache. The cache file will be deleted automatically when the fetch size is done.

## LICENSE

Apache License 2.0
