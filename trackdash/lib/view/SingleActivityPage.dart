import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackdash/model/activity.dart';

import '../widgets/back_button.dart';

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

  @override
  void initState() {
    super.initState();
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
                          DateFormat('dd MMMM yyyy')
                                  .format(widget.activity.data) +
                              " at " +
                              DateFormat('HH:mm').format(widget.activity.data),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  Container()
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
