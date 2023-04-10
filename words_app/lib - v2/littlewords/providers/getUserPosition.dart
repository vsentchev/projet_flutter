import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

  // Fonction qui récupère la localisation de l'utilisateur
  Future<LatLng> getUserLocation() async {

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    return LatLng(position.latitude, position.longitude);
  }