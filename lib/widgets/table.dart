import 'package:flutter/cupertino.dart';

import '../models/player.dart';
import '../models/card.dart';

class Table extends StatefulWidget {
  Table({super.key});

  @override
  State<Table> createState() => _TableState();
}

class _TableState extends State<Table> {
  List<Player> players = [];
  List<Card> cards = [];
  int pool = 0;

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}
