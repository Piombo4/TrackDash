import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  int get typeId => 100; // something

  @override
  void write(BinaryWriter writer, LatLng point) {
    writer
      ..write(point.latitude)
      ..write(point.latitude);
  }

  @override
  LatLng read(BinaryReader reader) {
    return LatLng(
      reader.read() as double,
      reader.read() as double,
    );
  }
}
