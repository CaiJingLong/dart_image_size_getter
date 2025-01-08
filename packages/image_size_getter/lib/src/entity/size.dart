import 'package:hashcodes/hashcodes.dart';

import '../../image_size_getter.dart';

/// {@template image_size_getter.Size.class}
///
/// [Size] is a class for image size.
///
/// The size contains [width] and [height].
///
/// {@endtemplate}
///
/// ---
///
/// {@macro image_size_getter.Size.needToRotate}
class Size {
  /// {@macro image_size_getter.Size.class}
  ///
  /// ---
  ///
  /// {@macro image_size_getter.Size.needToRotate}
  const Size(
    this.width,
    this.height, {
    this.needRotate = false,
  });

  /// The width of the media.
  final int width;

  /// The height of the media.
  final int height;

  /// {@template image_size_getter.Size.needToRotate}
  ///
  /// If the [needRotate] is true,
  /// the [width] and [height] need to be swapped when using.
  ///
  /// Such as, orientation value of the jpeg format is `[5, 6, 7, 8]`.
  ///
  /// {@endtemplate}
  final bool needRotate;

  /// The [width] is zero and [height] is zero.
  static Size zero = Size(0, 0);

  @override
  String toString() {
    return "Size( $width, $height, needRotate: $needRotate )";
  }

  @override
  bool operator ==(Object obj) {
    if (identical(obj, this)) {
      return true;
    }

    if (obj is Size) {
      return width == obj.width &&
          height == obj.height &&
          needRotate == obj.needRotate;
    }

    return false;
  }

  @override
  int get hashCode => hashValues(width, height);
}

/// {@template image_size_getter.SizeResult}
///
/// [SizeResult] is a class for image size result.
///
/// The result contains [size] and [decoder].
///
/// {@endtemplate}
class SizeResult {
  /// {@macro image_size_getter.SizeResult}
  const SizeResult({
    required this.size,
    required this.decoder,
  });

  /// The size of the media.
  ///
  /// See [Size].
  final Size size;

  /// The decoder of the media.
  ///
  /// See [BaseDecoder].
  final BaseDecoder decoder;
}
