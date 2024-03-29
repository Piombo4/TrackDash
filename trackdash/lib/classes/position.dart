class Position {
  final double latitude;
  final double longitude;

  Position(this.latitude, this.longitude);

  @override
  String toString() {
    return 'Position{latitude: $latitude, longitude: $longitude}';
  }
}
