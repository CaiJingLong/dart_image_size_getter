import 'package:image_size_getter/image_size_getter.dart';
import 'stub_impl.dart'
    if (dart.library.html) 'web_delegate.dart'
    if (dart.library.io) 'io_delegate.dart';

import 'package:http/http.dart' as http;

/// The path where HTTP responses will be cached.
/// This can be set to customize the cache location.
String httpCachePath = '';

/// An implementation of [AsyncImageInput] that reads image data from HTTP URLs.
///
/// This class provides functionality to fetch and read image data from remote
/// URLs using HTTP requests. It supports both web and IO platforms through
/// conditional imports.
class HttpInput extends AsyncImageInput {
  /// Creates a new [HttpInput] instance.
  ///
  /// This constructor is private. Use [createHttpInput] to create instances.
  HttpInput._(this.uri, this.headResponse);

  /// Creates a new [HttpInput] instance for the given URL.
  ///
  /// This factory method performs a HEAD request to the URL to get initial
  /// metadata about the resource.
  ///
  /// [url] is the URL of the image to fetch.
  ///
  /// Returns a Future that completes with a new [HttpInput] instance.
  /// Throws [FormatException] if the URL is invalid.
  static Future<HttpInput> createHttpInput(String url) async {
    final uri = Uri.parse(url);
    final headResponse = await http.head(uri);
    return HttpInput._(uri, headResponse);
  }

  /// The URI of the image resource.
  final Uri uri;

  /// The response from the HEAD request to the image URL.
  final http.Response headResponse;

  /// Gets the HTTP headers from the HEAD response.
  ///
  /// Returns a map of HTTP headers.
  Map<String, String> get headers => headResponse.headers;

  /// Delegates the input to a [HaveResourceImageInput] instance.
  ///
  /// This method creates a new [HaveResourceImageInput] instance and returns it.
  @override
  Future<HaveResourceImageInput> delegateInput() async {
    final input = await createDelegateInput(uri);
    final delegate = HaveResourceImageInput(
      innerInput: input.input,
      onRelease: () async {
        await input.onRelease();
      },
    );
    return delegate;
  }

  /// Checks if the HTTP resource exists and is accessible.
  ///
  /// Returns true if the HEAD request was successful (status code 200).
  @override
  Future<bool> exists() async {
    return headResponse.statusCode == 200;
  }

  /// Gets a range of bytes from the image data.
  ///
  /// This method will fetch the specified range of bytes from the remote
  /// resource using a range request.
  ///
  /// [start] is the starting byte position.
  /// [end] is the ending byte position.
  ///
  /// Returns a Future that completes with the requested bytes.
  @override
  Future<List<int>> getRange(int start, int end) {
    final partRequestHeaders = <String, String>{
      'Range': 'bytes=$start-${end - 1}',
    };

    return http.get(uri, headers: partRequestHeaders).then((response) {
      return response.bodyBytes;
    });
  }

  /// Gets the total length of the image data.
  ///
  /// This value is obtained from the Content-Length header of the HEAD response.
  @override
  Future<int> get length async {
    try {
      return int.parse(headers['content-length'].toString());
    } catch (e) {
      return 0;
    }
  }

  /// Checks if the HTTP resource supports range requests.
  ///
  /// Returns true if the Accept-Ranges header is 'bytes'.
  @override
  Future<bool> supportRangeLoad() async {
    return headers['accept-ranges'] == 'bytes';
  }
}

/// Determines if the current platform is web.
///
/// This is used internally to choose the appropriate implementation
/// for HTTP requests.
bool get kIsWeb => 0 == 0.0;

/// A wrapper class that implements [ImageInput] using an [ImageInput].
///
/// This class is used internally to adapt async image inputs for synchronous
/// operations when necessary.
class ImageInputWrapper {
  /// The wrapped [ImageInput] instance.
  final ImageInput input;

  /// A callback to release resources when the wrapper is no longer needed.
  final Future<void> Function() onRelease;

  /// Creates a new [ImageInputWrapper] instance.
  ///
  /// [input] is the [AsyncImageInput] instance to wrap.
  /// [onRelease] is the callback to release resources.
  ImageInputWrapper(this.input, this.onRelease);
}
