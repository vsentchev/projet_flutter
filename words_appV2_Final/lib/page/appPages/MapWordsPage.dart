import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:words_app/littlewords/providers/getUserPosition.dart';
import 'package:words_app/page/appPages/OwnedWordsPage.dart';

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
  List<String> texts = [
    "Paris",
    "London",
    "New York City",
    "Sydney",
    "Nairobi",
    "Marrakech",
    "Lagos",
    "Pretoria",
    "Ouagadougou"
  ];

  // Liste provisoire de texte
  List<int> index = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  // Liste des markers
  List<Marker> _markers = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future<LatLng> position = getUserLocation();
    position.then((latLng) async {
      _center = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map words'),
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

  // Permet de changer de page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OwnedWordsPage(pseudoName: widget.pseudoName);
        }));
        break;
      case 1:
        break;
    }
  }
}
