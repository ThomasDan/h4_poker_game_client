import 'package:flutter/cupertino.dart';
import 'package:h4_poker_game_client/services/web_socket_service.dart';

class CommunicationManager extends StatefulWidget {
  @override
  State<CommunicationManager> createState() => _CommunicationManagerState();
}

class _CommunicationManagerState extends State<CommunicationManager> {
  @override
  Widget build(BuildContext context) {
    return WebSocketService();
    //const Text('Communication Manager');
  }
}
