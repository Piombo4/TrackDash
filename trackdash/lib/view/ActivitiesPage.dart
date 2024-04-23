import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:trackdash/view/SingleActivityPage.dart';

import '../model/activity.dart';
import '../persistence/activity_DB.dart';
import '../widgets/back_button.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  var height;
  var width;

  final box = Hive.box('activityBox');
  late ActivityDB adb;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Center(
                        child: Text(
                          "History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ),
                    const Divider(),
                    SingleChildScrollView(
                      child: ListView.builder(
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: tileBuilder,
                        itemCount: adb.activityList.length,
                      ),
                    )
                  ],
                ),
                Positioned(
                  height: height * 0.06,
                  width: height * 0.06,
                  left: 0,
                  child: CustomBackButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget tileBuilder(BuildContext context, int index) {
    return Dismissible(
        onDismissed: (DismissDirection direction) {
          setState(() {
            adb.activityList.removeAt(index);
          });
          adb.updateDatabase();
        },
        key: UniqueKey(),
        child: ListTile(
          onTap: () {
            onActivityTap(adb.activityList.elementAt(index));
          },
          contentPadding: EdgeInsets.zero,
          title: Table(
            columnWidths: const {
              0: FractionColumnWidth(.2),
              1: FractionColumnWidth(.25),
              2: FractionColumnWidth(.2),
              3: FractionColumnWidth(.35),
            },
            children: [
              TableRow(children: [
                Center(
                  child: AutoSizeText(
                    maxLines: 1,
                    adb.activityList[index].getDistance() + " Km",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Center(
                  child: AutoSizeText(
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    DateFormat('dd-MM-yy').format(adb.activityList[index].data),
                  ),
                ),
                Center(
                  child: AutoSizeText(
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    adb.activityList[index].getTime(),
                    maxLines: 1,
                  ),
                ),
                const Center(
                  child: AutoSizeText(
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    "14.22 min/km",
                  ),
                )
              ])
            ],
          ),
          leading: const Icon(Icons.directions_run),
          trailing: const Icon(Icons.chevron_right),
        ));
  }

  void initialize() {
    adb = ActivityDB();
    if (box.get("ACTIVITYLIST") == null) {
      adb.createInitialData();
    } else {
      adb.loadData();
    }
  }

  void onActivityTap(Activity activity) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleActivityPage(
            activity: activity,
          ),
        ));
  }
}
