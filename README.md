# persisted_objects

Flutter package store/read preferences or secure store of Strings, int, double, bool, DateTime

## Getting Started

```Dart
class PersistedObject {
  PersistedObject({@required String keyPrefix});

  Future<Duration> duration({@required String key, bool isSecure = false, DateTime compareTime}) async {}

  Future<dynamic> getEnum<E>(List<E> values) async {}

  Future<dynamic> getSecureEnum<E>(List<E> values) async {}

  Future<dynamic> getSecureValue<V>(String key) async {}

  Future<dynamic> getValue<V>(String key) async {}

  Future<bool> setEnum<E>(E enumaration) async {}

  Future<void> setSecureEnum<E>(E enumaration) async {}

  Future<void> setSecureValue<V>(V value, {@required String key}) async {}

  Future<bool> setValue<V>(V value, {@required String key}) async {}
```

## Usage

The `keyPrefix` should be a string like a reverse domain (eg. 'com.example.object') to avoid name collision and to try and insure that shared secure store names don't conflict. The `keyPrefix` is prepended to each `key` name along with internal obfuscation text for collion avoidence and security.

The supported types for `V` and `E` are:
- String
- bool
- double
- int
- DateTime

*NOTE:* Any types beyond those listed, like a custom class name, will throw an exception.

*NOTE:* To remove from device `set` methods will value of `null`.

## Summary

There is a helper method `duration` which will return the `Duration` between a stored time, secured or not, and provided time. This is to help in use cases when information between app invocation, or the elapsed duration since a password was set, etc.

If `null` is passed for `compareTime:`, then the current `DateTime.now()` will be used.

## Conclusion

Be Kind To Each Other
