import 'package:geolocator/geolocator.dart';

class LocationService {
  // Static const radius (misal: 500 meter)
  static const double allowedRadiusInMeters = 500;

  static Future<bool> isWithinAllowedRadius({
    required double targetLat,
    required double targetLng,
  }) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLat,
      targetLng,
    );

    // Return true jika jarak <= allowedRadiusInMeters
    return distanceInMeters <= allowedRadiusInMeters;
  }
}
