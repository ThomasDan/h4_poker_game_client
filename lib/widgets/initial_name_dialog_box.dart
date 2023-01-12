import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialNameDialogBox {
  //extends StatelessWidget
  final Function setName;

  InitialNameDialogBox(this.setName); //, {super.key}

  String GetName(BuildContext context) {
    String _result = '';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter your name:'),
              const SizedBox(
                height: 50,
              ),
              TextField(
                onChanged: (value) => _result = value,
              ),
              TextButton(
                onPressed: () {
                  setName(_result);
                  Navigator.pop(context);
                },
                child: Text('Connect'),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return _result;
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
