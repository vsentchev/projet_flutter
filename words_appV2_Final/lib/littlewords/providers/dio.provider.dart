import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:words_app/littlewords/beans/dto/word.dto.dart';
import 'package:words_app/littlewords/beans/dto/words.dto.dart';


// Dio : Requête http
final dioProvider = Provider<Dio>((ref) {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://backend.smallwords.samyn.ovh$ref',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  print('---------------');
  print(dio.toString());
  return dio;
});






void backIsUp() async {

  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://backend.smallwords.samyn.ovh/up',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  try {
    Response response = await dio.get(''); // Effectue une requête GET vers l'URL de base
    var json = jsonDecode(response.toString()); // Convertit la réponse en objet JSON
    print(json);
  } catch (error) {
    print(error.toString()); // Affiche l'erreur en cas d'échec de la requête
  }
}

// Permet de lister les petits mots proches de la position passée en paramètre.
Future<WordsDTO> getNearWords(double lat, double long) async {
  // GET https://backend.smallwords.samyn.ovh/word/around?latitude=Float&longitude=Float
  // Retour: {data: Set<WordDTO>}
  
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://backend.smallwords.samyn.ovh/word/around?latitude=$lat&longitude=$long',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // var json;
  // if (response.statusCode == 200) {
  //   json = jsonDecode(response.toString()); // Convertit la réponse en objet JSON
  // } else {
  //   throw Exception('Impossible d\'obtenir les données utilisateur');
  // }
  Response response = await dio.get(''); // Effectue une requête GET vers l'URL de base
  var json = jsonDecode(response.toString()); // Convertit la réponse en objet JSON


  final WordsDTO wordsDTO = WordsDTO.fromJson(json);
    if (wordsDTO.data == null) {
      return Future.value(wordsDTO);
    }

    return Future.value(wordsDTO);
  }
  // print(wordsDTO.data!.length.toString());
    // print(wordsDTO.data?[0].latitude);
    // print(wordsDTO.data?[1].latitude);

// Permet de recup un petit mot proche de la position passée en paramètre.
  Future<WordDTO> getWord(int uid, double lat, double long) async {

    final Dio dio = Dio(BaseOptions(
      baseUrl: 'https://backend.smallwords.samyn.ovh/word?uid=$uid&latitude=$lat&longitude=$long',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    Response response = await dio.get(''); // Effectue une requête GET vers l'URL de base
    var json = jsonDecode(response.toString()); // Convertit la réponse en objet JSON


    final WordDTO wordDTO = WordDTO.fromJson(json);
    // if (wordDTO.uid == null) {
    //   return Future.value(wordDTO);
    // }

    return Future.value(wordDTO);
  }


// Permet de déposer un petit mot sur la carte
void postWord(String content, String author, double lat, double long) async {
  // {content: String, author: String, latitude: Float, longitude: Float}
  // Retour : {data: WordDTO}
  
  // URL
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://backend.smallwords.samyn.ovh/word',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));


  // Création du dictionnaire qui sera transformé en json
  Map<String, dynamic> data = {
    "uid": Null, 
    "content": content,
    "author": author,
    "latitude": lat,
    "longitude": long
  };

  // POST
  Response response = await dio.post(
    '',
    data: data,
    options: Options(
      contentType: 'application/json',
    ),
  );
  if (response != Null) print(response.toString());

  // var json = jsonDecode(response.toString()); // Convertit la réponse en objet JSON
  // print("------");
  // print(json);

  // final WordDTO wordDTO = WordDTO.fromJson(json);

  //   // print(wordDTO.latitude);
  //   // print(wordDTO.longitude);
  //   // print(wordDTO.content);
  //   // print(wordDTO.author);
  //   return Future.value(wordDTO);
  }










// PUT https://backend.smallwords.samyn.ovh/word/{uid}
// Permet de rejeter un petit mot sur la carte
// {content: String, latitude: Float, longitude: Float}
// Retour : {data: Long}



// GET https://backend.smallwords.samyn.ovh/word?uid=Long&latitude=Float&longitude=Float

// Permet de ramasser un petit mot sur la carte
// Retour: {data: WordDTO}

