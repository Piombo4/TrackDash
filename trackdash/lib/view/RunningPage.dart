import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:trackdash/model/activity.dart';
import 'package:trackdash/utils/dialog_helper.dart';
import 'package:trackdash/widgets/activity_display.dart';

import '../persistence/activity_DB.dart';
import '../widgets/custom_marker.dart';
import '../widgets/dark_tile_builder.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({Key? key}) : super(key: key);

  @override
  State<RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage>
    with AutomaticKeepAliveClientMixin {
  MapController mapController = MapController();
  var height;
  var width;

  final double DEFAULT_ZOOM = 19;
  final double MAX_ZOOM = 19.5;
  final int COUNTDOWN_START = 5;
  final int COUNTDOWN_RESUME = 3;
  final int DISTANCE_FILTER = 25;
  final LocationAccuracy LOCATION_ACCURACY = LocationAccuracy.medium;
  final box = Hive.box('activityBox');

  late Timer activityTimer;
  late Timer countdownTimer;
  late int timeLeft;
  late Activity activity;
  late bool isRunning;
  late Future<Position> startPosition;
  late Marker marker;
  late LocationPermission permission;
  late LocationSettings locationSettings;
  late ActivityDB adb;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initialize();
    }
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    activityTimer.cancel();
    positionStream?.cancel();
    super.dispose();
  }

  void initialize() {
    timeLeft = COUNTDOWN_START;
    startPosition = getStartPos();
    activity = Activity(0, DateTime.now(), -1, Duration.zero, []);
    isRunning = false;
    countdownTimer = Timer(Duration.zero, () {});
    activityTimer = Timer(Duration.zero, () {});
    mapController = MapController();
    locationSettings = LocationSettings(
      accuracy: LOCATION_ACCURACY,
      distanceFilter: DISTANCE_FILTER,
    );
    adb = ActivityDB();
    if (box.get("ACTIVITYLIST") == null) {
      adb.createInitialData();
    } else {
      adb.loadData();
    }
  }

  Future<Position> getStartPos() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.reduced)
        .then((value) {
      LatLng coords = LatLng(value.latitude, value.longitude);
      marker = Marker(
          child: CustomMarker(),
          width: 80,
          height: 80,
          rotate: false,
          point: coords);
      startCountdown();
      activity.route.add(coords);
      return value;
    });
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        setState(() {
          isRunning = true;
        });
        startActivity();
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    super.build(context);
    return Scaffold(
        body: FutureBuilder(
      future: startPosition,
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      maxZoom: MAX_ZOOM,
                      initialCenter: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      initialZoom: DEFAULT_ZOOM,
                    ),
                    children: [
                      TileLayer(
                        tileBuilder: darkTileBuilder,
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      PolylineLayer(
                        polylineCulling: true,
                        polylines: [
                          Polyline(
                            strokeWidth: 10,
                            points: activity.route,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [marker],
                      ),
                    ]),
                Visibility(
                    visible: timeLeft > 0,
                    replacement: ActivityDisplay(
                      isRunning: isRunning,
                      onResume: handleResume,
                      onPause: handlePause,
                      onStop: handleStop,
                      activity: activity,
                    ),
                    child: Text(
                      timeLeft.toString(),
                      style: TextStyle(fontSize: 100),
                    )),
                BackButton()
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  Widget BackButton() {
    return Positioned(
        height: height * 0.06,
        width: height * 0.06,
        top: 20,
        left: 20,
        child: Center(
          child: IconButton(
            style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () => customDialog(
                context,
                "Cancel activity",
                "Do you want to cancel the current activity? ",
                "Yes",
                cancelActivity,
                "No"),
            icon: Icon(
              size: 25,
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ));
  }

  void cancelActivity() {
    //To refactor
    Navigator.pop(context);
    Navigator.pop(context, false);
  }

  void startActivity() {
    activityTimer = Timer.periodic(Duration(milliseconds: 500), _onTick);
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      updatePosition(position);
    });
  }

  void _onTick(Timer timer) {
    if (isRunning) {
      setState(() {
        activity.time =
            Duration(milliseconds: 500 + activity.time.inMilliseconds);
      });
    }
  }

  void handlePause() {
    if (!isRunning) return;
    activityTimer.cancel();
    positionStream?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void handleResume() {
    if (isRunning) return;
    setState(() {
      timeLeft = COUNTDOWN_RESUME;
    });
    startCountdown();
  }

  void handleStop() {
    adb.activityList.add(activity);
    adb.updateDatabase();
    Navigator.pop(context, true);
  }

  void updatePosition(Position? pos) {
    if (pos != null) {
      LatLng coords = LatLng(pos.latitude, pos.longitude);
      if (activity.route.isNotEmpty) {
        activity.distance += (mp.SphericalUtil.computeDistanceBetween(
                mp.LatLng(pos.latitude, pos.longitude),
                mp.LatLng(activity.route.last.latitude,
                    activity.route.last.longitude)) /
            1000.0);
      }
      marker = Marker(
          child: CustomMarker(),
          width: 80,
          height: 80,
          rotate: false,
          point: coords);
      activity.route.add(coords);
      setState(() {
        mapController.move(coords, DEFAULT_ZOOM);
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
