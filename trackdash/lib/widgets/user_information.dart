import 'package:flutter/cupertino.dart';

class UserInformation extends StatefulWidget {
  UserInformation(
      {Key? key,
      required this.onGenderChanged,
      required this.onAgeChanged,
      required this.onHeightChanged,
      required this.onWeightChanged})
      : super(key: key);

  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onAgeChanged;
  final ValueChanged<String?> onHeightChanged;
  final ValueChanged<String?> onWeightChanged;

  @override
  State<UserInformation> createState() => _userInformationState();
}

class _userInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
    );
  }
}
