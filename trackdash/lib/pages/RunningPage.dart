import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:trackdash/classes/activity.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({Key? key}) : super(key: key);

  @override
  State<RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage>
    with AutomaticKeepAliveClientMixin {
  late MapController controller;
  var height;
  var width;
  int timeLeft = 5;
  late Timer timer;
  late Activity activity;
  late bool isRunning;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      initialize();
    }
    startCountdown();
  }

  void initialize() {
    activity = Activity(0, DateTime.now(), 0, Duration(seconds: 1), []);
    isRunning = false;
    timer = Timer(Duration.zero, () {});
    controller = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          startActivity();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    super.build(context);
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          OSMFlutter(
              controller: controller,
              osmOption: OSMOption(
                userTrackingOption: UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                zoomOption: ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                markerOption: MarkerOption(
                    defaultMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )),
              )),
          Visibility(
              child: Center(
                  child: Text(
                timeLeft.toString(),
                style: TextStyle(fontSize: 100),
              )),
              visible: timeLeft > 0,
              replacement: Positioned(
                bottom: 0,
                child: Container(
                    height: height * 0.18,
                    width: width * 0.85,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            activity.returnFormattedTime(),
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Divider(),
                        ),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(children: [
                              Center(
                                child: Text("Avg Pace min/km",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                              Center(
                                child: Text("Km",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              )
                            ]),
                            TableRow(children: [
                              Center(
                                child: Text("5:57",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                              ),
                              Center(
                                child: Text("7.5",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                              )
                            ])
                          ],
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(20),
                    )),
              )),
          Positioned(
              height: height * 0.06,
              width: height * 0.06,
              top: 20,
              left: 20,
              child: Center(
                child: IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    ));
  }

  void startActivity() {
    timer = Timer.periodic(Duration(milliseconds: 500), _onTick);
    isRunning = true;
  }

  void _onTick(Timer timer) {
    /*if (sd.obj.currentD.inMinutes >= 999) {
      reset();
    }*/
    if (isRunning) {
      setState(() {
        activity.time =
            Duration(milliseconds: 500 + activity.time.inMilliseconds);
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
