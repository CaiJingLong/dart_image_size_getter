import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_size_getter/src/core/input.dart';

class NetworkInput extends ImageInput {
  NetworkInput(String url) {
    var uri = Uri.parse(url);
    var request = http.Request('GET', uri);
    _response = _client.send(request);
  }

  http.Client _client = http.Client();
  Stream<List<int>> _stream;
  Future<http.StreamedResponse> _response;
  List<int> data = List();
  Future<Uint8List> get bytes async {
    if (_stream == null) {
      _stream = (await _response).stream.asBroadcastStream();
    }
    await _stream.forEach((element) {
      data.addAll(element);
    });
    _client.close();
    return Uint8List.fromList(data);
  }

  @override
  Future<bool> exists() async {
    return (await _response).statusCode == 200;
  }

  @override
  Future<List<int>> getRange(int start, int end) async {
    if (_stream == null) {
      _stream = (await _response).stream.asBroadcastStream();
      _stream.listen((event) {}, onDone: () {
        _client.close();
      });
    }
    while (data.length < end) {
      data.addAll(await _stream.first);
    }
    return data.sublist(start, end);
  }

  @override
  Future<int> get length async {
    return (await _response).contentLength;
  }
}
