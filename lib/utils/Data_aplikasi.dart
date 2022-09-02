import 'package:good_day/utils/Local_storage.dart';

class AppData {
  // data user login

  static set setNama(String value) {
    LocalStorage().saveToDisk(key: 'username', value: value);
  }

  static String get username => LocalStorage().getFromDisk(key: 'username');

  static set setUserId(String value) {
    LocalStorage().saveToDisk(key: 'userId', value: value);
  }

  static String get userId => LocalStorage().getFromDisk(key: 'userId');

  static set setRole(String value) {
    LocalStorage().saveToDisk(key: 'role', value: value);
  }

  static String get role => LocalStorage().getFromDisk(key: 'role');
}
