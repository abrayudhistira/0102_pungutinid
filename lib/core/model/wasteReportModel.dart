class WasteReport {
  final String id;
  final String imageUrl;
  final String location;
  final String description;
  final DateTime reportedDate;

  WasteReport({
    required this.id,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.reportedDate,
  });

  factory WasteReport.fromJson(Map<String, dynamic> json) {
    final baseUrl = 'http://10.0.2.2:3001';
    final latitude = json['latitude'].toString();
    final longitude = json['longitude'].toString();
    final location = '$latitude, $longitude';
    final rawPhotoUrl = json['photo_url'] ?? '';
    final normalizedPath = rawPhotoUrl.replaceAll('\\', '/');

    return WasteReport(
      id: json['report_id'].toString(),
      // imageUrl: json['photo_url'] as String,
       imageUrl: '$baseUrl$normalizedPath',
      location: location,
      description: json['description'] as String,
      reportedDate: DateTime.parse(json['reported_at']),
    );
  }
}
