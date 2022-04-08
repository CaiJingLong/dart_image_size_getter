import 'dart:collection';

import 'package:image_size_getter/image_size_getter.dart';

export 'core/input.dart';

class _DecoderContainer extends IterableBase<BaseDecoder> {
  _DecoderContainer(List<BaseDecoder> decoders) {
    for (final decoder in decoders) {
      _decoders[decoder.decoderName] = decoder;
    }
  }

  final Map<String, BaseDecoder> _decoders = {};

  @override
  Iterator<BaseDecoder> get iterator => _decoders.values.iterator;
}

final _decoders = _DecoderContainer([
  const GifDecoder(),
  const JpegDecoder(),
  const WebpDecoder(),
  const PngDecoder(),
]);

class ImageSizeGetter {
  static bool isPng(ImageInput input) {
    return PngDecoder().isValid(input);
  }

  static bool isWebp(ImageInput input) {
    return WebpDecoder().isValid(input);
  }

  static bool isGif(ImageInput input) {
    return GifDecoder().isValid(input);
  }

  static bool isJpg(ImageInput input) {
    return JpegDecoder().isValid(input);
  }

  static Size getSize(ImageInput input) {
    if (!input.exists()) {
      throw Exception('The input is not exists.');
    }

    for (var value in _decoders) {
      if (value.isValid(input)) {
        return value.getSize(input);
      }
    }

    throw Exception('The input is not supported.');
  }

  static Future<Size> getSizeAsync(AsyncImageInput input) async {
    if (!await input.exists()) {
      throw Exception('The input is not exists.');
    }

    if (!(await input.supportRangeLoad())) {
      final delegateInput = await input.delegateInput();
      try {
        return ImageSizeGetter.getSize(delegateInput);
      } finally {
        delegateInput.release();
      }
    }

    for (var value in _decoders) {
      if (await value.isValidAsync(input)) {
        return value.getSizeAsync(input);
      }
    }

    throw Exception('The input is not supported.');
  }
}
