import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RaiseDialogBox {
  int raiseValue = 0;
  Function setRaise;

  RaiseDialogBox(this.setRaise);

  void openRaiseDialog(
      int currentCall, int currentBananas, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  const Text(
                    'How much do you wish to raise?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Must be more than $currentCall🍌 and cannot exceed $currentBananas🍌',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      raiseValue = int.parse(value);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (raiseValue <= currentCall ||
                          raiseValue > currentBananas) {
                        return;
                      }
                      setRaise(raiseValue);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Bet!',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
