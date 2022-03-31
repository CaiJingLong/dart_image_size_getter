import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_http_input/image_size_getter_http_input.dart';
import 'package:test/test.dart';

Future<HttpInput> createSupportRangeLoadHttpInput() async {
  final testUrl = 'https://s2.loli.net/2022/03/31/9PXW7js3YTHFynw.png';
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
      final width = 4128;
      final height = 2564;
      final size = await AsyncImageSizeGetter.getSize(input);

      expect(size.width, width);
      expect(size.height, height);
    });
  });

  group('Test HaveResourceImageInput', () {
    test('Test release resource.', () async {
      final width = 4128;
      final height = 2564;
      httpCachePath = '/tmp';

      final delegateInput = await input.delegateInput();
      final delegateInnerInput = delegateInput.innerInput;

      if (delegateInnerInput is FileInput) {
        print(delegateInnerInput.file.absolute.path);
        expect(delegateInnerInput.file.existsSync(), true);
      }
      final size = ImageSizeGetter.getSize(delegateInput);

      delegateInput.release();

      expect(size.width, width);
      expect(size.height, height);

      if (delegateInnerInput is FileInput) {
        print(delegateInnerInput.file.absolute.path);
        expect(delegateInnerInput.file.existsSync(), false);
      }
    });
  });
}
