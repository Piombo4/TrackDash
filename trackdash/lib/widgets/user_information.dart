import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInformation extends StatefulWidget {
  UserInformation(
      {Key? key,
      required this.onGenderChanged,
      required this.onAgeChanged,
      required this.onHeightChanged,
      required this.onWeightChanged,
      required this.onPressed,
      this.gender,
      this.age,
      this.height,
      this.weight})
      : super(key: key);

  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<int?> onAgeChanged;
  final ValueChanged<double?> onHeightChanged;
  final ValueChanged<double?> onWeightChanged;
  final VoidCallback onPressed;
  final gender;
  final age;
  final height;
  final weight;

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  List<String> list = <String>['Male', 'Female'];

  TextEditingController heightCtrl = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();

  late String gender;
  final ageKey = GlobalKey<FormState>();
  final weightKey = GlobalKey<FormState>();
  final heightKey = GlobalKey<FormState>();
  var height;
  var width;

  @override
  void initState() {
    super.initState();
    heightCtrl = TextEditingController(
        text: widget.height == null ? null : "${widget.height}");
    ageCtrl = TextEditingController(
        text: widget.age == null ? null : "${widget.age}");
    weightCtrl = TextEditingController(
        text: widget.weight == null ? null : "${widget.weight}");

    gender = widget.gender ?? list.first;
  }

  @override
  void dispose() {
    weightCtrl.dispose();
    heightCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                textAlign: TextAlign.center,
                "To calculate the calories, please enter the following information."),
            SizedBox(
              height: 20,
            ),
            Table(
              columnWidths: {0: FlexColumnWidth(0.7), 1: FlexColumnWidth(0.3)},
              children: [
                TableRow(children: [
                  Text("Gender"),
                  DropdownButton<String>(
                    isExpanded: true,
                    iconSize: 0,
                    isDense: true,
                    padding: EdgeInsets.zero,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color),
                    value: gender,
                    icon: const Icon(Icons.arrow_downward),
                    underline: Container(
                      color: Theme.of(context).colorScheme.primary,
                      height: 2,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        gender = value!;
                      });
                      widget.onGenderChanged(value);
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ]),
                TableRow(children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
                TableRow(children: [
                  Text("Height (cm)"),
                  Form(
                      key: heightKey,
                      child: TextFormField(
                          onChanged: (value) {
                            widget.onHeightChanged(double.tryParse(value));
                          },
                          decoration: InputDecoration(isDense: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                          ],
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: heightCtrl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Invalid value";
                            }
                            try {
                              double.parse(value);
                            } on FormatException {
                              return "Invalid value";
                            }
                            return null;
                          }))
                ]),
                TableRow(children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
                TableRow(children: [
                  Text("Weight (kg)"),
                  Form(
                      key: weightKey,
                      child: TextFormField(
                        onChanged: (value) {
                          widget.onWeightChanged(double.tryParse(value));
                        },
                        decoration: InputDecoration(isDense: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                        ],
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: weightCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Invalid value";
                          }
                          try {
                            double.parse(value);
                          } on FormatException {
                            return "Invalid value";
                          }
                          return null;
                        },
                      ))
                ]),
                TableRow(children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
                TableRow(children: [
                  Text("Age"),
                  Form(
                      key: ageKey,
                      child: TextFormField(
                        onChanged: (value) {
                          widget.onAgeChanged(int.tryParse(value));
                        },
                        maxLength: 2,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        decoration: InputDecoration(isDense: true),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: ageCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Invalid value";
                          }
                          return null;
                        },
                      ))
                ]),
                TableRow(children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              ],
            ),
            SizedBox(
                width: width * 0.2,
                child: IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: onButtonPress,
                  icon: Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void onButtonPress() {
    if (heightKey.currentState!.validate() &&
        weightKey.currentState!.validate() &&
        ageKey.currentState!.validate()) {
      widget.onPressed.call();
    }
  }
}
