import 'dart:typed_data';

import 'package:image_size_getter/src/core/input.dart';

class MemoryInput extends ImageInput {
  final Uint8List bytes;
  const MemoryInput(this.bytes);

  factory MemoryInput.byteBuffer(ByteBuffer buffer) {
    return MemoryInput(buffer.asUint8List());
  }

  @override
  List<int> getRange(int start, int end) {
    return bytes.sublist(start, end);
  }

  @override
  int get length => bytes.length;

  @override
  bool exists() {
    return bytes != null && bytes.isNotEmpty;
  }
}
