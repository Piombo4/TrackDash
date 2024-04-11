import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackdash/persistence/activity_DB.dart';
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
            name: "Distance",
            value: lastActivity.distance.toStringAsFixed(2)),
        Square(
            icon: Icons.timer,
            name: "Time",
            value: lastActivity.returnFormattedTime()),
        Square(
            icon: Icons.local_fire_department,
            name: "Calories",
            value: lastActivity.returnCalories()),
        Square(
            icon: Icons.show_chart,
            name: "Pace",
            value: lastActivity.returnPace())
      ];
    } else {
      squares = [
        Square(icon: Icons.route, name: "Distance", value: "-"),
        Square(icon: Icons.timer, name: "Time", value: "-"),
        Square(icon: Icons.local_fire_department, name: "Calories", value: "-"),
        Square(icon: Icons.show_chart, name: "Pace", value: "-"),
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
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: AutoSizeText(
                "TrackDash",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.double_arrow_sharp,
                size: 40,
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
                  borderRadius: BorderRadius.circular(20),
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
                        borderRadius: BorderRadius.circular(20))),
                onPressed: startRun,
                child: AutoSizeText(
                  "Start Run",
                  style: TextStyle(
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
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RunningPage(),
        ));
    if (result) {
      setState(() {
        fetchData();
      });
    }
  }
}
