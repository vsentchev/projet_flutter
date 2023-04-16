import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words_app/page/appPages/my_app_page.dart';
import 'package:words_app/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> words;

  const HomePage({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController pseudoName = TextEditingController();

    // Fonction pour login
    void loginAction() {
      if (pseudoName.text != "") {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MyApp(words: words, username: pseudoName.text);
        }));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'WordsApp',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Connection',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: pseudoName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: pseudoName.text.isEmpty ? 'Pseudo' : pseudoName.text,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                loginAction();
              },
            ),
          )
        ],
      ),
    );
  }
}
