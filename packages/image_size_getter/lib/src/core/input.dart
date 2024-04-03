import 'package:image_size_getter/src/image_size_getter.dart';

///
/// {@template image_size_getter.image_input}
///
/// Provide a data source for [ImageSizeGetter] to get image size.
///
/// {@endtemplate}
///
abstract class ImageInput {
  /// {@macro image_size_getter.image_input}
  const ImageInput();

  /// The length of the input data.
  int get length;

  /// Get a range of bytes from the input data.
  ///
  /// [start] and [end] are the start and end index of the range.
  ///
  /// Such as: [start] = 0, [end] = 2, then the result is [0, 1].
  List<int> getRange(int start, int end);

  /// Check if the input data exists.
  bool exists();
}

/// {@macro image_size_getter.HaveResourceImageInput}
///
/// There are resources in these classes that need to be released.
///
/// This class is a wrapper class that will automatically release resources after use.
/// Once released, many resources are no longer effective.
///
/// {@endtemplate}
class HaveResourceImageInput extends ImageInput {
  /// {@macro image_size_getter.HaveResourceImageInput}
  ///
  /// [input] is the input data of [ImageInput].
  /// [onRelease] is the function to release the resources.
  ///
  const HaveResourceImageInput({
    required this.innerInput,
    this.onRelease,
  });

  /// The input data of [ImageInput].
  final ImageInput innerInput;

  /// The function to release the resources.
  final Future<void> Function()? onRelease;

  /// Release the resources.
  Future<void> release() async {
    await onRelease?.call();
  }

  @override
  bool exists() {
    return innerInput.exists();
  }

  @override
  List<int> getRange(int start, int end) {
    return innerInput.getRange(start, end);
  }

  @override
  int get length => innerInput.length;
}

/// {@template image_size_getter.AsyncImageInput}
///
/// {@macro image_size_getter.image_input}
///
/// Unlike [ImageInput], the methods of this class are asynchronous.
///
/// {@endtemplate}
abstract class AsyncImageInput {
  /// {@macro image_size_getter.image_input}
  ///
  /// {@macro image_size_getter.AsyncImageInput}
  const AsyncImageInput();

  /// {@macro image_size_getter.image_input}
  ///
  /// {@macro image_size_getter.AsyncImageInput}
  ///
  /// This method is the [ImageInput] of agent synchronization.
  factory AsyncImageInput.input(ImageInput input) = _SyncInputWrapper;

  /// Whether partial loading is supported.
  ///
  /// Many asynchronous sources do not allow partial reading.
  Future<bool> supportRangeLoad();

  /// When asynchronous reading is not supported,
  /// an input for real reading will be cached in memory(web) or file(dart.io).
  Future<HaveResourceImageInput> delegateInput();

  /// Get a range of bytes from the input data.
  Future<int> get length;

  /// Get a range of bytes from the input data.
  ///
  /// [start] and [end] are the start and end index of the range.
  ///
  /// Such as: [start] = 0, [end] = 2, then the result is [0, 1].
  Future<List<int>> getRange(int start, int end);

  /// Check if the input data exists.
  Future<bool> exists();
}

/// {@macro image_size_getter.SyncImageInput}
///
/// Just wrap [ImageInput] to make it asynchronous.
///
/// {@endtemplate}
class _SyncInputWrapper extends AsyncImageInput {
  /// {@macro image_size_getter.SyncImageInput}
  const _SyncInputWrapper(this._input);

  /// The input data of [ImageInput].
  final ImageInput _input;

  @override
  Future<bool> supportRangeLoad() async {
    return true;
  }

  @override
  Future<bool> exists() async {
    return _input.exists();
  }

  @override
  Future<List<int>> getRange(int start, int end) async {
    return _input.getRange(start, end);
  }

  @override
  Future<int> get length async => _input.length;

  @override
  Future<HaveResourceImageInput> delegateInput() async {
    return HaveResourceImageInput(innerInput: _input);
  }
}
