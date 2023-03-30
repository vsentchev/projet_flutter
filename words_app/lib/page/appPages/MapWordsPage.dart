import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; // Pour récupérer la position actuelle du user


class MapWordsPage extends StatefulWidget {

  // const MapWordsPage({Key? key, required this.initialNote}) : super(key: key);
  const MapWordsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapWordsPageState createState() => _MapWordsPageState();
}


class _MapWordsPageState extends State<MapWordsPage> {

  void _showMap() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
            content: SizedBox(
                width: double.maxFinite,
                // height: 400,
                child: MapFunction(latitude: 48.8534100, longitude: 2.3488000),
              ),
            );
      },
    );
  }
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  // Fonction pour récup localisation
  Future<dynamic>getLocation() async{

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold( body : SizedBox(
                width: double.maxFinite,
                // height: 400,
                child: MapFunction(latitude: 48.8534100, longitude: 2.3488000),
              ),
    
    // IconButton(
    //                 icon: const Icon(Icons.map_outlined),
    //                 onPressed: _showMap
    //               )
            );
    }
}

class MapFunction extends StatelessWidget {
  const MapFunction({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(latitude, longitude),
        zoom: 8,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    );
  }
}