import 'package:flutter/material.dart';

class StartActivity extends StatefulWidget {
  const StartActivity({Key? key}) : super(key: key);

  @override
  State<StartActivity> createState() => _StartActivityState();
}

class _StartActivityState extends State<StartActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
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
            )
          ],
        ),
      ),
    ));
  }
}
