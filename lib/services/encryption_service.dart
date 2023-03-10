import 'package:flutter/foundation.dart';

import 'dart:convert';
import "package:pointycastle/export.dart";
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

// https://pub.dev/packages/pointycastle
// RSA:
// - https://github.com/bcgit/pc-dart/blob/master/tutorials/rsa.md
// AES:
// - https://github.com/bcgit/pc-dart/blob/master/tutorials/aes-cbc.md

class EncryptionService {
  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> ourKeyPair;

  // Not required, but kept for testing purposes
  late RSAPublicKey theirPublicKey;

  late SecureRandom random;

  // Given to us by the Game Engine Server
  late Uint8List _aesKey;
  late Uint8List _aesIV;

  bool aesValuesSet = false;

  EncryptionService() {
    random = _createSecureRandom();
    ourKeyPair = _generateRSAkeyPair(random);
  }

  void setAESValues(Uint8List key, Uint8List vI) {
    _aesKey = key;
    _aesIV = vI;
    aesValuesSet = true;
  }

  Uint8List encryptAESMessage(String message) {
    Uint8List intListUnencrypted = convertStringToUint8List(message);

    // Here we determine how much padding there should be, 1-16.
    // Without any padding, the _cutPadding() gets very angry, because it can't count the padding.
    int bytesRequiredToConsistOf128bitPackages =
        16 - (intListUnencrypted.length % 16);

    intListUnencrypted = _addPadding(intListUnencrypted,
        intListUnencrypted.length + bytesRequiredToConsistOf128bitPackages);

    Uint8List encryptedMessage = _aesEncrypt(intListUnencrypted);
    return encryptedMessage;
  }

  String decryptAESMessage(Uint8List message) {
    // First we decrypt the message
    Uint8List intListDecrypted = _aesDecrypt(message);
    // Second we cut out all that padding
    intListDecrypted = _cutPadding(intListDecrypted);

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

  // FULL DISCLORE: I pretty much 1:1 copied this code from below github link. I do NOT have the time to get into ASN1 or PEM.
  // This exists purely for demonstration purposes.
  String getPublicKeyAsPEM() {
    // https://stackoverflow.com/a/65853242
    // - And more specifically https://gist.github.com/proteye/982d9991922276ccfb011dfc55443d74
    var algorithmSequence = ASN1Sequence();

    // I assume it's some kind of formatting for ASN1.
    var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSequence.add(algorithmAsn1Obj);
    algorithmSequence.add(paramsAsn1Obj);

    var publicKeySequence = ASN1Sequence();
    publicKeySequence.add(ASN1Integer(ourKeyPair.publicKey.modulus!));
    publicKeySequence.add(ASN1Integer(ourKeyPair.publicKey.exponent!));
    var publicKeySeqBitString =
        ASN1BitString(Uint8List.fromList(publicKeySequence.encodedBytes));

    var topLevelSequence = ASN1Sequence();
    topLevelSequence.add(algorithmSequence);
    topLevelSequence.add(publicKeySeqBitString);
    var base64EncodedPK = base64.encode(topLevelSequence.encodedBytes);

    String output =
        """-----BEGIN PUBLIC KEY-----\r\n$base64EncodedPK\r\n-----END PUBLIC KEY-----""";
    print(output);
    return output;
  }

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

  // pads with PKCS7
  Uint8List _addPadding(Uint8List listToPad, int paddedLength) {
    int originalLength = listToPad.length;

    // https://gist.github.com/proteye/e54eef1713e1fe9123d1eb04c0a5cf9b
    var out = Uint8List(paddedLength)..setAll(0, listToPad);

    // add padding
    var padder = PKCS7Padding();
    padder.init();
    padder.addPadding(out, originalLength);
    return out;
  }

  Uint8List _cutPadding(Uint8List listToCut) {
    var padder = PKCS7Padding();
    padder.init();
    int padLength = padder.padCount(listToCut);
    int newLength = listToCut.length - padLength;

    return Uint8List(newLength)..setRange(0, newLength, listToCut);
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

    return _rsaBlockProcessor(encryptor, dataToEncrypt);
  }

  // Uses Our private key to decrypt the message that the sender encrypted for us using our Public Key.
  Uint8List _rsaDecrypt(RSAPrivateKey ourPrivateKey, Uint8List dataToDecrypt) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(ourPrivateKey));

    return _rsaBlockProcessor(decryptor, dataToDecrypt);
  }

  // Processes blocks of data using the block cipher engine, be it encrypting or decrypting per the engine's settings.
  Uint8List _rsaBlockProcessor(AsymmetricBlockCipher engine, Uint8List input) {
    // Here we find out how many blocks we need to divide the input into.
    // We need to operate with whole numbers, so therefore we use Truncated Integer Division (~/)
    // It rounds the result towards zero (down). To account for the probable leftover decimals worth of data,
    // we do a final check to see if the input perfectly fits into the engine block size, adding an extra block if not.
    int blockCount = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);
    Uint8List output = Uint8List(blockCount * engine.outputBlockSize);

    int inputOffset = 0;
    int outputOffset = 0;

    // This while loop does all the math and stuff involved with packing and encrypting the input to the output.
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

  Uint8List _aesEncrypt(Uint8List paddedMessage) {
    CBCBlockCipher cbc = CBCBlockCipher(AESEngine())
      ..init(true, ParametersWithIV(KeyParameter(_aesKey), _aesIV));

    Uint8List encryptedMessage = Uint8List(paddedMessage.length);

    int offset = 0;

    while (offset < paddedMessage.length) {
      offset +=
          cbc.processBlock(paddedMessage, offset, encryptedMessage, offset);
    }

    return encryptedMessage;
  }

  Uint8List _aesDecrypt(Uint8List message) {
    CBCBlockCipher cbc = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(_aesKey), _aesIV));

    int storedLength = message.length;
    Uint8List paddedMessage = Uint8List(storedLength);

    int offset = 0;

    while (offset < storedLength) {
      offset += cbc.processBlock(message, offset, paddedMessage, offset);
    }

    return paddedMessage;
  }

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
