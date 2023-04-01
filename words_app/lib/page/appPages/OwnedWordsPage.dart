import 'package:flutter/material.dart';
import 'package:words_app/page/appPages/NearWordsPage.dart';
import 'package:words_app/Widgets/buildBottomNavigationBar.dart';



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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NearWordsPage(
              pseudoName: widget.pseudoName
            );
            }));
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'My LittleWords',
      )),
      body: ListView.builder(
              itemCount: 3,
              // itemCount: notes.length,
              itemBuilder: (context, index) {
                // var note = notes[index]!;
                // var note = "Notenote";
                return Card( // Envelopper chaque ListTile dans une Card
                  shape: RoundedRectangleBorder( // Ajouter une légère bordure à la Card
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  child: ListTile(
                    // title: Text(note.name.v ?? '',
                    title: const Center(child: Text('note.name.v ??',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),)),
                    subtitle: const Text("note.phone.v?"),
                    // subtitle: note.phone.v?.isNotEmpty ?? false
                    //     ? Text(LineSplitter.split(note.phone.v!).first)
                    //     : null,
                    onTap: () {
                      print("Tapped !!!!");
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return NotePage(
                      //     noteId: note.id.v,
                      //   );
                      // }));
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
            bottomNavigationBar: buildBottomNavigationBar(_selectedIndex, _onItemTapped),
          );
          
        }
}
