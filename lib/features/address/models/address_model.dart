/// A saved delivery address, including coordinates for map display.
class DeliveryAddress {
  final String id;
  final String label; // e.g. "Home", "Work"
  final String fullAddress;
  final double latitude;
  final double longitude;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['fullAddress'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}