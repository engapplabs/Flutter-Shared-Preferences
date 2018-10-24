import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Shared Preferences'),
        ),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();
  final TextEditingController _controller = TextEditingController();
  List<String> listOne, listTwo;

  @override
  void initState() {
    super.initState();
    listOne = [];
    listTwo = [];
  }

  Future<Null> addString() async {
    final SharedPreferences prefs = await _sPrefs;
    listOne.add(_controller.text);
    prefs.setStringList('list', listOne);
    setState(() {
      _controller.text = '';
    });
  }

  Future<Null> clearStrings() async {
    final SharedPreferences prefs = await _sPrefs;
    prefs.clear();
    setState(() {
      listOne = [];
      listTwo = [];
    });
  }

  Future<Null> getStrings() async {
    final SharedPreferences prefs = await _sPrefs;
    listTwo = prefs.getStringList('list');
  }

  Future<Null> showKeys() async {
    final SharedPreferences prefs = await _sPrefs;
    print(prefs.getKeys());
  }

  @override
  Widget build(BuildContext context) {
    getStrings();
    return new Center(
        child: new ListView(
      children: <Widget>[
        new TextField(
          controller: _controller,
          decoration: new InputDecoration(hintText: 'Digite alguma coisa'),
        ),
        new RaisedButton(
          onPressed: () => addString(),
          child: new Text('Enviar'),
        ),
        new RaisedButton(
          onPressed: () => clearStrings(),
          child: new Text('Limpar'),
        ),
        new RaisedButton(
          onPressed: () => showKeys(),
          child: new Text('Mostrar chaves'),
        ),
        new Flex(
          direction: Axis.vertical,
          children: listTwo == null
              ? []
              : listTwo.map((String s) => Text(s)).toList(),
        ),
      ],
    ));
  }
}
