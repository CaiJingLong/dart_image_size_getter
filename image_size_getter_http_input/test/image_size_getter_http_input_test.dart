import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_http_input/image_size_getter_http_input.dart';
import 'package:test/test.dart';

Future<HttpInput> createSupportRangeLoadHttpInput() async {
  // 2554x824
  final testUrl =
      'https://cdn.jsdelivr.net/gh/CaiJingLong/some_asset@master/flutter_photo2.png';
  return HttpInput.createHttpInput(testUrl);
}

Future<HttpInput> createNoSupportRangeLoadHttpInput() async {
  final testUrl =
      'https://raw.githubusercontent.com/CaiJingLong/some_asset/master/flutter_photo2.png';
  return HttpInput.createHttpInput(testUrl);
}

Future<void> main() async {
  final input = await createSupportRangeLoadHttpInput();

  group('Test http input properties.', () {
    setUp(() async {});

    test('Uri exists.', () async {
      // expect(await url.exists(), isTrue);

      expect(await input.exists(), true);
    });

    test('Support supportRangeLoad.', () async {
      expect(await input.supportRangeLoad(), true);
    });

    test('Get length.', () async {
      expect(await input.length, isNonZero);
    });
  });

  group('Test get size.', () {
    test('Test get size', () async {
      final width = 2554;
      final height = 824;
      final size = await AsyncImageSizeGetter.getSize(input);

      expect(size.width, width);
      expect(size.height, height);
    });
  });

  group('Test HaveResourceImageInput', () {
    test('Test release resource.', () async {
      final width = 2554;
      final height = 824;
      httpCachePath = '/tmp/img';

      final dir = Directory(httpCachePath);

      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final input2 = await createNoSupportRangeLoadHttpInput();

      final delegateInput = await input2.delegateInput();
      final delegateInnerInput = delegateInput.innerInput;

      if (delegateInnerInput is FileInput) {
        expect(delegateInnerInput.file.existsSync(), true);
      }
      final size = ImageSizeGetter.getSize(delegateInput);

      delegateInput.release();

      expect(size.width, width);
      expect(size.height, height);

      if (delegateInnerInput is FileInput) {
        expect(delegateInnerInput.file.existsSync(), false);
      }
    });
  });
}
