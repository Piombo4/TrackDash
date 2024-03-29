import 'package:trackdash/classes/position.dart';

class Activity {
  double km;
  DateTime data;
  double calories;
  Duration time;
  List<Position> route;

  Activity(this.km, this.data, this.calories, this.time, this.route);

  @override
  String toString() {
    return 'Activity{km: $km, calories: $calories, time: $time, route: $route}';
  }

  String returnFormattedTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(time.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(time.inSeconds.remainder(60).abs());
    return "${twoDigits(time.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
