import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialNameDialogBox {
  InitialNameDialogBox();

  void getName(Function setName, BuildContext context) {
    String _result = '';
    showDialog(
      // You cannot click outside of this dialog to make it go away, thanks to "barrierDismissible:false"
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your name:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) => _result = value,
                style: const TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  // The conditional "return;" here will break the "onPressed:" anonymous function
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
    );
  }
}
