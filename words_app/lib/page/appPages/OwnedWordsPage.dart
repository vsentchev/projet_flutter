import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words_app/page/appPages/NearWordsPage.dart';
import 'package:words_app/page/appPages/MapWordsPage.dart';
import 'package:words_app/Widgets/buildBottomNavigationBar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'My LittleWords',
      )),
      body: ListView.builder(
              itemCount: 3,
              // itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: const Center(child: Text('note.name.v ??',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),)),
                    subtitle: const Text("note.phone.v?"),
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
                                      child: const Text('Détruire le petit mot'),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("Rejeter pressed");
                                        },
                                      child: const Text('Rejeter le petit mot'),
                                  ),
                                ],
                              )
                            );
                          }
                        );
                      },
                    );
                  },
                  )
                );
              }
            ),
            // Bouton '+' d'ajout d'un nv mot
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                Consumer(
                  builder: (context, ref, child) {
                    return FloatingActionButton(
                      onPressed: () => showNewWordModal(context, ref),
                      tooltip: 'AddWord',
                      child: const Icon(Icons.add),
                    );
                  },
                ),
            ]
            ),
            bottomNavigationBar: buildBottomNavigationBar(_selectedIndex, _onItemTapped),
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
            return MapWordsPage(
              pseudoName: widget.pseudoName
            );
            }));
        break;
    }
  }
}
