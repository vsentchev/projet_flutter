import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWordsPage extends StatefulWidget {
  final String pseudoName;
  
  const MapWordsPage({
    Key? key,
    required this.pseudoName,
  }) : super(key: key);
  
  @override
  _MapWordsPageState createState() => _MapWordsPageState();
}

class _MapWordsPageState extends State<MapWordsPage> {
  // Localisation de départ de la map
  LatLng _center = LatLng(0, 0);

  // Liste provisoire de coordonnée
  List<LatLng> coordinates = [
    LatLng(48.858093, 2.294694), // Paris, France
    LatLng(51.507351, -0.127758), // London, UK
    LatLng(40.712776, -74.005974), // New York City, USA
    LatLng(-33.865143, 151.209900), // Sydney, Australia
    LatLng(-1.292066, 36.821946), // Nairobi, Kenya
    LatLng(33.969341, -6.927573), // Marrakech, Morocco
    LatLng(6.465422, 3.406448), // Lagos, Nigeria
    LatLng(-25.746111, 28.188056), // Pretoria, South Africa
    LatLng(12.365660, -1.533881), // Ouagadougou, Burkina Faso
  ];

  // Liste provisoire de texte
  List<String> texts = ["Paris", "London", "New York City", "Sydney", "Nairobi", "Marrakech", "Lagos", "Pretoria", "Ouagadougou"];

  // Liste provisoire de texte
  List<int> index = [0,1,2,3,4,5,6,7,8];

  // Liste dynamique des markers
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  // Fonction qui récupère la localisation de l'utilisateur
  void getUserLocation() async {

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  // Fonction qui affiche tous les markers avec leur mot. La fonction gère également la suppression des markers lorsque tap dessus
  void displayMarkersWords() {
    _markers = [];

    // int indexMarkerTaped;
    int indexMarkerTaped = -1;
    for (int i = 0; i < coordinates.length; i++) {
    // for (int i = coordinates.length - 1; i >= 0; i--) {
      _markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: coordinates[i],
          builder: (ctx) => GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(texts[i])),
              );

              setState(() {

                // if (indexMarkerTaped < 0) {
                //   indexMarkerTaped = 0;
                // }
                indexMarkerTaped = i;
                _markers.removeAt(indexMarkerTaped);
                index.removeAt(indexMarkerTaped);
                coordinates.removeAt(indexMarkerTaped);
                texts.removeAt(indexMarkerTaped);
              });
            },
            child: Column(
              children: [
                Icon(
                  Icons.location_on,
                  size: 50.0,
                  color: Colors.red,
                ),
                Text(texts[i]),
              ],
            ),
          ),
        ),
      );
    }

    setState(() {
      _markers = [..._markers];
    });
  }

  // Fonction qui construit la map
  Widget buildMap() {
    _markers = [];
    
    displayMarkersWords();

    return FlutterMap(
      options: MapOptions(
        center: _center,
        zoom: 3.0,
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
        title: Text('Geo test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildMap(),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';

// class MapWordsPage extends StatefulWidget {
//   const MapWordsPage({Key? key}) : super(key: key);

//   @override
//   _MapWordsPageState createState() => _MapWordsPageState();
// }

// class _MapWordsPageState extends State<MapWordsPage> {
//   // Localisation de départ de la map
//   LatLng _center = LatLng(0, 0);

//   // Liste provisoire de coordonnée
//   List<LatLng> coordinates = [
//     LatLng(48.858093, 2.294694), // Paris, France
//     LatLng(51.507351, -0.127758), // London, UK
//     LatLng(40.712776, -74.005974), // New York City, USA
//     LatLng(-33.865143, 151.209900), // Sydney, Australia
//     LatLng(-1.292066, 36.821946), // Nairobi, Kenya
//     LatLng(33.969341, -6.927573), // Marrakech, Morocco
//     LatLng(6.465422, 3.406448), // Lagos, Nigeria
//     LatLng(-25.746111, 28.188056), // Pretoria, South Africa
//     LatLng(12.365660, -1.533881), // Ouagadougou, Burkina Faso
//   ];

//   // Liste provisoire de texte
//   List<String> texts = ["Paris", "London", "New York City", "Sydney", "Nairobi", "Marrakech", "Lagos", "Pretoria", "Ouagadougou"];

//   // Liste provisoire de texte
//   List<int> index = [0,1,2,3,4,5,6,7,8];

//   // Liste dynamique des markers
//   List<Marker> _markers = [];

//   @override
//   void initState() {
//     super.initState();
//     getUserLocation();
//   }

//   // Fonction qui récupère la localisation de l'utilisateur
//   void getUserLocation() async {

//     await Geolocator.checkPermission();
//     await Geolocator.requestPermission();

//     Position position =
//         await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

//     // Ajoute la localisation de l'utilisateur à la liste des coordonnées
//     // Fonctionnalité utile mais pas comme ça. A modifier plus tard.
//     // coordinates.add(LatLng(position.latitude, position.longitude));
//     // texts.add("MaPosition");
//     // print(position);

//     setState(() {
//       _center = LatLng(position.latitude, position.longitude);
//     });
//   }

//   // Fonction qui affiche tous les markers avec leur mot. La fonction gère également la suppression des markers lorsque tap dessus
//   void displayMarkersWords() {
//     _markers = [];

//     // int indexMarkerTaped;
//     int indexMarkerTaped = -1;
//     for (int i = 0; i < coordinates.length; i++) {
//     // for (int i = coordinates.length - 1; i >= 0; i--) {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: coordinates[i],
//           builder: (ctx) => GestureDetector(
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(texts[i])),
//               );

//               setState(() {
//                 // print("i = " +  i.toString());
//                 print("_____________________________");
//                 print("Je recherche " + i.toString() + " dans " + index.toString() + "\nCe qui correspond à : " + texts.toString());
//                 indexMarkerTaped = index.indexOf(i);
//                 print("C'est l'indice : " + indexMarkerTaped.toString());

//                 if (indexMarkerTaped < 0) {
//                   indexMarkerTaped = 0;
//                 }
//                 print("wshhh = " + indexMarkerTaped.toString());

//                 print("_markers = " + _markers.toString());
//                 print("index = " + index.toString());
//                 print("coordinates = " + coordinates.toString());
//                 print("texts = " + texts.toString());
//                 print("_____________________________");
//                 _markers.removeAt(indexMarkerTaped);
//                 index.removeAt(indexMarkerTaped);
//                 // print("wshhh = " + indexMarkerTaped.toString());
//                 coordinates.removeAt(indexMarkerTaped);
//                 texts.removeAt(indexMarkerTaped);

//                 print("_markers = " + _markers.toString());
//                 print("index = " + index.toString());
//                 print("coordinates = " + coordinates.toString());
//                 print("texts = " + texts.toString());
//                 print("_____________________________");
//               });
//             },
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.location_on,
//                   size: 50.0,
//                   color: Colors.red,
//                 ),
//                 Text(texts[i]),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     setState(() {
//       _markers = [..._markers];
//       // _markers = [..._markers];
//     });
//   }

//   // Fonction qui construit la map
//   Widget buildMap() {
//     _markers = [];
    
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