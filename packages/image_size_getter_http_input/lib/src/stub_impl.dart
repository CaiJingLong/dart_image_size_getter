import 'image_size_getter_http_input_base.dart';

Future<ImageInputWrapper> createDelegateInput(Uri uri) =>
    throw UnsupportedError(
        'Cannot create a client without dart:html or dart:io.');
