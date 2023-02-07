import 'package:bmff/bmff.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_heic/src/types.dart';

class BmffImageContext extends BmffContext {
  final ImageInput input;

  BmffImageContext(
    this.input, {
    List<String> fullBoxTypes = defaultFullBoxTypes,
  }) : super(fullBoxTypes: fullBoxTypes);

  @override
  void close() {}

  @override
  List<int> getRangeData(int start, int end) {
    return input.getRange(start, end);
  }

  @override
  int get length => input.length;
}
