import 'package:flutter/material.dart';
import 'package:words_app/page/homePage/HomePage.dart';

void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  static const String _title = 'WordsApp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme : ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const HomePage(),
      ),
    );
  }
}