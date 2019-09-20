import '../core/size.dart';

abstract class ImageDecoder {
  Future<Size> get size;


  int convertRadix16ToInt(List<int> list) {
    final sb = StringBuffer();
    for (final i in list) {
      sb.write(i.toRadixString(16).padLeft(2, '0'));
    }
    return int.tryParse(sb.toString(), radix: 16);
  }

}
