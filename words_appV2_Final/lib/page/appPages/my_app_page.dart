import 'package:flutter/material.dart';
import 'package:words_app/db_helper.dart';
import 'package:words_app/page/appPages/MapWordsPage.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Initialise la base de données
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();

  // Récupère les données de la base de données
  final words = await DbHelper.getWords();

  // Affiche les données à l'écran
  runApp(
    MyApp(
      words: words,
      username: 'Default Username',
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> words;
  final String username;

  const MyApp({Key? key, required this.words, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
        words: words,
        username: username,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> words;
  final String username;

  const MyHomePage({Key? key, required this.words, required this.username})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _wordController = TextEditingController();
  List<Map<String, dynamic>> _words = [];

  @override
  void initState() {
    super.initState();
    _words = widget.words;
  }

  Future<void> _getWords() async {
    final words = await DbHelper.getWords();
    setState(() {
      _words = words;
    });
  }

  Future<void> _insertWord() async {
    final String username = widget.username;
    final String word = _wordController.text;
    await DbHelper.insertWord(username, word);
    _wordController.clear();
    _getWords();
  }

  Future<void> _deleteWords() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete all the words ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await DbHelper.deleteWords();
      _getWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word list'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Username: ${widget.username}',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(hintText: 'little word'),
                ),
                ElevatedButton(
                  onPressed: _insertWord,
                  child: Text('Insert'),
                ),
                ElevatedButton(
                  onPressed: _deleteWords,
                  child: Text('Delete all words'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MapWordsPage(pseudoName: widget.username),
                      ),
                    );
                  },
                  child: Text('Map Words'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _words.length,
              itemBuilder: (BuildContext context, int index) {
                final word = _words[index];
                return ListTile(
                  title: Text(word['word']),
                  subtitle: Text(word['username']),
                  trailing: Text(word['id'].toString()),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete word'),
                          content: Text('Do you want to delete this word?'),
                          actions: [
                            ElevatedButton(
                              child: Text('release'),
                              onPressed: () async {
                                await DbHelper.deleteWord(word['id']);
                                Navigator.of(context).pop();
                                _getWords();
                              },
                            ),
                            ElevatedButton(
                              child: Text('Delete'),
                              onPressed: () async {
                                await DbHelper.deleteWord(word['id']);
                                Navigator.of(context).pop();
                                _getWords();
                              },
                            ),
                            ElevatedButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
