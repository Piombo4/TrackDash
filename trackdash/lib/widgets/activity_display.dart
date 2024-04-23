import 'package:flutter/material.dart';
import 'package:trackdash/widgets/slidable_widget.dart';

import '../model/activity.dart';

class ActivityDisplay extends StatefulWidget {
  const ActivityDisplay(
      {Key? key,
      required this.activity,
      required this.isRunning,
      required this.isLocked,
      required this.onPause,
      required this.onResume,
      required this.onStop,
      required this.onLock,
      required this.onUnlock});

  final Activity activity;
  final bool isRunning;
  final bool isLocked;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;
  final VoidCallback onLock;
  final VoidCallback onUnlock;

  @override
  State<ActivityDisplay> createState() => _ActivityDisplayState();
}

class _ActivityDisplayState extends State<ActivityDisplay> {
  var height;
  var width;

  @override
  void initState() {
    super.initState();
    print(widget.isLocked);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Positioned(
        bottom: 0,
        child: SizedBox(
          width: width * 0.85,
          height: height * 0.3,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  height: height * 0.2,
                  width: width * 0.85,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          widget.activity.getTime(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                              child: Text(widget.activity.getPace(),
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
                              child: Text(
                                  widget.activity.distance > 0
                                      ? widget.activity.distance
                                          .toStringAsFixed(2)
                                      : "-",
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
                              child: Text("PACE",
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
                              child: Text("DISTANCE",
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
              Visibility(
                  replacement: Positioned(
                      top: height * 0.045,
                      right: width * 0.08,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Row(
                          children: [
                            Button(Icons.lock_rounded, widget.onLock),
                            SizedBox(
                              width: width * 0.37,
                            ),
                            Button(Icons.stop, widget.onStop),
                            SizedBox(
                              width: 5,
                            ),
                            Visibility(
                              visible: widget.isRunning,
                              replacement:
                                  Button(Icons.play_arrow, widget.onResume),
                              child: Button(Icons.pause, widget.onPause),
                            ),
                          ],
                        ),
                      )),
                  visible: widget.isLocked,
                  child: Positioned(
                    top: height * 0.015,
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.85,
                      child: SlideAction(
                        sliderButtonIconPadding: 11,
                        sliderRotate: false,
                        elevation: 0,
                        text: "Unlock > > >",
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .color!
                                .withOpacity(0.6)),
                        outerColor: Theme.of(context).colorScheme.secondary,
                        innerColor: Theme.of(context).colorScheme.primary,
                        onSubmit: widget.onUnlock,
                        borderRadius: 10,
                        sliderButtonIcon: Icon(
                          Icons.lock_open_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget Button(IconData icon, Function()? onPressed) {
    return IconButton(
      style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      onPressed: onPressed,
      icon: Icon(
        size: 25,
        icon,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
