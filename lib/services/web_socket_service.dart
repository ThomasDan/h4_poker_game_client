import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/material.dart';

class WebSocketService extends StatefulWidget {
  //final Function newMessageReceived;

  // WebSocketService(this.newMessageReceived);

  @override
  State<WebSocketService> createState() => _WebSocketServiceState();
}

class _WebSocketServiceState extends State<WebSocketService> {
  // SKP-IT wifi | Min: 172.18.100.126 | Jacob: 172.18.100.167
  IOWebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse('ws://172.18.100.167:8080'));

  bool listening = false;

  List<String> messages = [];

  Future listen() async {
    channel.sink.add('{"type":"createGame","gameName":"Chad Monkey #1337"}');
    channel.stream.listen((message) {
      Map<String, dynamic> messageMapped = jsonDecode(message);
      if (messageMapped.containsKey('gameId')) {
        channel.sink
            .add('{"type":"startGame","gameId":"${messageMapped['gameId']}"}');
      }
      //channel.sink.add('Received!');
      //channel.sink.close(status.goingAway);
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!listening) {
      listen();
      listening = true;
    }
    return Text(messages.join('\n'));
  }
}
