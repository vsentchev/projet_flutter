import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_helper.dart';

void main() async {
  // Initialise la base de données
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();

  // Insère des données dans la base de données
  await DbHelper.insertWord('Houssam', 'mignon');
  await DbHelper.insertWord('Vassili', 'relou');

  // Récupère les données de la base de données
  final words = await DbHelper.getWords();

  // Affiche les données à l'écran
  runApp(
    MyApp(words: words),
  );
}

/*La classe MyApp hérite de la classe StatelessWidget. Elle sert à définir le thème de l'application et à définir la page d'accueil de l'application en appelant la classe MyHomePage avec les données récupérées de la base de données. */
class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> words;

  const MyApp({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(words: words),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> words;

  const MyHomePage({Key? key, required this.words}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*La classe MyHomePage hérite de la classe StatefulWidget. Elle contient l'état de la page d'accueil de l'application, qui peut être modifié à tout moment. Elle reçoit en paramètre les données récupérées de la base de données. */
class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _wordController = TextEditingController();
  List<Map<String, dynamic>> _words = [];

  @override
  void initState() {
    super.initState();
    _words = widget.words;
  }

  // Fonction pour récupérer les données de la base de données et les afficher dans l'interface
  Future<void> _getWords() async {
    final words = await DbHelper.getWords();
    setState(() {
      _words = words;
    });
  }

  // Fonction pour insérer un nouveau mot dans la base de données
  Future<void> _insertWord() async {
    final String username = _usernameController.text;
    final String word = _wordController.text;
    await DbHelper.insertWord(username, word);
    _usernameController.clear();
    _wordController.clear();
    _getWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BDD test'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(hintText: 'Little'),
                ),
                ElevatedButton(
                  onPressed: _insertWord,
                  child: Text('Insert'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DbHelper.deleteWords();
                    _getWords();
                  },
                  child: Text('Delete all words'),
                ),
              ],
            ),
          ),
          // La liste des mots récupérés depuis la base de données et affichés dans l'interface
          Expanded(
            child: ListView.builder(
              itemCount: _words.length,
              itemBuilder: (BuildContext context, int index) {
                final word = _words[index];
                return ListTile(
                  title: Text(word['word']),
                  subtitle: Text(word['username']),
                  trailing: Text(word['id']
                      .toString()), // afficher l'ID à droite de chaque note
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
