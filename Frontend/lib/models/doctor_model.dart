class Doctor {
  final String id;
  final String userId;
  final String specialization;
  final String licenseNumber;
  final int experience;
  final double consultationFee;
  final Address? address;
  final DoctorLocation? location;
  final double rating;
  final String? bio;
  final String? userName;
  final String? userPhone;
  final String? userEmail;
  final double? distance; // Distance from user in km

  Doctor({
    required this.id,
    required this.userId,
    required this.specialization,
    required this.licenseNumber,
    required this.experience,
    required this.consultationFee,
    this.address,
    this.location,
    this.rating = 0.0,
    this.bio,
    this.userName,
    this.userPhone,
    this.userEmail,
    this.distance,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? json['id'],
      userId: json['userId'] is Map ? json['userId']['_id'] : json['userId'],
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      experience: json['experience'],
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      location: json['location'] != null ? DoctorLocation.fromJson(json['location']) : null,
      rating: ((json['rating']?['average'] ?? 0).toDouble()),
      bio: json['bio'],
      userName: json['userId'] is Map ? json['userId']['name'] : null,
      userPhone: json['userId'] is Map ? json['userId']['phone'] : null,
      userEmail: json['userId'] is Map ? json['userId']['email'] : null,
      distance: json['distance']?.toDouble(),
    );
  }
}

class DoctorLocation {
  final String type;
  final List<double> coordinates; // [longitude, latitude]

  DoctorLocation({
    required this.type,
    required this.coordinates,
  });

  factory DoctorLocation.fromJson(Map<String, dynamic> json) {
    return DoctorLocation(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(json['coordinates'] ?? [0, 0]),
    );
  }

  double get latitude => coordinates.length > 1 ? coordinates[1] : 0;
  double get longitude => coordinates.length > 0 ? coordinates[0] : 0;
}

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? pincode;
  final String? country;

  Address({
    this.street,
    this.city,
    this.state,
    this.pincode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      country: json['country'],
    );
  }

  String get fullAddress {
    List<String> parts = [];
    if (street != null) parts.add(street!);
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (pincode != null) parts.add(pincode!);
    return parts.join(', ');
  }
}
