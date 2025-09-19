class LocationModel {
  int? id;
  String name;
  double latitude;
  double longitude;

  LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) => LocationModel(
        id: map['id'],
        name: map['name'],
        latitude: map['latitude'],
        longitude: map['longitude'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
