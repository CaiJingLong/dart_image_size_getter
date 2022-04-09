import 'package:flutter/services.dart';
import 'package:image_size_getter/image_size_getter.dart';

/// {@template image_size_getter_flutter.flutter_asset_image_input}
///
/// An implementation of [AsyncImageInput] that reads from a Flutter asset.
///
/// This class is used by [ImageSizeGetter] to read from a Flutter asset.
///
/// Example usage:
/// ```dart
///
/// import 'package:image_size_getter/image_size_getter.dart';
/// import 'package:image_size_getter_flutter/image_size_getter_flutter.dart';
///
/// Future<Size> getAsset(String assetKey) async {
///  final input = await FlutterAssetImageInput.create(assetKey);
///  return ImageSizeGetter.getSizeAsync(input);
/// }
///
/// ```
///
/// {@endtemplate}
class FlutterAssetImageInput extends AsyncImageInput {
  FlutterAssetImageInput._(this.assetKey, this._byteData);

  /// {@template image_size_getter_flutter.flutter_asset_image_input.asset_key}
  ///
  /// The asset key of flutter asset.
  ///
  /// {@endtemplate}
  final String assetKey;

  /// The byte data of flutter asset.
  final ByteData _byteData;

  /// {@macro image_size_getter_flutter.flutter_asset_image_input}
  ///
  /// The [assetKey]:
  /// {@macro image_size_getter_flutter.flutter_asset_image_input.asset_key}
  static Future<FlutterAssetImageInput> create(String assetKey) async {
    final byteData = await rootBundle.load(assetKey);
    return FlutterAssetImageInput._(assetKey, byteData);
  }

  @override
  Future<HaveResourceImageInput> delegateInput() async {
    return HaveResourceImageInput(
      innerInput: MemoryInput.byteBuffer(_byteData.buffer),
      onRelease: () async {},
    );
  }

  /// Because the asset is loaded by rootBundle, it is always available.
  ///
  /// If the asset is not available, the error is caught by [FlutterAssetImageInput.create].
  @override
  Future<bool> exists() async {
    return true;
  }

  @override
  Future<List<int>> getRange(int start, int end) {
    return Future.value(_byteData.buffer.asUint8List(start, end - start));
  }

  @override
  Future<int> get length async {
    return _byteData.lengthInBytes;
  }

  @override
  Future<bool> supportRangeLoad() async {
    return true;
  }
}
