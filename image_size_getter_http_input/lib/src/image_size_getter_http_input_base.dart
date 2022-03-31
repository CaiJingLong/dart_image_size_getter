import 'package:image_size_getter/image_size_getter.dart';
import 'stub_impl.dart'
    if (dart.library.html) 'web_delegate.dart'
    if (dart.library.io) 'io_delegate.dart';

import 'package:http/http.dart' as http;

String httpCachePath = '';

class HttpInput extends AsyncImageInput {
  HttpInput._(this.uri, this.headResponse);

  static Future<HttpInput> createHttpInput(String url) async {
    final uri = Uri.parse(url);
    final headResponse = await http.head(uri);
    return HttpInput._(uri, headResponse);
  }

  final Uri uri;

  final http.Response headResponse;

  Map<String, String> get headers => headResponse.headers;

  @override
  Future<HaveResourceImageInput> delegateInput() async {
    final input = await createDelegateInput(uri);
    final delegate = HaveResourceImageInput(
      innerInput: input.input,
      onRelease: () async {
        input.onRelease();
      },
    );
    return delegate;
  }

  @override
  Future<bool> exists() async {
    return headResponse.statusCode == 200;
  }

  @override
  Future<List<int>> getRange(int start, int end) {
    final partRequestHeaders = <String, String>{
      'Range': 'bytes=$start-${end - 1}',
    };

    return http.get(uri, headers: partRequestHeaders).then((response) {
      return response.bodyBytes;
    });
  }

  @override
  Future<int> get length async {
    try {
      return int.parse(headers['content-length'].toString());
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<bool> supportRangeLoad() async {
    return headers['accept-ranges'] == 'bytes';
  }
}

bool get kIsWeb => 0 == 0.0;

class ImageInputWrapper {
  final ImageInput input;

  final void Function() onRelease;

  ImageInputWrapper(this.input, this.onRelease);
}
