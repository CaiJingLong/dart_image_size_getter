import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
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
  final imgUrl = 'http://localhost:7777/assets/flutter_photo2.png';
  return HttpInput.createHttpInput(imgUrl);
}

Future<void> main() async {
  final input = await createSupportRangeLoadHttpInput();

  group('Test http input properties:', () {
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

  group('Test support range load image size:', () {
    test('Test get size', () async {
      final width = 2554;
      final height = 824;
      final size = await ImageSizeGetter.getSizeAsync(input);

      expect(size.width, width);
      expect(size.height, height);
    });
  });

  group('Test no support range load resource:', () {
    test('Start image server', () async {
      await startTestServer(
        callAfterStart: testFetch,
        supportRangeLoad: true,
      );
    });

    test('Test release resource.', () async {
      await startTestServer(
          supportRangeLoad: false,
          callAfterStart: () async {
            final width = 2554;
            final height = 824;

            final time = DateTime.now().microsecondsSinceEpoch;

            httpCachePath = <String>[Directory.systemTemp.path, 'img', '$time']
                .join(Platform.pathSeparator);

            final dir = Directory(httpCachePath);

            if (!dir.existsSync()) {
              dir.createSync(recursive: true);
            }

            final input2 = await createNoSupportRangeLoadHttpInput();

            final delegateInput = await input2.delegateInput();
            final delegateInnerInput = delegateInput.innerInput;

            if (delegateInnerInput is FileInput) {
              assert(delegateInnerInput.file.existsSync() == true,
                  'File not exists.');
            }
            final size = ImageSizeGetter.getSize(delegateInput);

            await delegateInput.release();

            expect(size.width, width);
            expect(size.height, height);

            if (delegateInnerInput is FileInput) {
              final tempFile = delegateInnerInput.file;
              try {
                assert(tempFile.existsSync() == false, 'File not exists.');
              } catch (e, st) {
                print('tempFile.existsSync(): ${tempFile.existsSync()}');
                print(
                    '${tempFile.path} is exists, length: ${tempFile.lengthSync()}');
                print(e);
                print(st);
                rethrow;
              }
            }
          });
    });
  });
}

Future<void> startTestServer({
  int waitSeconds = 3,
  required void Function() callAfterStart,
  required bool supportRangeLoad,
}) async {
  var path = 'assets/flutter_photo2.png';
  final fileSrc = File(path);

  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    7777,
    shared: true,
  );

  server.listen((request) {
    final response = request.response;
    if (request.method == "GET" || request.method == "HEAD") {
      final uri = request.uri;
      if (!uri.toString().startsWith('/$path')) {
        response.statusCode = 404;
        response.close();
        return;
      }

      response.headers.contentType = ContentType.binary;
      response.headers.contentLength = fileSrc.lengthSync();
      response.headers.set('Access-Control-Allow-Origin', '*');
      response.headers.set('Access-Control-Allow-Methods', 'GET, HEAD');

      if (supportRangeLoad) {
        response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      }

      if (request.method == "GET") {
        if (supportRangeLoad) {
          final ranges = request.headers['range'];
          if (ranges != null && ranges.isNotEmpty) {
            final range = ranges[0];
            final start = range.split('=')[1].split('-')[0];
            final end = range.split('=')[1].split('-')[1];

            response.statusCode = HttpStatus.partialContent;
            response.headers.set(HttpHeaders.contentRangeHeader,
                'bytes $start-$end/${fileSrc.lengthSync()}');

            final reader = fileSrc.openSync();
            reader.setPositionSync(int.parse(start));
            final length = int.parse(end) - int.parse(start) + 1;
            final buffer = Uint8List(length);
            reader.readIntoSync(buffer, 0, length);
            response.add(buffer);
            reader.close();
          } else {
            response.add(fileSrc.readAsBytesSync());
          }
        } else {
          response.add(fileSrc.readAsBytesSync());
        }
      }

      response.close();
    } else {
      response.statusCode = 403;
      response.close();
    }
  });

  // request http
  print('Server is running at http://${InternetAddress.loopbackIPv4}:7777');
  print('Press Ctrl-C to stop server or wait $waitSeconds seconds to stop.');
  callAfterStart();
  await Future.delayed(Duration(seconds: waitSeconds));
  server.close();
}

Future<void> testFetch() async {
  final url = 'http://localhost:7777/assets/flutter_photo2.png';
  final url2 = 'http://localhost:7777/assets/flutter_photo4.png';

  testServer(url, 200);
  testServer(url2, 404);
}

Future<void> testServer(String url, int statusCode) async {
  final resp = await http.get(Uri.parse(url));
  expect(resp.statusCode, statusCode);
}
