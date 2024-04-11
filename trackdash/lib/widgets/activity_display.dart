import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../model/activity.dart';

class ActivityDisplay extends StatefulWidget {
  const ActivityDisplay(
      {Key? key,
      required this.activity,
      required this.isRunning,
      required this.onPause,
      required this.onResume,
      required this.onStop})
      : super(key: key);

  final Activity activity;
  final bool isRunning;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;

  @override
  State<ActivityDisplay> createState() => _ActivityDisplayState();
}

class _ActivityDisplayState extends State<ActivityDisplay> {
  var height;
  var width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Positioned(
        bottom: 0,
        child: Container(
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
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: AutoSizeText(
                          widget.activity.returnFormattedTime(),
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
                              child: AutoSizeText(widget.activity.returnPace(),
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
                              child: AutoSizeText(
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
              Positioned(
                  top: height * 0.045,
                  right: width * 0.18,
                  child: Center(child: StopButton())),
              Positioned(
                  top: height * 0.045,
                  right: width * 0.08,
                  child: Center(
                    child: Visibility(
                      visible: widget.isRunning,
                      replacement: ResumeButton(),
                      child: PauseButton(),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget StopButton() {
    return IconButton(
      style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: widget.onStop,
      icon: Icon(
        size: 25,
        Icons.stop,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget PauseButton() {
    return IconButton(
      style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: widget.onPause,
      icon: Icon(
        size: 25,
        Icons.pause,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget ResumeButton() {
    return IconButton(
      style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: widget.onResume,
      icon: Icon(
        size: 25,
        Icons.play_arrow,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
