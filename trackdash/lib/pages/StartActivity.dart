import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class StartActivity extends StatefulWidget {
  const StartActivity({Key? key}) : super(key: key);

  @override
  State<StartActivity> createState() => _StartActivityState();
}

class _StartActivityState extends State<StartActivity>
    with AutomaticKeepAliveClientMixin {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: 500,
                  height: 550,
                  child: OSMFlutter(
                    controller: controller,
                    osmOption: OSMOption(
                      markerOption: MarkerOption(
                        defaultMarker: MarkerIcon(
                          icon: Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 56,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Flexible(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 8,
                  minimumSize: Size(400, 60),
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {},
              child: Text(
                "Start Run",
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ))
            /*Text(
              "TrackDash",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 200),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 8,
                  minimumSize: Size(250, 250),
                  backgroundColor: Colors.greenAccent,
                  shape: CircleBorder()),
              onPressed: () {},
              child: Text(
                "Start Run",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            )*/
          ],
        ),
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
