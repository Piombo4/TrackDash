import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:trackdash/model/activity.dart';

import '../persistence/settings.dart';
import '../widgets/back_button.dart';
import '../widgets/dark_tile_builder.dart';

class SingleActivityPage extends StatefulWidget {
  const SingleActivityPage({Key? key, required this.activity})
      : super(key: key);

  final Activity activity;

  @override
  State<SingleActivityPage> createState() => _SingleActivityPageState();
}

class _SingleActivityPageState extends State<SingleActivityPage> {
  var height;
  var width;

  late final LatLng viewPoint;
  late final LatLng startPoint;
  late final LatLng endPoint;
  @override
  void initState() {
    super.initState();
    print(widget.activity.route);
    viewPoint = widget.activity.route.last;
    endPoint = widget.activity.route.last;
    startPoint = widget.activity.route.first;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          DateFormat('dd MMMM yyyy')
                                  .format(widget.activity.data) +
                              " at " +
                              DateFormat('HH:mm').format(widget.activity.data),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: height * 0.5,
                    child: FlutterMap(
                        options: MapOptions(
                          maxZoom: Settings.MAX_ZOOM,
                          initialCenter:
                              LatLng(viewPoint.latitude, viewPoint.longitude),
                          initialZoom: Settings.REVIEW_ZOOM,
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
                                strokeWidth: 8,
                                points: widget.activity.route,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              point: startPoint,
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.directions_run,
                                  color: Colors.black,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Marker(
                              point: endPoint,
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.sports_score,
                                  color: Colors.black,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ])
                        ]),
                  ),
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
          ),
        ),
      ),
    );
  }
}
