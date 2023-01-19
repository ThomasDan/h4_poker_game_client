import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import './player_seat_widget.dart';
import '../models/player_action_methods.dart';
import '../models/player.dart';

class PlayerControls extends StatelessWidget {
  Player player;
  PlayerActionMethods actionMethods;
  ScreenshotController controller;

  PlayerControls(this.player, this.actionMethods, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> saveImage(Uint8List imageBytes) async {
      await [Permission.storage].request();

      final time = DateTime.now()
          .toIso8601String()
          .replaceAll('.', '-')
          .replaceAll(':', '-');
      final name = 'screenshot_$time';
      final result = await ImageGallerySaver.saveImage(imageBytes, name: name);
      return result['filePath'];
    }

    Future<Uint8List> pngDownsizer(Uint8List _image) async {
      final pngImage = img.decodePng(_image);
      final resizedpngImage = img.copyResize(
        pngImage!,
        // Making it 1/8'th as big as the original, to fit the "variable size limit of 50 kb" for certain.
        width: (pngImage.width / 8).floor(),
        // height is automatically set by copyResize(), scaled to width and src
      );

      return img.encodePng(
        resizedpngImage,
      );
    }

    Future sendEmail(Uint8List _image) async {
      _image = await pngDownsizer(_image);
      String email = 'thom09r7@zbc.dk';
      String subject = 'You took a picture!';
      String body =
          'You have used our take-a-picture feature! And it May have worked!\nWe would have included the result, but emailJS are stingy bastards.\n\n<img src="data:image/png;base64, $_image">';
      player.name;

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'service_w7dd45g',
          'template_id': 'template_h1n401o',
          'user_id': 'ag6XQZt5t7ubEP7F7',
          'template_params': {
            'user_subject': subject,
            'user_name': player.name,
            'user_body': body,
            'user_email': email,
          }
        }),
      );

      print(response.body);
    }

    return Column(
      children: [
        Row(
          children: [
            PlayerSeatWidget(player, true),
            // Dragable has an unused datatype int and data of 0, and that's because DragTarget and Dragable will cause an exception if there's no data.
            Draggable<int>(
              data: 0,
              feedback: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  height: 35,
                  width: 35,
                ),
                child: Image.asset('./assets/images/bananaBunch.png'),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(
                  height: 100,
                  width: 100,
                ),
                child: Image.asset('./assets/images/bananaBunch.png'),
              ),
            )
          ],
        ),
        Row(
          // Control buttons
          children: [
            ElevatedButton(
              onPressed: () => actionMethods.checkOrCall,
              child: const Text('Check/Call'),
            ),
            const SizedBox(
              width: 3,
            ),
            ElevatedButton(
              onPressed: () => actionMethods.allIn,
              child: const Text('All-In'),
            ),
            const SizedBox(
              width: 3,
            ),
            ElevatedButton(
              onPressed: () => actionMethods.fold,
              child: const Text(
                'Fold',
                style: TextStyle(color: Color.fromARGB(255, 200, 8, 8)),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            ElevatedButton(
              onPressed: () async {
                final image = await controller.capture();
                if (image == null) return;
                await saveImage(image);
                await sendEmail(image);
              },
              child: const Text('Snap a pic!'),
            ),
          ],
        ),
      ],
    );
  }
}
