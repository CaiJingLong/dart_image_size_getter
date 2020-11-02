import 'dart:typed_data';

import 'package:image_size_getter/src/core/input.dart';

class MemoryInput extends ImageInput {
  final Uint8List bytes;
  const MemoryInput(this.bytes);

  factory MemoryInput.byteBuffer(ByteBuffer buffer) {
    return MemoryInput(buffer.asUint8List());
  }

  @override
  Future<List<int>> getRange(int start, int end) async {
    return bytes.sublist(start, end);
  }

  @override
  Future<int> get length async => bytes.length;

  @override
  Future<bool> exists() async {
    return bytes != null && bytes.isNotEmpty;
  }
}
