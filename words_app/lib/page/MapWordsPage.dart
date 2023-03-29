import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWordsPage extends StatefulWidget {
  const MapWordsPage({Key? key}) : super(key: key);

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
  ];

  // Liste provisoire de texte
  List<String> texts = ["Wsh", "Yucca", "Pure/honey", "Grèce"];


  // Liste dynamique des markers
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    getUserLocation();
    displayMarkersWords();
  }

  // Fonction qui récupère la localisation de l'utilisateur
  void getUserLocation() async {

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    // Ajoute la localisation de l'utilisateur à la liste des coordonnées
    // Fonctionnalité utile mais pas comme ça. A modifier plus tard.
    coordinates.add(LatLng(position.latitude, position.longitude));
    // print(position);

    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  // Fonction qui affiche tous les markers avec leur mot. La fonction gère également la suppression des markers lorsque tap dessus
  void displayMarkersWords() {

    for (int i = 0; i < coordinates.length; i++) {
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
                _markers.removeAt(i);
                // coordinates.removeAt(i);
                // texts.removeAt(i);
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
      _markers = [..._markers]; // create a new list with the same elements
    });
  }

  // Fonction qui construit la map
  Widget buildMap() {

    return FlutterMap(
      options: MapOptions(
        center: _center,
        zoom: 3.0,
      ),
      layers: [
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