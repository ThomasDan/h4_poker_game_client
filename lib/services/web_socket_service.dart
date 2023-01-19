import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final Function newMessageReceived;

  WebSocketService(this.newMessageReceived) {
    listen();
  }

  // SKP-IT wifi | Min: 172.18.100.126 | Jacob: 172.18.100.167
  IOWebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('ws://192.168.168.161:8080'));

  Future listen() async {
    channel.stream.listen((message) {
      newMessageReceived(message);
    });
  }

  Future send(String message) async {
    channel.sink.add(message);
  }

  void close() {
    channel.sink.close(status.goingAway);
  }
}
