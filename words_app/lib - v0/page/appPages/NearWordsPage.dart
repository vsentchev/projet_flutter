import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:words_app/littlewords/beans/dto/word.dto.dart';
import 'package:words_app/littlewords/beans/dto/words.dto.dart';
import 'package:words_app/littlewords/providers/dio.provider.dart';

class NearWordsPage extends StatefulWidget {
  final String pseudoName;

  const NearWordsPage({
    Key? key,
    required this.pseudoName,
  }) : super(key: key);

  @override
  _NearWordsPageState createState() => _NearWordsPageState();
}

class _NearWordsPageState extends State<NearWordsPage> {
  // Localisation de départ de la map
  LatLng _center = LatLng(50.952000, 1.853800);

  // Liste provisoire de coordonnée
  List<LatLng> coordinates = [];

  List<int> uid = [];

  // Liste dynamique des markers
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    // getUserLocation();
  }

  // Fonction qui récupère la localisation de l'utilisateur
  Future<void> getUserLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    print(position);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  // Fonction qui récupère les petits mots proche de la position de l'utilisateur
  Future<void> getNearLittleWords() async {
    print("---------- getNearLittleWords --------------");

    List<int> uidCopie = [...uid];
    List<LatLng> coordinatesCopie = [...coordinates];

    print(_center.latitude.toString());
    print(_center.longitude.toString());
    // WordsDTO wordsDTO = await getNearWords(_center.latitude,_center.longitude);
    WordsDTO wordsDTO = await getNearWords(50.952000, 1.853800);
    print(wordsDTO.toJson());
    print("Taille : ");
    print(wordsDTO.data!.length);

    // for (int i = 0; i < wordsDTO.data!.length; i++) {
    //   if (wordsDTO.data?[i].latitude != null && wordsDTO.data?[i].longitude != null){
    //     uidCopie.add(wordsDTO.data![i].uid!);
    //     coordinatesCopie.add(LatLng(wordsDTO.data![i].latitude, wordsDTO.data![i].longitude));
    //   }
    // }
    if (wordsDTO.data != null && wordsDTO.data!.isNotEmpty) {
  for (int i = 0; i < wordsDTO.data!.length; i++) {
    if (wordsDTO.data?[i].latitude != null && wordsDTO.data?[i].longitude != null){
      uidCopie.add(wordsDTO.data![i].uid!);
      coordinatesCopie.add(LatLng(wordsDTO.data![i].latitude, wordsDTO.data![i].longitude));
    }
  }
}

    setState(() {
      uid = uidCopie;
      coordinates = coordinatesCopie;
    });
  }
// Fonction qui affiche tous les markers avec leur mot. La fonction gère également la suppression des markers lorsque tap dessus
Future<void> displayMarkersWords(List<LatLng> coordinates) async {
  List<Marker> markers = [];

  for (int i = 0; i < coordinates.length; i++) {
    markers.add(
      Marker(
        point: coordinates[i],
        builder: (ctx) => GestureDetector(
          onTap: () async {
            WordDTO wordDTO = await getWord(uid[i], coordinates[i].latitude, coordinates[i].longitude);
            print(wordDTO.uid);
            print(wordDTO.content);
            print(wordDTO.author);
            setState(() {
              _markers.removeAt(i);
              coordinates.removeAt(i);
            });
          },
          child: Column(
            children: const [
              Icon(
                Icons.location_on,
                size: 50.0,
                color: Colors.red
                ),
            ],
          ),
        ),
      ),
    );
  }

  setState(() {
    _markers = markers;
  });
}

// Fonction qui construit la map
Future<Widget> buildMap() async {
  _markers = [];
  coordinates = [];
  uid = [];

  await getUserLocation();
  print("Avant :");
  print(coordinates);
  await getNearLittleWords();
  print("Après :");
  print(coordinates);

  await displayMarkersWords(coordinates);

  return FlutterMap(
    options: MapOptions(
      center: LatLng(50.952000, 1.853800),
      zoom: 11.0,
    ),
    layers: [
      // Pour afficher la carte
      TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
      ),
      MarkerLayerOptions(
        markers: _markers,
      ),
    ],
  );
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Geo test'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder(
              future: buildMap(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}



// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Geo test'),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: FutureBuilder(
//               future: buildMap(),
//               builder: (context, AsyncSnapshot<Widget> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.connectionState == ConnectionState.done) {
//                   return snapshot.data!;
//                 } else {
//                   return Container(child : Text("dkdl"));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}











// Version avant debug gpt

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:words_app/littlewords/beans/dto/word.dto.dart';
// import 'package:words_app/littlewords/beans/dto/words.dto.dart';
// import 'package:words_app/littlewords/providers/dio.provider.dart';


// class NearWordsPage extends StatefulWidget {
//   final String pseudoName;
  
//   const NearWordsPage({
//     Key? key,
//     required this.pseudoName,
//   }) : super(key: key);
  
//   @override
//   _NearWordsPageState createState() => _NearWordsPageState();
// }

// class _NearWordsPageState extends State<NearWordsPage> {
//   // Localisation de départ de la map
//   LatLng _center = LatLng(50.952000, 1.853800);

//   // Liste provisoire de coordonnée
//   List<LatLng> coordinates = [];

//   List<int> uid = [];

//   // Liste dynamique des markers
//   List<Marker> _markers = [];

//   @override
//   void initState() {
//     super.initState();
//     // getUserLocation();
//   }

//   // Fonction qui récupère la localisation de l'utilisateur
//   Stream<Future> getUserLocation() async* {

//     await Geolocator.checkPermission();
//     await Geolocator.requestPermission();

//     Position position =
//         await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//     print(position);
//     setState(() {
//       _center = LatLng(position.latitude, position.longitude);
//     });
//   }


//   // Fonction qui récupère les petits mots proche de la position de l'utilisateur
//   void getNearLittleWords() async {
//     print("---------- getNearLittleWords --------------");

//     List<int> uidCopie = uid;
//     List<LatLng> coordinatesCopie = coordinates;

//     print(_center.latitude.toString());
//     print(_center.longitude.toString());
//     WordsDTO wordsDTO = await getNearWords(_center.latitude,_center.longitude);
//     print(wordsDTO.toJson());
//     print("Taille : ");
//     print(wordsDTO.data!.length);

//     for (int i = 0; i < wordsDTO.data!.length; i++) {
//       if (wordsDTO.data?[i].latitude != null && wordsDTO.data?[i].longitude != null){
//         uidCopie.add(wordsDTO.data![i].uid!);
//         coordinatesCopie.add(LatLng(wordsDTO.data![i].latitude, wordsDTO.data![i].longitude));
//       }
//     }

//     setState(() {
//       uid = uidCopie;
//       coordinates = coordinatesCopie;
//     });

    
//   }

//   // Fonction qui affiche tous les markers avec leur mot. La fonction gère également la suppression des markers lorsque tap dessus
//   void displayMarkersWords() {
//     _markers = [];

//     for (int i = 0; i < coordinates.length; i++) {
//       _markers.add(
//         Marker(
//           // width: 80.0,
//           // height: 80.0,
//           point: coordinates[i],
//           builder: (ctx) => GestureDetector(
//             onTap: () {
//               setState(() async {
//                 WordDTO wordDTO = await getWord(uid[i], coordinates[i].latitude, coordinates[i].longitude);
//                 print(wordDTO.uid);
//                 print(wordDTO.content);
//                 print(wordDTO.author);
//                 _markers.removeAt(i);
//                 coordinates.removeAt(i);
//               });
//             },
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   size: 50.0,
//                   color: Colors.red,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     setState(() {
//       _markers = [..._markers];
//     });
//   }

//   // Fonction qui construit la map
//   Widget buildMap() {
//     _markers = [];  coordinates = []; uid = [];

//     // getUserLocation();
//     print("Avant :");
//     print(coordinates);
//     getNearLittleWords();
//     print("Après :");
//     print(coordinates);
    
//     displayMarkersWords();

//     return FlutterMap(
//       options: MapOptions(
//         center: _center,
//         zoom: 11.0,
//       ),
//       layers: [
//         // Pour afficher la carte
//         TileLayerOptions(
//           urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//           subdomains: ['a', 'b', 'c'],
//         ),
//         MarkerLayerOptions(
//           markers: _markers,
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Geo test'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: buildMap(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }











// Version qui att tranquillement la loca 

