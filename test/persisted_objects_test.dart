// Copyright 2020 LTMM. All rights reserved.
// Uses of this source code is governed by 'The Unlicense' that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:persisted_objects/persisted_objects.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({"dog": "Mallory"});
  });

  final PersistedObject persistedObject = PersistedObject(keyPrefix: 'my.prefix');
  test('should read a value', () async {
    //when(persistedObject.getValue('dog')).thenAnswer((_) async => 'Mallory');
    final result = await persistedObject.getValue<String>('dog');
    expect(result, 'Mallory');
  });

  test('Should return null', () async {
    final result = await persistedObject.getValue<String>('cat');
    expect(result, null);
  });

  test('Full life of value', () async {
    final result = await persistedObject.setValue<String>('Fi', key: 'Dog');
    expect(result, true);
    final fetch = await persistedObject.getValue<String>('Dog');
    expect(fetch, 'Fi');
    final clear = await persistedObject.setValue<String>(null, key: 'Dog');
    expect(clear, true);
    final blank = await persistedObject.getValue<String>('Dog');
    expect(blank, null);
  });
}
