import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final beatMappingCoordinatesProvider = StateProvider<Map<String, double>>((ref) => {});
final beatMappingAddressProvider = StateProvider<String>((ref) => "Fetching address...");

class BeatMappingLocationService {
  final WidgetRef ref;

  BeatMappingLocationService(this.ref);

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      ref.read(beatMappingCoordinatesProvider.notifier).state = {
        "latitude": position.latitude,
        "longitude": position.longitude
      };

      // Fetch the address from latitude & longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String formattedAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        ref.read(beatMappingAddressProvider.notifier).state = formattedAddress;
      }
    } catch (e) {
      ref.read(beatMappingAddressProvider.notifier).state = "Failed to fetch address.";
    }
  }
}
