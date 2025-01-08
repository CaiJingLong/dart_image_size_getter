import 'dart:typed_data';

import 'package:image_size_getter_heic/image_size_getter_heic.dart';
import 'package:bmff/bmff.dart';

import 'context.dart';
import 'types.dart';

/// {@template image_size_getter_heic.HeicDecoder}
/// A decoder for HEIC (High Efficiency Image Format) images.
///
/// This decoder implements the [BaseDecoder] to extract size information from HEIC
/// image files by parsing their BMFF (ISO Base Media File Format) structure.
///
/// Example:
/// ```dart
/// final decoder = HeicDecoder();
/// final size = decoder.getSize(input);
/// print('Width: ${size.width}, Height: ${size.height}');
/// ```
/// {@endtemplate}
class HeicDecoder extends BaseDecoder {
  /// Creates a new [HeicDecoder] instance.
  ///
  /// [fullTypeBox] is an optional list of box types that should be treated as full boxes
  /// when parsing the BMFF structure. If not provided, [defaultFullBoxTypes] will be used.
  HeicDecoder({this.fullTypeBox = defaultFullBoxTypes});

  /// List of box types that should be treated as full boxes when parsing the BMFF structure.
  final List<String> fullTypeBox;

  /// The name identifier for this decoder.
  ///
  /// Always returns 'heic'.
  @override
  String get decoderName => 'heic';

  /// Extracts the size information from a HEIC image synchronously.
  ///
  /// This method parses the BMFF structure of the HEIC file to find the 'ispe' box
  /// which contains the image size information.
  ///
  /// Returns a [Size] object containing the width and height of the image.
  ///
  /// Throws a [FormatException] if the input is not a valid HEIC image.
  @override
  Size getSize(ImageInput input) {
    final bmff = BmffImageContext(input, fullBoxTypes: fullTypeBox).bmff;
    final buffer = bmff['meta']['iprp']['ipco']['ispe'].getByteBuffer();

    final width = buffer.getUint32(0, Endian.big);
    final height = buffer.getUint32(1, Endian.big);

    return Size(width, height);
  }

  /// Extracts the size information from a HEIC image asynchronously.
  ///
  /// This method creates an async BMFF context and parses the structure to find
  /// the 'ispe' box which contains the image size information.
  ///
  /// Returns a Future that completes with a [Size] object containing the width
  /// and height of the image.
  ///
  /// Throws a [FormatException] if the input is not a valid HEIC image.
  @override
  Future<Size> getSizeAsync(AsyncImageInput input) async {
    final context = AsyncBmffContext.common(
      () {
        return input.length;
      },
      (start, end) => input.getRange(start, end),
      fullBoxTypes: fullTypeBox,
    );

    final bmff = await Bmff.asyncContext(context);
    final ispe = bmff['meta']['iprp']['ipco']['ispe'];

    final buffer = await ispe.getByteBuffer();

    final width = buffer.getUint32(0, Endian.big);
    final height = buffer.getUint32(1, Endian.big);

    return Size(width, height);
  }

  /// Checks if the input is a valid HEIC image synchronously.
  ///
  /// Returns `true` if the input is a valid HEIC image, `false` otherwise.
  @override
  bool isValid(ImageInput input) {
    final bmff = BmffImageContext(input, fullBoxTypes: fullTypeBox).bmff;
    return _checkHeic(bmff);
  }

  /// Checks if the input is a valid HEIC image asynchronously.
  ///
  /// Returns a Future that completes with `true` if the input is a valid HEIC image,
  /// `false` otherwise.
  @override
  Future<bool> isValidAsync(AsyncImageInput input) async {
    final lengthBytes = await input.getRange(0, 4);
    final length = lengthBytes.toBigEndian();
    final typeBoxBytes = await input.getRange(0, length);

    final bmff = Bmff.memory(typeBoxBytes);
    return _checkHeic(bmff);
  }

  /// Checks if the BMFF structure is a valid HEIC image.
  ///
  /// Returns `true` if the BMFF structure is a valid HEIC image, `false` otherwise.
  bool _checkHeic(Bmff bmff) {
    final typeBox = bmff.typeBox;
    final compatibleBrands = typeBox.compatibleBrands;
    return compatibleBrands.contains('heic');
  }
}
