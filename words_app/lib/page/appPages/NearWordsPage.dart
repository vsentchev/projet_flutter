import 'package:flutter/material.dart';
import 'package:words_app/page/appPages/OwnedWordsPage.dart';
import 'package:words_app/Widgets/buildBottomNavigationBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


class NearWordsPage extends StatefulWidget {
  final String pseudoName;
  
  const NearWordsPage({
    Key? key,
    required this.pseudoName,
  }) : super(key: key);
 
  @override
  State<NearWordsPage> createState() => _NearWordsPageState();
}
 
class _NearWordsPageState extends State<NearWordsPage> {
  
  late Position _position; 
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OwnedWordsPage(
            pseudoName: widget.pseudoName
          );
          }));
        break;
      case 1:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserLocation();
  }

  // Fonction qui récupère la localisation de l'utilisateur
  Future<Position> getUserLocation() async {

    // Demande de permission au user
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Find LittleWords',
          )
      ),
      body:  Center(
        child: FutureBuilder<Position>(
            future: getUserLocation(),
            builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _position = snapshot.data!;
                  
                  return const Text('');
                // return Text(
                // 'Latitude: ${_position.latitude}, Longitude: ${_position.longitude}');
              }else{
                return CircularProgressIndicator(); // Si position null, indiquer que l'application est en train de récup la position
              }
            }
        )),

      bottomNavigationBar: buildBottomNavigationBar(_selectedIndex, _onItemTapped),
    );
  }
}