import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words_app/page/appPages/OwnedWordsPage.dart';



class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> {

  TextEditingController pseudoName = TextEditingController();

  // Fonction pour login
  void LoginAction() {
      if (pseudoName.text != "") {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OwnedWordsPage(
            pseudoName: pseudoName.text
          );
        }));
      }
    }

  @override
  Widget build(BuildContext context) {
    print("pseudoName = " + pseudoName.toString());
    // LoginAction();
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
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Connection',
                  style: TextStyle(fontSize: 20),
                )),
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
                    SharedPreferences pref =await SharedPreferences.getInstance();
                    pref.setString("pseudoName", pseudoName.text);
                    print(pref.getString('pseudoName'));
                    LoginAction();
                  },
                )
            )
          ],
        ));
  }
}