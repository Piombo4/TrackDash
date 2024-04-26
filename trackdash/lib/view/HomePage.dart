import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackdash/persistence/activity_DB.dart';
import 'package:trackdash/view/ActivitiesPage.dart';
import 'package:trackdash/widgets/square.dart';

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
          name: "Pace",
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
      body: Padding(
        padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              trailing:
                  IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              contentPadding: EdgeInsets.zero,
              title: AutoSizeText(
                "TrackDash",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            AutoSizeText(
              "Activity",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: height * 0.15,
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                )),
            AutoSizeText(
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
}
