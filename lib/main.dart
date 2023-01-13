import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'widgets/game.dart';
import 'widgets/initial_name_dialog_box.dart';

// We changed void main() into Future main(), in order to make it async for non-local components that may not respond instantly.
// Particularly FIrebase.
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String _title = 'Albert Saves The Poker Tournament\nGOTY Edition';
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InitialNameDialogBox initNameDialog = InitialNameDialogBox();
  String name = '';

  void setName(String _name) {
    setState(() {
      name = _name;
    });
  }

  Widget noNameNoGame() {
    return name == '' ? const Text('Awaiting name...') : Game(name);
  }

  @override
  // initState()
  void initState() {
    // https://www.flutterbeads.com/call-method-after-build-in-flutter/
    super.initState();
    // the .addPostFrameCallback is called after the very last frame of the app has been drawn during build()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (name == '') {
        initNameDialog.getName(setName, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[noNameNoGame()],
        ),
      ),
    );
  }
}
