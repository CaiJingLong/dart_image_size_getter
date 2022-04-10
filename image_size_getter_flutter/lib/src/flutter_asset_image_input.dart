import 'dart:typed_data';

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
///  final input = FlutterAssetImageInput(assetKey);
///  return ImageSizeGetter.getSizeAsync(input);
/// }
///
/// ```
///
/// {@endtemplate}
class FlutterAssetImageInput extends AsyncImageInput {
  /// {@macro image_size_getter_flutter.flutter_asset_image_input}
  FlutterAssetImageInput(this.assetKey);

  /// {@template image_size_getter_flutter.flutter_asset_image_input.asset_key}
  ///
  /// The asset key of flutter asset.
  ///
  /// {@endtemplate}
  final String assetKey;

  /// The byte data of flutter asset.
  Uint8List? _bytes;

  Future<Uint8List> get byteData async {
    _bytes ??= (await rootBundle.load(assetKey)).buffer.asUint8List();
    return _bytes!;
  }

  @override
  Future<HaveResourceImageInput> delegateInput() async {
    final byteData = await this.byteData;
    return HaveResourceImageInput(
      innerInput: MemoryInput(byteData),
      onRelease: () async {},
    );
  }

  /// Because the asset is loaded by rootBundle, it is always available.
  ///
  /// If the asset is not available, the error is caught by [FlutterAssetImageInput.create].
  @override
  Future<bool> exists() async {
    try {
      await byteData;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<int>> getRange(int start, int end) async {
    final data = await byteData;
    return Future.value(data.buffer.asUint8List(start, end - start));
  }

  @override
  Future<int> get length async {
    return (await byteData).length;
  }

  @override
  Future<bool> supportRangeLoad() async {
    return true;
  }
}
