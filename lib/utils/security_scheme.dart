import 'package:flutter/material.dart';
import 'package:xor_encryption/xor_encryption.dart';

// This is the XOR cipher code make up:
class PasswordHandler {
  // The key used in the encryption
  final String key = 'HG0sV3MBqa4VD5VEoGTaBjrErxGI3JAX';

  // Encryption method
  String encode(String password) {
    final keys = key;
    final encrypted = XorCipher().encryptData(password, keys);
    debugPrint('Encrypted password: $encrypted');
    return encrypted;
  }

  // Decryption method
  String decode(String encrypted) {
    final keys = key;
    final decrypted = XorCipher().encryptData(encrypted, keys);
    debugPrint('Decrypted password: $decrypted');

    return decrypted;
  }
}
