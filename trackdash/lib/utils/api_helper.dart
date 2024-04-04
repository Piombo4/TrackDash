import 'package:geolocator/geolocator.dart';

typedef PositionCallback = void Function();

Future<Position> getPos(PositionCallback? onPositionReceived) async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.reduced)
      .then((value) {
    onPositionReceived?.call(); // Richiama la funzione passata come parametro
    return value;
  });
}
