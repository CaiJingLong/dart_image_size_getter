import 'package:hashcodes/hashcodes.dart';

/// {@template image_size_getter.Size}
///
/// [Size] is a class for image size.
///
/// The size contains [width] and [height].
///
/// {@endtemplate}
class Size {
  const Size(this.width, this.height);

  /// The width of the media.
  final int width;

  /// The height of the media.
  final int height;

  /// The [width] is zero and [height] is zero.
  static Size zero = Size(0, 0);

  @override
  String toString() {
    return "Size( $width, $height )";
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
      return width == obj.width && height == obj.height;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(width, height);
}
