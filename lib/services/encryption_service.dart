import 'package:flutter/foundation.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart";

// https://pub.dev/packages/pointycastle
// RSA:
// - https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
// AES:
// - https://github.com/bcgit/pc-dart/blob/master/tutorials/aes-cbc.md

class EncryptionService {
  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> ourKeyPair;

  // Not required, but kept for testing purposes
  late RSAPublicKey theirPublicKey;

  String? aesKey;

  EncryptionService() {
    ourKeyPair = _generateRSAkeyPair(_createSecureRandom());
  }

  void setAESKey(String key) {
    aesKey = key;
  }

  Uint8List encryptAESMessage(String message) {
    Uint8List intListUnencrypted = convertStringToUint8List(message);

    return _aesDecrypt(aesKey, intListUnencrypted);
  }

  String decryptAESMessage(Uint8List message) {
    // First we decrypt the message
    Uint8List intListDecrypted = _aesDecrypt(aesKey, message);
    // Then we return the converted String message
    return convertUint8ListToString(intListDecrypted);
  }

  // No need, as we send our public key to the server, and receive an AES key instead. Kept for Testing Purposes.
  Uint8List encryptRSAMessage(String message) {
    // First we turn the String into Uint8List (basically bytes)
    Uint8List intListUnencrypted = convertStringToUint8List(message);
    // Then we return the encrypted Uint8List message.
    return _rsaEncrypt(theirPublicKey, intListUnencrypted);
  }

  String decryptRSAMessage(Uint8List message) {
    // First we decrypt the message
    Uint8List intListDecrypted = _rsaDecrypt(ourKeyPair.privateKey, message);
    // Then we return the converted String message
    return convertUint8ListToString(intListDecrypted);
  }

  // ############################      RSA KEY GENERATION FUNCTIONS      ####################################

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    /* Create an RSA key generator and initialize it
      we use bitLength = 2048, as it is the minimum recommended, and absolute safety is not necessarily wanted.*/

    final rsaKeyGenerator = RSAKeyGenerator();

    rsaKeyGenerator.init(
      ParametersWithRandom(
          RSAKeyGeneratorParameters(
            BigInt.parse(
                '65537'), // Public Exponent. Set to 65537, as it is regarded as a reasonable compromise between security and convenience.
            bitLength,
            64, // Certainty
          ),
          secureRandom),
    );

    // This generator, despite being an RSA key generator, creates generic keys
    final pair = rsaKeyGenerator.generateKeyPair();

    // So we cast them as the key-type we need on return.
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

  // SecureRandom is a cryptographical random number generator.
  SecureRandom _createSecureRandom() {
    // 'Fortuna' is a cryptographically-secured Pseudo-Random Number Generating formula (PRNG)
    final secureRandom = SecureRandom('Fortuna')
      // These two dots mean that it keeps referring to the still-open object (no ';'). 'secureRandom' in this case.
      ..seed(
        KeyParameter(
          Platform.instance.platformEntropySource().getBytes(32),
        ),
      );
    return secureRandom;
  }

  // ############################      RSA ENCRYPTION/DECRYPTION FUNCTIONS      ####################################

  // Uses Their public key to encrypt the message that we intend for the receiver to decrypt using their private key.
  Uint8List _rsaEncrypt(RSAPublicKey theirPublicKey, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(theirPublicKey));

    return _blockProcessor(encryptor, dataToEncrypt);
  }

  // Uses Our private key to decrypt the message that the sender encrypted for us using our Public Key.
  Uint8List _rsaDecrypt(RSAPrivateKey ourPrivateKey, Uint8List dataToDecrypt) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(ourPrivateKey));

    return _blockProcessor(decryptor, dataToDecrypt);
  }

  // Processes blocks of data using the block cipher engine, be it encrypting or decrypting per the engine's settings.
  Uint8List _blockProcessor(AsymmetricBlockCipher engine, Uint8List input) {
    // Here we find out how many blocks we need to divide the input into.
    // We need to operate with whole numbers, so therefore we use Truncated Integer Division (~/)
    // It rounds the result towards zero (down). To account for the probable leftover decimals worth of data,
    // we do a final check to see if the input perfectly fits into the engine block size, adding an extra block if not.
    int blockCount = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);
    Uint8List output = Uint8List(blockCount * engine.outputBlockSize);

    int inputOffset = 0;
    int outputOffset = 0;

    // This while loop does all the math and stuff involved with processing and transferring the input to the output.
    while (inputOffset < input.length) {
      int chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    // If there is spare space in the output, it is cut off via .sublist
    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  // ############################      AES ENCRYPTION/DECRYPTION FUNCTIONS      ####################################
  Uint8List _aesEncrypt(String aesKey, Uint8List message) {}

  Uint8List _aesDecrypt(String aesKey, Uint8List message) {}
  // ############################      UIntList and String conversions      ####################################
  // https://coflutter.com/dart-flutter-how-to-convert-string-to-uint8list/

  // It may be important to note, that ".codeUnits" uses UTF-16
  Uint8List convertStringToUint8List(String string) {
    List<int> codeUnits = string.codeUnits;
    return Uint8List.fromList(codeUnits);
  }

  // Once again, ".fromCharCodes" uses UTF-16 (and "runes", which I assume is short for asian moonrunes)
  String convertUint8ListToString(Uint8List intList) {
    return String.fromCharCodes(intList);
  }
}
