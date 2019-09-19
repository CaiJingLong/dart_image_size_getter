class Size {
  int width;
  int height;

  static Size zero = Size(0, 0);

  Size(this.width, this.height);

  @override
  String toString() {
    return "Size( $width, $height )";
  }
}
