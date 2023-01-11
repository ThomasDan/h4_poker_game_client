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
  // jacob WS test:  https://us-central1-pokergameengine-firebase.cloudfunctions.net/helloWorld
  var channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
  List<String> messages = [
    'Test 1: This is not from WS',
    'Test 2: This is not from WS'
  ];

  Future listen() async {
    channel.sink.add('Hello?');
    channel.stream.listen((message) {
      channel.sink.add('Received!');
      //channel.sink.close(status.goingAway);
      setState(() {
        messages.add(message);
      });
    });
  }

  // https://www.youtube.com/watch?v=lkpPg0ieklg (streambuilder)
  /*
  Stream<String> receiveMessage() async* {
    channel.stream.listen((message) {
      channel.sink.add('Received!');
      setState(() {
        messages.add(message);
      });
    });
  }
  */

  // https://www.flutterbeads.com/call-method-after-build-in-flutter/
  //@override
  //void initState() {
  // this initState() is called right after the Widget is done building.
  //  super.initState();
  //  WidgetsBinding.instance?.addPostFrameCallback((_) {
  //    listen();
  //  });
  //}

  @override
  Widget build(BuildContext context) {
    listen();
    channel.sink.add('HELLO?');
    return Text(messages.join('\n'));

    /*StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        String result;
        if (snapshot.connectionState == ConnectionState.waiting) {
          result = 'Waiting for connection..';
        } else if (snapshot.hasData) {
          result = snapshot.data;
        } else if (snapshot.hasError) {
          result = 'Error: ${snapshot.error.toString()}';
        } else {
          result = '???';
        }
        return Text(result);
      },
    );
    */

    /*
    //return ListView.builder(
    //  itemBuilder: (context, index) {
    //    return ListTile(
    //      leading: SizedBox(
    //        child: Text(messages[index]),
    //        height: 50,
    //        width: 150,
    //      ),
    //    );
    //  },
    //  itemCount: messages.length,
    //);
    */
  }
}
