import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  // Delete Data (for Logout)
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
 
// get , set ,delete    between flutter code and the local storage lib(flutter secure storage) or (shared prefrences) 