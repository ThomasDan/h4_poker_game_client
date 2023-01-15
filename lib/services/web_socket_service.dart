import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final Function newMessageReceived;

  WebSocketService(this.newMessageReceived) {
    listen();
  }

  // SKP-IT wifi | Min: 172.18.100.126 | Jacob: 172.18.100.167
  IOWebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('ws://172.18.100.167:8080'));

  Future listen() async {
    //channel.sink.add('{"type":"createGame","gameName":"Chad Monkey #13"}');

    channel.stream.listen((message) {
      /*
      Map<String, dynamic> messageMapped = jsonDecode(message);
      if (messageMapped.containsKey('type') &&
          messageMapped['type'] == 'createGame' &&
          messageMapped.containsKey('gameId')) {
        String messageToSend =
            '{"type":"startGame","gameId":"${messageMapped['gameId']}"}';
        print(messageToSend);
        channel.sink.add(messageToSend);
      }
      */
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
