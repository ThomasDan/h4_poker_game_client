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
  
  var channel = IOWebSocketChannel.connect(Uri.parse('ws://10.108.169.89:8080'));

  int hellosSent = 0;
  bool connectionMade = false;

  List<String> messages = [ 'proof'
  ];

  Future listen() async {
    channel.sink.add('{"message":"Hello?"}');
    channel.stream.listen((message) {
      //channel.sink.add('Received!');
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
    if(!connectionMade){
      listen();
      connectionMade = true;
    }
    if(hellosSent < 3){
      hellosSent++;
      channel.sink.add('{"message":"HELLO? x${hellosSent}"}');
    }
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
