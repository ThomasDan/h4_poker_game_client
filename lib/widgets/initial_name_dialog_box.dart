import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialNameDialogBox {
  //extends StatelessWidget
  //final Function setName;

  InitialNameDialogBox(); //this.setName, {super.key}

  void getName(Function setName, BuildContext context) {
    String _result = '';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter your name:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) => _result = value,
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_result == '') {
                    return;
                  }
                  setName(_result);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Connect',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    // https://api.flutter.dev/flutter/material/Dialog-class.html
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      showDialog<String>(
          context: context, builder: (BuildContext context) => {})
    ]);
  }
  */
}
