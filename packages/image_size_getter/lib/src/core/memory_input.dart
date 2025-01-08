import 'dart:typed_data';

import 'package:image_size_getter/src/core/input.dart';

/// {@template image_size_getter.memory_input}
/// A memory-based implementation of [ImageInput] that reads image data from bytes in memory.
///
/// This class provides functionality to read image data from a [Uint8List] or [ByteBuffer]
/// stored in memory, making it useful for processing images that are already loaded into
/// memory or received from network requests.
/// {@endtemplate}
class MemoryInput extends ImageInput {
  /// The underlying bytes containing the image data.
  final Uint8List bytes;

  /// {@macro image_size_getter.image_input}
  const MemoryInput(this.bytes);

  /// Creates a [MemoryInput] instance from a [ByteBuffer].
  ///
  /// This factory constructor converts the provided [buffer] into a [Uint8List]
  /// and creates a new [MemoryInput] instance.
  ///
  /// [buffer] is the [ByteBuffer] containing the image data.
  factory MemoryInput.byteBuffer(ByteBuffer buffer) {
    return MemoryInput(buffer.asUint8List());
  }

  /// Get a range of bytes from the input data.
  ///
  /// [start] and [end] are the start and end index of the range.
  ///
  /// Such as: [start] = 0, [end] = 2, then the result is `[0, 1]`.
  @override
  List<int> getRange(int start, int end) {
    return bytes.sublist(start, end);
  }

  /// The length of the input data.
  @override
  int get length => bytes.length;

  /// Check if the input data exists.
  @override
  bool exists() {
    return bytes.isNotEmpty;
  }
}