// import 'package:flutter/material.dart';
// import 'package:words_app/page/appPages/OwnedWordsPage.dart';
// import 'package:words_app/Widgets/buildBottomNavigationBar.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:words_app/littlewords/providers/dio.provider.dart';



// class NearWordsPage extends StatefulWidget {
//   final String pseudoName;
  
//   const NearWordsPage({
//     Key? key,
//     required this.pseudoName,
//   }) : super(key: key);
 
//   @override
//   State<NearWordsPage> createState() => _NearWordsPageState();
// }
 
// class _NearWordsPageState extends State<NearWordsPage> {
  
//   late Position _position; 
//   int _selectedIndex = 0;

//   LatLng _center = LatLng(0, 0);

//   // Liste provisoire de coordonnée
//   List<LatLng> coordinates = [
//     LatLng(48.858093, 2.294694), // Paris, France
//     LatLng(51.507351, -0.127758), // London, UK
//     LatLng(40.712776, -74.005974), // New York City, USA
//     LatLng(-33.865143, 151.209900), // Sydney, Australia
//     LatLng(-1.292066, 36.821946), // Nairobi, Kenya
//     LatLng(33.969341, -6.927573), // Marrakech, Morocco
//   ];

//   // Liste dynamique des markers
//   List<Marker> _markers = [];

//   // Variable locale pour stocker la liste des marqueurs
//   List<Marker> _displayedMarkers = [];

//   // Clé unique pour les widgets qui dépendent de la liste _markers
//   final _markerKey = GlobalKey();




//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//           return OwnedWordsPage(
//             pseudoName: widget.pseudoName
//           );
//           }));
//         break;
//       case 1:
//         break;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // getUserLocation();
//   }

//   // Fonction qui récupère la localisation de l'utilisateur
//   Future<Position> getUserLocation() async {

//     // Demande de permission au user
//     await Geolocator.checkPermission();
//     await Geolocator.requestPermission();

//     final Position position =
//         await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

//     // setState(() {
//     //   _center = LatLng(position.latitude, position.longitude);
//     // });

//     return position;
//   }

// // Fonction qui affiche tous les markers avec leur mot. La fonction gère également la suppression des markers lorsque tap dessus
//   void displayMarkersWords() {
//     _markers = [];

//     for (int i = 0; i < coordinates.length; i++) {
//       // for (LatLng coord in coordinates) {
//     // for (int i = coordinates.length - 1; i >= 0; i--) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: coordinates[i],
//           builder: (ctx) => GestureDetector(
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: const Text("Capturé !")),
//               );

//               setState(() {
//                 _markers.removeAt(i);
//                 coordinates.removeAt(i);
//               });
//             },
//             child: Icon(
//                   Icons.location_on,
//                   size: 50.0,
//                   color: Colors.red,
//                 ),
//             ),
//           ),
//         );
//     }

//     setState(() {
//       _markers = [..._markers];
//     });
//   }

//   // Fonction qui construit la map
//   Widget buildMap() {
//     _markers = [];

//     print('Latitude: ${_position.latitude}, Longitude: ${_position.longitude}');
    
//     displayMarkersWords();

//     return FlutterMap(
//       options: MapOptions(
//         center: _center,
//         zoom: 3.0,
//       ),
//       layers: [
//         // Pour afficher la carte
//         TileLayerOptions(
//           urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//           subdomains: ['a', 'b', 'c'],
//         ),
//         MarkerLayerOptions(
//           markers: _markers,
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text(
//             'Find LittleWords',
//           )
//       ),
//       body:  Center(
//         child: FutureBuilder<Position>(
//             future: getUserLocation(),
//             builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   _position = snapshot.data!;
                  
//                   return Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: buildMap(),
//                         )]
//                       )
//                   );
//               }else{
//                 return CircularProgressIndicator(); // Si position null, indiquer que l'application est en train de récup la position
//               }
//             }
//         )),

//       bottomNavigationBar: buildBottomNavigationBar(_selectedIndex, _onItemTapped),
//     );
//   }
// }





// //   @override
// //   Widget build(BuildContext context) {
// //     postWord("Nouveau mot", "encoreLudo", 0.000007, 0.000002);
// //     print("|_____|");
// //     getNearWords(0,0);