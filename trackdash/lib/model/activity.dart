import 'package:latlong2/latlong.dart';

class Activity {
  double distance;

  DateTime data;

  double calories;

  Duration time;

  List<LatLng> route;

  Activity(this.distance, this.data, this.calories, this.time, this.route);

  String returnFormattedTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(time.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(time.inSeconds.remainder(60).abs());
    return "${twoDigits(time.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String returnPace() {
    var result = "-";
    if (distance > 1) {
      result = (time.inMinutes / distance).toStringAsFixed(2);
    }
    return result;
  }

  String returnCalories() {
    var result = "-";
    if (calories > 0) {
      result = calories.toStringAsFixed(2);
    }
    return result;
  }
}
