class UserData {
  String gender;
  int? age;
  double? height;
  double? weight;

  UserData(this.gender, this.age, this.height, this.weight);

  factory UserData.defaultUser() {
    return UserData("Male", null, null, null);
  }
}
