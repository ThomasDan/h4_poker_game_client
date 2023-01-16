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
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height / 3,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    ' - MISSION DEBRIEF: - ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '[ MONKEY EYES ONLY ]',
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 15, 15),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Albert! Something awful has happened! Our intelligence suggests that the flying spaghetti monster has infiltrated the grand poker tournament! The very one which decides whether there will be world peace! Further, it is cheating by masquerading as every contestant! To ensure World Peace, you must covertly defeat the flying spaghetti monster at poker! Please choose a cover name, so the flying spaghetti monster does not recognize you.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Enter your cover name:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
