import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:words_app/littlewords/beans/dto/word.dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words_app/littlewords/providers/dio.provider.dart';
import 'package:words_app/littlewords/providers/getUserPosition.dart';

// Sert à afficher un ModalBottomSheet avec le form d'un new word
void showNewWordModal(BuildContext context, WidgetRef ref) {
  print("Wsh : showNewWordModal");
  showModalBottomSheet(
    context: context,
    builder: (_) => newWord(context, ref),
  );
}

// Permet au user de post un nv mot
Widget newWord(BuildContext context, WidgetRef ref) {
  print("Wsh : newWord");
  final content = TextEditingController();

  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: content,
          ),
        ),
      ),
      FloatingActionButton(
        onPressed: () {
          sendNewWord(content, ref);
          Navigator.of(context).pop();
        },
        child: const Icon(
            Icons.send,
            size: 40.0,
            // color: Colors.black,
          ),
      ),
    ],
  );
}


// Recup la position du user et post le message dans l'API
void sendNewWord (TextEditingController content, WidgetRef ref) async {
  print("Wsh : sendNewWord");
  final prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('username');
  final String name;
    if (username is String) name = username; 
    else name = "";


  Future<LatLng> position = getUserLocation();

  final dio = ref.read(dioProvider);

  position.then((latLng) async {
    print("Position = " + latLng.toString());
    print("Username = " + name);
    print("Content = " + content.text);


    WordDTO futureNewWord = WordDTO(null, name, content.text, 50.9525, 1.85385);
    var resultat = await dio.post('/word', data: futureNewWord);
    print(resultat.toString());

    // if (username is String) {
    //   // postWord(content.text, username, latLng.latitude, latLng.longitude);

    //   // postWord(content.text, username, 50.9525, 1.85385);
    // } else {
    //   // postWord(content.text, "", latLng.latitude, latLng.longitude);
    // }
  });
}
