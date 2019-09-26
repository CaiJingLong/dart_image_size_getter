class BlockEntity {
  int type;
  int length;

  BlockEntity(this.type, this.length);

  static BlockEntity error = BlockEntity(-1, -1);

  @override
  String toString() {
    return "BlockEntity (type:$type, length:$length)";
  }
}
