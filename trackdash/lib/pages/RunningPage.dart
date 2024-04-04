import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:trackdash/classes/activity.dart';

import '../utils/dark_tile_builder.dart';

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
  int timeLeft = 5;
  late Timer timer;
  late Activity activity;
  late bool isRunning;
  late Future<Position> startPosition;
  Position? testPos;
  late Marker marker;
  late LocationPermission permission;
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.reduced,
    distanceFilter: 20,
  );
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initialize();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    positionStream.cancel();
    super.dispose();
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
      marker = Marker(
          child: Icon(
            Icons.location_on_sharp,
            color: Theme.of(context).colorScheme.primary,
            size: 40,
          ),
          width: 80,
          height: 80,
          rotate: false,
          point: LatLng(value.latitude, value.longitude));
      startCountdown();
      return value;
    });
  }

  void initialize() {
    startPosition = getStartPos();
    activity = Activity(0, DateTime.now(), 0, Duration.zero, []);
    isRunning = false;
    timer = Timer(Duration.zero, () {});
    mapController = MapController();
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
                      initialCenter: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      initialZoom: 19,
                    ),
                    children: [
                      TileLayer(
                        tileBuilder: darkTileBuilder,
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      MarkerLayer(
                        markers: [marker],
                      ),
                    ]),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      testPos != null
                          ? "${testPos!.latitude} + ${testPos!.longitude}"
                          : "NULL",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Visibility(
                    child: Text(
                      timeLeft.toString(),
                      style: TextStyle(fontSize: 100),
                    ),
                    visible: timeLeft > 0,
                    replacement: Positioned(
                      bottom: 0,
                      child: Container(
                          alignment: Alignment.topCenter,
                          height: height * 0.2,
                          width: width * 0.85,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: AutoSizeText(
                                  activity.returnFormattedTime(),
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color),
                                ),
                              ),
                              Expanded(
                                  child: Table(
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(
                                      child: AutoSizeText("5:57",
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Center(
                                      child: AutoSizeText("7.5",
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    )
                                  ]),
                                  TableRow(children: [
                                    Center(
                                      child: AutoSizeText("PACE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.color
                                                  ?.withOpacity(.75))),
                                    ),
                                    Center(
                                      child: AutoSizeText("DISTANCE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.color
                                                  ?.withOpacity(.75))),
                                    ),
                                  ]),
                                ],
                              )),
                            ],
                          )),
                    )),
                Positioned(
                    top: height * 0.715,
                    left: width * 0.67,
                    child: Center(
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {},
                        icon: Icon(
                          size: 25,
                          Icons.stop,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    )),
                Positioned(
                    top: height * 0.715,
                    left: width * 0.77,
                    child: Center(
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {},
                        icon: Icon(
                          size: 25,
                          Icons.pause,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    )),
                Positioned(
                    height: height * 0.06,
                    width: height * 0.06,
                    top: 20,
                    left: 20,
                    child: Center(
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          size: 25,
                          Icons.chevron_left,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ))
              ],
            ),
          );
        } else {
          print(snapshot.error);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  void startActivity() {
    timer = Timer.periodic(Duration(milliseconds: 500), _onTick);
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
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
