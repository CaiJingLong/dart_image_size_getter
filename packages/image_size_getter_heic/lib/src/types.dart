/// Default list of box types that should be treated as full boxes when parsing
/// HEIC files.
///
/// A full box is a box that contains a version and flags field in addition to
/// its normal content. This list includes:
/// - 'meta': The metadata container box
/// - 'ispe': The image spatial extents box, containing width and height
const List<String> defaultFullBoxTypes = [
  'meta',
  // 'hdlr',
  // 'pitm',
  // 'iloc',
  // 'iinf',
  // 'infe',
  // 'iref',
  'ispe',
];
