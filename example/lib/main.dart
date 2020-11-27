import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xterm.dart demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Terminal terminal;
  Socket socket;

  @override
  void initState() {
    super.initState();
    setUpTerminal();
  }

  void setUpTerminal() async {
    terminal = Terminal(onInput: (input) => socket.write(input));
    socket = await Socket.connect('127.0.0.1', 63159);
    print(
      'connected to cmdr-pty via'
      ': ${socket.remoteAddress.address}:${socket.remotePort}');

    await for (var data in socket) {
      var decodedString = utf8.decoder.convert(data);
      terminal.write(decodedString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TerminalView(terminal: terminal),
      ),
    );
  }
}
