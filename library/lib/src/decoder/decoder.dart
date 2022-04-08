import 'package:collection/collection.dart';
import 'package:image_size_getter/image_size_getter.dart';

/// Base of the decoder.
///
/// Implement this class to create a new decoder.
///
abstract class BaseDecoder {
  const BaseDecoder();

  String get decoderName;

  Future<bool> isValidAsync(AsyncImageInput input);

  bool isValid(ImageInput input);

  Future<Size> getSizeAsync(AsyncImageInput input);

  Size getSize(ImageInput input);

  int convertRadix16ToInt(List<int> list, {bool reverse = false}) {
    final sb = StringBuffer();
    if (reverse) {
      list = list.toList().reversed.toList();
    }

    for (final i in list) {
      sb.write(i.toRadixString(16).padLeft(2, '0'));
    }
    final numString = sb.toString();
    return int.tryParse(numString, radix: 16) ?? 0;
  }

  bool compareTwoList(List<int> list1, List<int> list2) {
    final listEquals = ListEquality();
    return listEquals.equals(list1, list2);
  }
}

mixin SimpleTypeValidator on BaseDecoder {

  SimpleFileHeaderAndFooter get simpleFileHeaderAndFooter;

  Future<bool> isValidAsync(AsyncImageInput input) async {
    final length = await input.length;
    final header = await input.getRange(0, simpleFileHeaderAndFooter.startBytes.length);
    final footer = await input.getRange(length - simpleFileHeaderAndFooter.endBytes.length, length);

    final headerEquals = compareTwoList(header, simpleFileHeaderAndFooter.startBytes);
    final footerEquals = compareTwoList(footer, simpleFileHeaderAndFooter.endBytes);
    return headerEquals && footerEquals;
  }

  bool isValid(ImageInput input) {
    final length = input.length;
    final header = input.getRange(0, simpleFileHeaderAndFooter.startBytes.length);
    final footer = input.getRange(length - simpleFileHeaderAndFooter.endBytes.length, length);

    final headerEquals = compareTwoList(header, simpleFileHeaderAndFooter.startBytes);
    final footerEquals = compareTwoList(footer, simpleFileHeaderAndFooter.endBytes);
    return headerEquals && footerEquals;
  }
}

mixin SimpleFileHeaderAndFooter {
  List<int> get startBytes;

  List<int> get endBytes;
}
