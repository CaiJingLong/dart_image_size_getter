import 'package:bmff/bmff.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_heic/src/types.dart';

/// A context implementation for BMFF (ISO Base Media File Format) parsing
/// that works with [ImageInput].
///
/// This class provides the necessary context for parsing HEIC images by
/// implementing the [BmffContext] interface and using an [ImageInput]
/// as the data source.
class BmffImageContext extends BmffContext {
  /// The input source containing the image data.
  final ImageInput input;

  /// Creates a new [BmffImageContext] instance.
  ///
  /// [input] is the source containing the image data.
  /// [fullBoxTypes] is an optional list of box types that should be treated
  /// as full boxes when parsing. Defaults to [defaultFullBoxTypes].
  BmffImageContext(
    this.input, {
    List<String> fullBoxTypes = defaultFullBoxTypes,
  }) : super(fullBoxTypes: fullBoxTypes);

  /// No-op implementation as [ImageInput] doesn't require explicit closing.
  @override
  void close() {}

  /// Gets a range of bytes from the input data.
  ///
  /// [start] is the starting index (inclusive).
  /// [end] is the ending index (exclusive).
  ///
  /// Returns a list of integers representing the bytes in the specified range.
  @override
  List<int> getRangeData(int start, int end) {
    return input.getRange(start, end);
  }

  /// Gets the total length of the input data.
  @override
  int get length => input.length;
}
