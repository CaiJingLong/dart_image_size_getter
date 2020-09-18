import 'package:image_size_getter/src/utils/hashcodes.dart';

class Size {
  int width;
  int height;

  static Size zero = Size(0, 0);

  Size(this.width, this.height);

  @override
  String toString() {
    return "Size( $width, $height )";
  }

  bool operator ==(obj) {
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
