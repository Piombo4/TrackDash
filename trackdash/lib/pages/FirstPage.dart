import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackdash/classes/activity_DB.dart';
import 'package:trackdash/widgets/square.dart';

import '../classes/activity.dart';
import 'RunningPage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var height;
  var width;

  final box = Hive.box('activityBox');
  late ActivityDB adb = ActivityDB();

  Activity? lastActivity;

  List<Widget> squares = [
    Square(icon: Icons.local_fire_department, name: "Calories", value: "-"),
    Square(icon: Icons.route, name: "Distance", value: "-"),
    Square(icon: Icons.timer, name: "Time", value: "-"),
    Square(icon: Icons.show_chart, name: "Pace", value: "-"),
  ];

  @override
  void initState() {
    super.initState();

    if (box.get("ACTIVITYLIST") == null) {
      adb.createInitialData();
    } else {
      adb.loadData();
    }
    if (!adb.isDBEmpty()) {
      lastActivity = adb.activityList.last;
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
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RunningPage(),
        ));
  }
}
