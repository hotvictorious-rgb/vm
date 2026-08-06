import os
import re

apps = ['User app', 'Vendor app', 'Delivery man app']

for app in apps:
    auth_repo = os.path.join(app, 'lib', 'features', 'auth', 'domain', 'repositories', 'auth_repository.dart')
    util_dest = os.path.join(app, 'lib', 'utill', 'encryption_util.dart')
    
    if not os.path.exists(util_dest):
        with open(util_dest, 'w') as f:
            f.write('''import 'package:encrypt/encrypt.dart';

class EncryptionUtil {
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
      return encryptedBase64;
    }
  }
}
''')
    
    if os.path.exists(auth_repo):
        with open(auth_repo, 'r') as f:
            content = f.read()
            
        if 'EncryptionUtil' not in content:
            # Add import
            content = content.replace("import 'package:shared_preferences/shared_preferences.dart';", 
                                      "import 'package:shared_preferences/shared_preferences.dart';\nimport 'package:flutter_sixvalley_ecommerce/utill/encryption_util.dart';")
            
            # Encrypt sets
            content = re.sub(r'sharedPreferences!\.setString\((AppConstants\.(?:userLoginToken|userPassword|userLogData|userEmail)),\s*([a-zA-Z0-9_]+)\)',
                             r'sharedPreferences!.setString(\1, EncryptionUtil.encrypt(\2))', content)
            
            # Decrypt gets
            content = re.sub(r'sharedPreferences!\.getString\((AppConstants\.(?:userLoginToken|userPassword|userLogData|userEmail))\)',
                             r'EncryptionUtil.decrypt(sharedPreferences!.getString(\1) ?? "")', content)
                             
            with open(auth_repo, 'w') as f:
                f.write(content)
