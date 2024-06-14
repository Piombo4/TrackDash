import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackdash/model/user_data.dart';
import 'package:trackdash/persistence/activity_DB.dart';
import 'package:trackdash/view/ActivitiesPage.dart';
import 'package:trackdash/widgets/square.dart';
import 'package:trackdash/widgets/user_information.dart';

import '../model/activity.dart';
import 'RunningPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var height;
  var width;

  final box = Hive.box('activityBox');
  late ActivityDB adb = ActivityDB();

  late Activity lastActivity;

  List<Widget> squares = [];
  late UserData userData;
  List<String> list = <String>['Distance', 'Calories'];
  late String type;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    if (box.get("ACTIVITYLIST") == null) {
      adb.createInitialData();
    } else {
      adb.loadData();
    }
    fetchData();
    type = list.first;
    userData = UserData.defaultUser();
    if (box.get("USERDATA") != null) {
      userData = box.get("USERDATA");
    }
  }

  void fetchData() {
    if (!adb.isDBEmpty()) {
      lastActivity = adb.activityList.last;

      squares = [
        Square(
          icon: Icons.route,
          name: "Distance (Km)",
          value: lastActivity.getDistance(),
          onTap: openActivities,
        ),
        Square(
          icon: Icons.timer,
          name: "Time",
          value: lastActivity.getTime(),
          onTap: openActivities,
        ),
        Square(
          icon: Icons.local_fire_department,
          name: "Calories",
          value: lastActivity.getCalories(),
          onTap: openActivities,
        ),
        Square(
          icon: Icons.show_chart,
          name: "Pace",
          value: lastActivity.getPace(),
          onTap: openActivities,
        )
      ];
    } else {
      squares = [
        Square(
          icon: Icons.route,
          name: "Distance (Km)",
          value: "-",
          onTap: openActivities,
        ),
        Square(
          icon: Icons.timer,
          name: "Time",
          value: "-",
          onTap: openActivities,
        ),
        Square(
          icon: Icons.local_fire_department,
          name: "Calories",
          value: "-",
          onTap: openActivities,
        ),
        Square(
          icon: Icons.show_chart,
          name: "Pace (min/km)",
          value: "-",
          onTap: openActivities,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              trailing: IconButton(
                  onPressed: openSettings, icon: const Icon(Icons.settings)),
              contentPadding: EdgeInsets.zero,
              title: const AutoSizeText(
                "TrackDash",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(children: [
              const AutoSizeText(
                "Weekly activity",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              DropdownButton<String>(
                iconSize: 0,
                isDense: true,
                padding: EdgeInsets.zero,
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color),
                value: type,
                icon: const Icon(Icons.arrow_downward),
                underline: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 2,
                ),
                onChanged: (String? value) {
                  setState(() {
                    type = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              )
            ]),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: height * 0.15,
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const AutoSizeText(
              "Last Run",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            GridView(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: squares,
            ),
            Expanded(
                child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 8,
                    minimumSize: Size(width, height * 0.08),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: startRun,
                child: AutoSizeText(
                  "Start Run",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void startRun() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RunningPage(),
        )).then((value) {
      if (value is bool && value) {
        setState(() {
          fetchData();
        });
      }
    });
  }

  void openActivities() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ActivitiesPage(),
        )).then((value) {
      setState(() {
        fetchData();
      });
    });
  }

  Future<void> openSettings() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: UserInformation(
              height: userData.height,
              weight: userData.weight,
              age: userData.age,
              gender: userData.gender,
              onPressed: () {
                Navigator.of(context).pop();
                box.put("USERDATA", userData);
              },
              onGenderChanged: (String? value) {
                if (value != null) {
                  userData.gender = value;
                }
              },
              onAgeChanged: (int? value) {
                if (value != null) {
                  userData.age = value;
                }
              },
              onHeightChanged: (double? value) {
                if (value != null) {
                  userData.height = value;
                }
              },
              onWeightChanged: (double? value) {
                if (value != null) {
                  userData.weight = value;
                }
              },
            ),
          );
        });
  }
}
