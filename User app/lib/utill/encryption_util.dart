import 'package:encrypt/encrypt.dart';

class EncryptionUtil {
  // A 32 byte key for AES encryption. In a production app, this should be 
  // generated and stored securely or retrieved from an environment variable.
  static final Key _key = Key.fromUtf8('vmarket_secure_secret_key_123456');
  static final IV _iv = IV.fromLength(16);
  static final Encrypter _encrypter = Encrypter(AES(_key));

  static String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return encryptedBase64;
    try {
      final decrypted = _encrypter.decrypt64(encryptedBase64, iv: _iv);
      return decrypted;
    } catch (e) {
      // Return raw string if decryption fails (e.g. for legacy plain-text data)
      return encryptedBase64;
    }
  }
}
