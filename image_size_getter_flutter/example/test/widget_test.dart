import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_size_getter/image_size_getter.dart';

import 'package:image_size_getter_flutter/image_size_getter_flutter.dart';

void main() {
  const assetKey = 'asset/test.png';
  testWidgets('Test flutter image size getter', (tester) async {
    final input = FlutterAssetImageInput(assetKey);
    final size = await ImageSizeGetter.getSizeAsync(input);
    debugPrint('size: $size');
    expect(size, const Size(256, 256));
  });
}
