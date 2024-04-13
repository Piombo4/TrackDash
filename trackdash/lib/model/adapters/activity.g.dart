import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import '../activity.dart';

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 1;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      fields[0] as double,
      fields[1] as DateTime,
      fields[2] as double,
      fields[3] as Duration,
      (fields[5] as List).cast<LatLng>(),
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.distance)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..writeByte(5)
      ..write(obj.route);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
