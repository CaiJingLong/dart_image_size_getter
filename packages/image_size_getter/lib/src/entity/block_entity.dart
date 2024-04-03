/// The block of jpeg format.
class BlockEntity {
  /// The block of jpeg format.
  BlockEntity(this.type, this.length, this.start);

  /// The type of the block.
  int type;

  /// The length of the block.
  int length;

  /// Start of offset
  int start;

  /// Error block.
  static BlockEntity error = BlockEntity(-1, -1, -1);

  @override
  String toString() {
    return "BlockEntity (type:$type, length:$length)";
  }
}
