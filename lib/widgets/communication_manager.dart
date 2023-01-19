import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:h4_poker_game_client/models/game_variables.dart';

import '../services/web_socket_service.dart';
import '../services/encryption_service.dart';

class CommunicationManager {
  late WebSocketService wsServ;
  late EncryptionService encryptServ;
  late Function messageHandler;

  List<String> messages = [];

  CommunicationManager(handleMessage) {
    messageHandler = handleMessage;
    encryptServ = EncryptionService();
    // Constructing the WEbSocketService() also opens the websocket connection.
    wsServ = WebSocketService(incomingMessage);
    // Acquires the Public Key, as it evidently cannot be accessed directly, neither as String nor as UintList8
    String pkAsPEM = encryptServ.getPublicKeyAsPEM();

    wsServ.send(jsonEncode({"type": "encrypt", "rsaPublicKey": pkAsPEM}));

    //testAES();
    //testRSA();
  }

  void testAES() {
    EncryptionService es1 = EncryptionService();
    Uint8List aesKey = es1.random.nextBytes(16);
    Uint8List aesVI = es1.random.nextBytes(16);
    es1.setAESValues(aesKey, aesVI);

    String message =
        "Hello! This is a message that will be padded 1-16 bytes with PKCS7, and then AES-128bit-CBC encrypted, using 16 byte AES key and 16 byte IV.";
    print(
        '-------------------- AES ENCRYPTION TEST COMMENCES --------------------------\nMessage, unpadded and unencrypted:\n$message');
    print('IV, 16 bytes:\n$aesVI');
    print('AES Key, 16 bytes:\n$aesKey');
    Uint8List encryptedMessage = es1.encryptAESMessage(message);
    print(
        'Here is the encrypted message, decoded from byte array to string:\n${es1.convertUint8ListToString(encryptedMessage)}');
    String output = es1.decryptAESMessage(encryptedMessage);
    print('Decrypted Message:\n$output');

    print("------------- THIS CONCLUDES THE TEST OF AES -----------------");
  }

  // Tests if the encryption service can encrypt and decrypt RSA messages between two instances of itself.
  void testRSA() {
    print(
        '--------------- COMMENCEMENT OF THE RSA ENCRYPTION TEST ----------------');

    EncryptionService es1 = EncryptionService();
    EncryptionService es2 = EncryptionService();

    // Magical exchange of Public Keys
    es1.theirPublicKey = es2.ourKeyPair.publicKey;
    es2.theirPublicKey = es1.ourKeyPair.publicKey;
    print('ES1 and ES2 have exchanged Public Keys.');

    // ES1 encrypts a message for ES2
    String message = 'Hello? This is ES1. Do you understand this message, ES2?';
    print('Pre-Encryption RSA message:\n$message');
    Uint8List messageForES2 = es1.encryptRSAMessage(message);
    print(
        'Byte list message from ES1 to ES2, encrypted by ES1, this is the length of it:\n${messageForES2.length}');
    // ES2 decrypts a message from ES1
    String messageFromES1 = es2.decryptRSAMessage(messageForES2);
    print('Message from ES1 to ES2, decrypted by ES2:\n$messageFromES1');

    print("------------- THIS CONCLUDES THE TEST OF RSA -----------------");
  }

  void incomingMessage(String message) {
    // Firstly, we check if we've received the AES values yet. Else that Should be the first thing we get.
    if (!encryptServ.aesValuesSet) {
      try {
        String decryptedMessage =
            encryptServ.decryptRSAMessage(message as Uint8List);
        Map<String, dynamic> messageMapped = jsonDecode(decryptedMessage);
        if (messageMapped['type'] == 'aesValues') {
          print(
              'AES key:\n${messageMapped['aesKey']}\nAES IV:\n${messageMapped['aesIV']}');
          encryptServ.setAESValues(
            messageMapped['aesKey'] as Uint8List,
            messageMapped['aesIV'] as Uint8List,
          );
        }
      } catch (e) {
        // this is a really stupid way of receiving that first message containing our user ID, but whatever, no time.
        Map<String, dynamic> messageMapped = jsonDecode(message);
        messageHandler(messageMapped);
      }
    } else {
      try {
        // Decryption of Message
        String decryptedMessage =
            encryptServ.decryptAESMessage(message as Uint8List);
        // Handling of Message
        print('Message from GE:\n$decryptedMessage');
        messageHandler(jsonEncode(decryptedMessage));
      } catch (e) {
        print(
            'Something went wrong in the decryption of an assumed AES-encrypted message:\n$e');
      }
    }
  }

  void outgoingMessage(String message) {
    String encryptedMessage = encryptServ.encryptAESMessage(message).toString();
    wsServ.send(encryptedMessage);
  }

  void close() {
    wsServ.close();
  }
}
