class VenueModel {
  final int id;
  final String name;
  final String type; // indoor / outdoor
  final int capacity;
  final double pricePerHour;
  final String description;
  final String imageUrl;
  final int branchId;

  VenueModel({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.pricePerHour,
    required this.description,
    required this.imageUrl,
    required this.branchId,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      capacity: json['capacity'],
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      branchId: json['branch_id'],
    );
  }
}
