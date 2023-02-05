/// Support for doing something awesome.
///
/// More dartdocs go here.
library image_size_getter_bmff;

import 'package:image_size_getter/image_size_getter.dart';
import 'package:bmff/bmff.dart';

export 'src/image_size_getter_bmff_base.dart';

class BmffImageContext extends BmffContext {
  final ImageInput input;

  BmffImageContext(this.input);

  @override
  void close() {}

  @override
  List<int> getRangeData(int start, int end) {
    return input.getRange(start, end);
  }

  @override
  int get length => input.length;
}
