import 'package:flutter/material.dart';
import 'package:persisted_objects/persisted_objects.dart';

void main() {
  runApp(MyApp());
}

enum Dogs { Fi, Mallory }
enum Cats { Journey, BFC }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool pushed = false;
  int bestAge = 7;
  PersistedObject persistedObject = PersistedObject(keyPrefix: 'com.icodeforyou.objects');
  DateTime timeMarker = DateTime.now();

  Widget _scaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${DateTime.now().toLocal()}',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text('Have you pushed the button?', style: Theme.of(context).textTheme.headline5),
            Text(
              pushed ? '😈' : '😇',
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          timeMarker = DateTime.now();
          if (!pushed) {
            _setter();
            _secureSetter();
          } else {
            _getter();
            _secureGetter();
            ++bestAge;
          }
          setState(() {
            pushed = !pushed;
          });
        },
        tooltip: 'Push',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Future<void> _setter() async {
    bool flag;
    flag = await persistedObject.setValue<String>('Fe', key: 'BestDog');
    debugPrint('Flag $flag');
    flag = await persistedObject.setValue<int>(bestAge, key: 'BestDogAge');
    debugPrint('Flag $flag');
    flag = await persistedObject.setValue<double>(101.0, key: 'BestScore');
    debugPrint('Flag $flag');
    flag = await persistedObject.setValue<bool>(true, key: 'SweetGirl');
    debugPrint('Flag $flag');
    flag = await persistedObject.setValue<DateTime>(timeMarker, key: 'BestTime');
    debugPrint('Flag $flag');
    flag = await persistedObject.setEnum(Dogs.Fi);
    debugPrint('enumeration: $flag');
  }

  Future<void> _secureSetter() async {
    await persistedObject.setSecureValue<String>('Mallory', key: 'OhMallory');
    await persistedObject.setSecureValue<int>(bestAge, key: 'tooOld');
    await persistedObject.setSecureValue<double>(101.0, key: 'failureRate');
    await persistedObject.setSecureValue<bool>(false, key: 'SweetGirl');
    await persistedObject.setSecureValue<DateTime>(timeMarker, key: 'CurrentTime');
  }

  Future<void> _secureGetter() async {
    dynamic val = await persistedObject.getSecureValue<String>('OhMallory');
    debugPrint('$val');
    val = await persistedObject.getSecureValue<int>('tooOld');
    debugPrint('$val');
    val = await persistedObject.getSecureValue<int>('NullTooOld');
    debugPrint('null:$val');
    val = await persistedObject.getSecureValue<double>('failureRate');
    debugPrint('$val');
    val = await persistedObject.getSecureValue<bool>('SweetGirl');
    debugPrint('$val');
    val = await persistedObject.getSecureValue<DateTime>('CurrentTime');
    debugPrint('$val');
    val = await persistedObject.duration(
      key: 'CurrentTime',
      isSecure: true,
      compareTime: DateTime.now().add(Duration(minutes: 9)).toUtc(),
    );
    debugPrint('Secure Duration: $val');
  }

  Future<void> _getter() async {
    dynamic val = await persistedObject.getValue<String>('BestDog');
    debugPrint('$val');
    val = await persistedObject.getValue<int>('BestDogAge');
    debugPrint('$val');
    val = await persistedObject.getValue<double>('BestScore');
    debugPrint('$val');
    val = await persistedObject.getValue<bool>('SweetGirl');
    debugPrint('$val');
    val = await persistedObject.getValue<DateTime>('BestTime');
    debugPrint('BestTime:$val');
    val = await persistedObject.duration(
      key: 'BestTime',
      compareTime: DateTime.now().add(Duration(minutes: 5)).toUtc(),
    );
    debugPrint('Duration: $val');
    val = await persistedObject.duration(
      key: 'BestTimeIsFake',
      compareTime: DateTime.now().add(Duration(minutes: 5)).toUtc(),
    );
    debugPrint('null Duration: $val');
    val = await persistedObject.getValue<DateTime>('BestNullTime');
    debugPrint('null>$val');
    val = await persistedObject.getEnum<Dogs>(Dogs.values);
    debugPrint('enum: value = ${val.toString} $val');
    val = await persistedObject.getEnum<Cats>(Cats.values);
    debugPrint('null enum: value = ${val.toString} $val');
  }
}
