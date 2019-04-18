import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_io/flutter_card_io.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _data = <String, dynamic>{};

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _scanCard() async {
    Map<String, dynamic> details;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      details = await FlutterCardIo.scanCard(<String, dynamic>{
        'requireExpiry': true,
        'scanExpiry': true,
        'requireCVV': true,
        'requirePostalCode': true,
        'restrictPostalCodeToNumericOnly': true,
        'requireCardHolderName': true,
        'scanInstructions': 'Hola! Fit the card within the box',
      });

    } on PlatformException {
      print('Failed');
      return;
    }

    if (details == null) {
      print('Canceled');
      return;
    }

    if (!mounted) return;

    setState(() {
      _data = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CardIO sample app'),
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: _data.keys.map((String key) {
                return Text(_data[key].toString());
              }).toList(),
            ),
            Container(
              margin: const EdgeInsets.all(30.0),
              child: Center(
                child: RaisedButton(
                  child: const Text('Scan'),
                  onPressed: _scanCard,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
