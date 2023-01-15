import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../services/web_socket_service.dart';
import '../services/encryption_service.dart';

class CommunicationManager {
  late WebSocketService wsServ;
  late EncryptionService encryptServ;

  List<String> messages = [];

  CommunicationManager() {
    encryptServ = EncryptionService();
    // Constructing the WEbSocketService() also opens the websocket connection.
    wsServ = WebSocketService(incomingMessage);
    wsServ.send(
      '{"type":"encrypt", "rsaPublicKey":${encryptServ.ourKeyPair.publicKey}}',
    );
  }

  // Tests if the encryption service can encrypt and decrypt RSA messages between two instances of itself.
  void testRSA() {
    EncryptionService es1 = EncryptionService();
    EncryptionService es2 = EncryptionService();

    // Magical exchange of Public Keys
    es1.theirPublicKey = es2.ourKeyPair.publicKey;
    es2.theirPublicKey = es1.ourKeyPair.publicKey;

    // ES1 encrypts a message for ES2
    Uint8List messageForES2 = es1.encryptRSAMessage(
        'Hello? This is ES1. Do you understand this message, ES2? ÆØÅ ä Â øæå');
    print(
        'Message from ES1 to ES2, encrypted by ES1 (first 3 elements):\n${messageForES2.sublist(0, 3).toString()}');
    // ES2 decrypts a message from ES1
    String messageFromES1 = es2.decryptRSAMessage(messageForES2);
    print('Message from ES1 to ES2, decrypted by ES2:\n${messageFromES1}');
  }

  void incomingMessage(String message) {
    // Firstly, we check if we've received an AES-key yet. Else that Should be the first thing we get.
    if (encryptServ.aesKey == null) {
      String decryptedMessage =
          encryptServ.decryptRSAMessage(message as Uint8List);
      Map<String, dynamic> messageMapped = jsonDecode(decryptedMessage);
      if (messageMapped.containsKey('aesKey')) {
        encryptServ.setAESKey(messageMapped['aesKey']);
      } else {
        print('.. This does not contain an AES key:\n${message}');
      }
    } else {
      // Decryption of Message

      // Handling of Message

    }
  }

  void outgoingMessage(String message) {}

  void close() {
    wsServ.close();
  }
}
