class Location {
  final int id;
  final int providerId;
  final String name;
  final String type;
  final String? address;
  final double? latitude;
  final double? longitude;

  Location({
    required this.id,
    required this.providerId,
    required this.name,
    required this.type,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['location_id'],
      providerId: json['provider_id'],
      name: json['name'],
      type: json['type'],
      address: json['address'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "location_id": id,
        "provider_id": providerId,
        "name": name,
        "type": type,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}