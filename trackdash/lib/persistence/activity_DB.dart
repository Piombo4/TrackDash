import 'package:hive/hive.dart';
import 'package:trackdash/model/activity.dart';

class ActivityDB {
  List<Activity> activityList = [];
  var _myBox = Hive.box('activityBox');

  //run this method if first time opening the app
  void createInitialData() {
    activityList = [];
  }

  //load data from db
  void loadData() {
    activityList = _myBox.get("ACTIVITYLIST").cast<Activity>();
  }

  void updateDatabase() {
    _myBox.put("ACTIVITYLIST", activityList);
  }

  bool isDBEmpty() {
    return activityList.isEmpty;
  }
}
