import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Type _typeOf<T>() => T;

class PersistedObject {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final String keyPrefix;
  PersistedObject({@required this.keyPrefix})
      : assert(keyPrefix != null),
        assert(keyPrefix.isNotEmpty);
        
  Future<Duration> duration({@required String key, bool isSecure = false, DateTime compareTime}) async {
    assert(key != null);
    assert(key.isNotEmpty);
    assert(isSecure != null);
    var thenTime;
    if (isSecure)
      thenTime = await getSecureValue<DateTime>(key);
    else
      thenTime = await getValue<DateTime>(key);
    return (thenTime is DateTime) ? (compareTime ?? DateTime.now().toUtc()).difference(thenTime) : null;
  }

  Future<dynamic> getEnum<E>(List<E> values) async {
    final String key = _enumKey((_typeOf<E>()).toString());
    final String data = await getValue<String>(key);
    return (data == null) ? null : EnumToString.fromString(values, data);
  }

  Future<dynamic> getSecureEnum<E>(List<E> values) async {
    final String key = _enumKey((_typeOf<E>()).toString());
    final String data = await getSecureValue<String>(key);
    return (data == null) ? null : EnumToString.fromString(values, data);
  }

  Future<dynamic> getSecureValue<V>(String key) async {
    assert(key != null);
    assert(key.isNotEmpty);

    final storeKey = _secureKey(key);

    final storage = new FlutterSecureStorage();

    if (_typeOf<V>() == _typeOf<String>()) {
      return await storage.read(key: storeKey);
    }
    if (_typeOf<V>() == _typeOf<double>()) {
      String result = await storage.read(key: storeKey) ?? '';
      return double.tryParse(result);
    }
    if (_typeOf<V>() == _typeOf<int>()) {
      String result = await storage.read(key: storeKey) ?? '';
      return int.tryParse(result);
    }
    if (_typeOf<V>() == _typeOf<bool>()) {
      String result = await storage.read(key: storeKey);
      return (result == null) ? null : (result == '1');
    }
    if (_typeOf<V>() == _typeOf<DateTime>()) {
      String result = await storage.read(key: storeKey);
      return (result == null) ? null : DateTime.parse(result);
    }

    throw FlutterError('Unknow type "$V" cannot be saved');
  }

  Future<dynamic> getValue<V>(String key) async {
    assert(key != null);
    assert(key.isNotEmpty);
    final storeKey = _storeKey(key);

    var prefs = await SharedPreferences.getInstance();
    if (_typeOf<V>() == _typeOf<String>()) {
      return prefs.getString(storeKey);
    }
    if (_typeOf<V>() == _typeOf<double>()) {
      return prefs.getDouble(storeKey);
    }
    if (_typeOf<V>() == _typeOf<int>()) {
      return prefs.getInt(storeKey);
    }
    if (_typeOf<V>() == _typeOf<bool>()) {
      return prefs.getBool(storeKey);
    }
    if (_typeOf<V>() == _typeOf<DateTime>()) {
      final rawTime = prefs.getString(storeKey);
      if (rawTime == null) return null;
      return DateTime.parse(rawTime);
    }
    throw FlutterError('Unknow type "$V" cannot be read');
  }

  Future<bool> setEnum<E>(E enumaration) async {
    final String key = _enumKey(_typeOf<E>().toString());
    if (enumaration == null) {
      return await setValue<String>(null, key: key);
    }
    final split = enumaration.toString().split('.');
    final String value = split[1];
    return await setValue<String>(value, key: key);
  }

  Future<void> setSecureEnum<E>(E enumaration) async {
    final String key = _enumKey(_typeOf<E>().toString());
    if (enumaration == null) {
      return await setSecureValue<String>(null, key: key);
    }
    final split = enumaration.toString().split('.');
    final String value = split[1];
    return await setSecureValue<String>(value, key: key);
  }

  Future<void> setSecureValue<V>(V value, {@required String key}) async {
    assert(key != null);
    assert(key.isNotEmpty);

    final storeKey = _secureKey(key);

    final storage = new FlutterSecureStorage();
    if (value == null) return await storage.delete(key: storeKey);
    if (_typeOf<V>() == _typeOf<String>()) {
      return await storage.write(key: storeKey, value: value as String);
    }
    if (_typeOf<V>() == _typeOf<double>()) {
      final result = (value as double).toString();
      return await storage.write(key: storeKey, value: result);
    }
    if (_typeOf<V>() == _typeOf<int>()) {
      final result = (value as int).toString();
      return await storage.write(key: storeKey, value: result);
    }
    if (_typeOf<V>() == _typeOf<bool>()) {
      final result = (value as bool) ? '1' : '0';
      return await storage.write(key: storeKey, value: result);
    }
    if (_typeOf<V>() == _typeOf<DateTime>()) {
      final result = (value as DateTime).toUtc().toIso8601String();
      return await storage.write(key: storeKey, value: result);
    }

    throw FlutterError('Unknow type "$V" cannot be saved');
  }

  Future<bool> setValue<V>(V value, {@required String key}) async {
    assert(key != null);
    assert(key.isNotEmpty);
    final prefs = await _prefs;
    final storeKey = _storeKey(key);

    if (value == null) return await prefs.remove(storeKey);

    if (_typeOf<V>() == _typeOf<String>()) {
      return await prefs.setString(storeKey, value as String);
    }
    if (_typeOf<V>() == _typeOf<double>()) {
      return await prefs.setDouble(storeKey, value as double);
    }
    if (_typeOf<V>() == _typeOf<int>()) {
      return await prefs.setInt(storeKey, value as int);
    }
    if (_typeOf<V>() == _typeOf<bool>()) {
      return await prefs.setBool(storeKey, value as bool);
    }
    if (_typeOf<V>() == _typeOf<DateTime>()) {
      final result = (value as DateTime).toUtc().toIso8601String();
      return await prefs.setString(storeKey, result);
    }

    throw FlutterError('Unknow type "$V" cannot be saved');
  }

  String _enumKey(String key) => 'enumeration.$key';

  String _secureKey(String key) => '$keyPrefix.secure.$key';

  String _storeKey(String key) => '$keyPrefix.$key';
}
