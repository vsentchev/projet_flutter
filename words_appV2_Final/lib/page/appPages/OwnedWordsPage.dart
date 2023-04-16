import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words_app/page/appPages/NearWordsPage.dart';
import 'package:words_app/page/appPages/MapWordsPage.dart';
import 'package:words_app/Widgets/buildBottomNavigationBar.dart';
import 'package:words_app/db_helper.dart';
import '../../littlewords/providers/newWord.dart';

class OwnedWordsPage extends StatefulWidget {
  final String pseudoName;

  const OwnedWordsPage({
    Key? key,
    required this.pseudoName,
  }) : super(key: key);

  @override
  State<OwnedWordsPage> createState() => _OwnedWordsPageState();
}

class _OwnedWordsPageState extends State<OwnedWordsPage> {
  int _selectedIndex = 0;

  Future<List<Map<String, dynamic>>> _getWords() async {
    return await DbHelper.getWords();
  }

  @override
  Widget build(BuildContext context) {
    DbHelper.initDb(); // Initialisez la base de données ici
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My LittleWords',
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getWords(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Map<String, dynamic>> words = snapshot.data!;
            return ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> word = words[index];
                return Card(
                  child: ListTile(
                    title: Center(
                      child: Text(
                        word['username'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(word['word']),
                    onTap: () {
                      print("Tapped !!!!");
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        print("Détruire pressed");
                                      },
                                      child:
                                          const Text('Détruire le petit mot'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        print("Rejeter pressed");
                                      },
                                      child: const Text('Rejeter le petit mot'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Bouton '+' d'ajout d'un nv mot
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Consumer(
          builder: (context, ref, child) {
            return FloatingActionButton(
              onPressed: () => showNewWordModal(context, ref),
              tooltip: 'AddWord',
              child: const Icon(Icons.add),
            );
          },
        ),
      ]),
      bottomNavigationBar:
          buildBottomNavigationBar(_selectedIndex, _onItemTapped),
    );
  }

  // Permet de changer de page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MapWordsPage(pseudoName: widget.pseudoName);
        }));
        break;
    }
  }
}
