import 'package:collection/collection.dart';
import 'package:image_size_getter/image_size_getter.dart';

/// {@template image_size_getter.BaseDecoder}
///
/// Base of the decoder.
///
/// Implement this class to create a new decoder.
///
/// {@endtemplate}
abstract class BaseDecoder {
  /// {@macro image_size_getter.BaseDecoder}
  const BaseDecoder();

  /// The name of the decoder.
  String get decoderName;

  /// {@template image_size_getter.BaseDecoder.isValid}
  ///
  /// Returns the [input] is support or not.
  ///
  /// {@endtemplate}
  bool isValid(ImageInput input);

  /// {@macro image_size_getter.BaseDecoder.isValid}
  Future<bool> isValidAsync(AsyncImageInput input);

  /// {@template image_size_getter.BaseDecoder.getSize}
  ///
  /// Returns the size of the [input].
  ///
  /// {@endtemplate}
  Size getSize(ImageInput input);

  /// {@macro image_size_getter.BaseDecoder.getSize}
  Future<Size> getSizeAsync(AsyncImageInput input);

  /// Convert hex a decimal list to int type.
  ///
  /// If the number is stored in big endian, pass [reverse] as false.
  ///
  /// If the number is stored in little endian, pass [reverse] as true.
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

  /// compare two list.
  bool compareTwoList(List<int> list1, List<int> list2) {
    final listEquals = ListEquality();
    return listEquals.equals(list1, list2);
  }
}

/// {@template image_size_getter.SimpleTypeValidator}
///
/// Simple type validator.
///
/// {@endtemplate}
mixin SimpleTypeValidator on BaseDecoder {
  /// {@macro image_size_getter.SimpleFileHeaderAndFooter}
  SimpleFileHeaderAndFooter get simpleFileHeaderAndFooter;

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final length = await input.length;
    final header = await input.getRange(
      0,
      simpleFileHeaderAndFooter.startBytes.length,
    );
    final footer = await input.getRange(
      length - simpleFileHeaderAndFooter.endBytes.length,
      length,
    );

    final headerEquals = compareTwoList(
      header,
      simpleFileHeaderAndFooter.startBytes,
    );
    final footerEquals = compareTwoList(
      footer,
      simpleFileHeaderAndFooter.endBytes,
    );
    return headerEquals && footerEquals;
  }

  @override
  bool isValid(ImageInput input) {
    final length = input.length;
    final header = input.getRange(
      0,
      simpleFileHeaderAndFooter.startBytes.length,
    );
    final footer = input.getRange(
      length - simpleFileHeaderAndFooter.endBytes.length,
      length,
    );

    final headerEquals = compareTwoList(
      header,
      simpleFileHeaderAndFooter.startBytes,
    );
    final footerEquals = compareTwoList(
      footer,
      simpleFileHeaderAndFooter.endBytes,
    );
    return headerEquals && footerEquals;
  }
}

/// {@template image_size_getter.SimpleFileHeaderAndFooter}
///
/// Provides the header and footer of the file.
///
/// {@endtemplate}
mixin SimpleFileHeaderAndFooter {
  /// The start bytes of the file.
  List<int> get startBytes;

  /// The end bytes of the file.
  List<int> get endBytes;
}

/// The content have multiple headers or footers.
mixin MutilFileHeaderAndFooter {
  /// When there are multiple start bytes, this is the list of possible start bytes of the file.
  List<List<int>> get mutipleStartBytesList;

  /// When there are multiple end bytes, this is the list of possible end bytes of the file.
  List<List<int>> get mutipleEndBytesList;
}

/// Validate the content.
mixin MutilFileHeaderAndFooterValidator on BaseDecoder {
  /// {@macro image_size_getter.SimpleFileHeaderAndFooter}
  MutilFileHeaderAndFooter get headerAndFooter;

  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final length = await input.length;

    for (final header in headerAndFooter.mutipleStartBytesList) {
      for (final footer in headerAndFooter.mutipleEndBytesList) {
        final fileHeader = await input.getRange(
          0,
          header.length,
        );
        final fileFooter = await input.getRange(
          length - footer.length,
          length,
        );

        final headerEquals = compareTwoList(
          header,
          fileHeader,
        );
        final footerEquals = compareTwoList(
          footer,
          fileFooter,
        );
        if (headerEquals && footerEquals) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  bool isValid(ImageInput input) {
    final length = input.length;

    for (final header in headerAndFooter.mutipleStartBytesList) {
      for (final footer in headerAndFooter.mutipleEndBytesList) {
        final fileHeader = input.getRange(
          0,
          header.length,
        );
        final fileFooter = input.getRange(
          length - footer.length,
          length,
        );

        final headerEquals = compareTwoList(
          header,
          fileHeader,
        );
        final footerEquals = compareTwoList(
          footer,
          fileFooter,
        );
        if (headerEquals && footerEquals) {
          return true;
        }
      }
    }

    return false;
  }
}
