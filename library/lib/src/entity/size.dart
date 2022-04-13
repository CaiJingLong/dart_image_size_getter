import 'package:hashcodes/hashcodes.dart';

/// {@template image_size_getter.Size}
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
  /// {@macro image_size_getter.Size}
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
  /// Such as, orientation value of the jpeg format is [5, 6, 7, 8].
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
  bool operator ==(Object? obj) {
    if (identical(obj, this)) {
      return true;
    }

    if (obj == null) {
      return false;
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
