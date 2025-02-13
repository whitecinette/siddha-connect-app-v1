import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position?> getUserLocation() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          print("Location permissions are permanently denied.");
          return null;
        }
        if (permission == LocationPermission.denied) {
          print("Location permission denied.");
          return null;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("User Location: Lat ${position.latitude}, Long ${position.longitude}");
      return position;
    } catch (e) {
      print("Error getting user location: $e");
      return null;
    }
  }
}
