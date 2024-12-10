import 'package:encrypt/encrypt.dart';
import 'dart:convert' as convert;

class EncryptData{
//for AES Algorithms

   Encrypted? encrypted;
   var decrypted;

  String myKey = "Google**@@1500aungmyominshortwav";

   String encryptAES(plainText){
    final key = Key.fromUtf8(myKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted!.base64.toString();
  }

  String decryptAES(plainText){
    final key = Key.fromUtf8(myKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
     decrypted = encrypter.decrypt(Encrypted(convert.base64Decode(plainText)), iv: iv);
    return decrypted;
  }
}