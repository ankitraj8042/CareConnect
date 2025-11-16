class Pharmacy {
  final String id;
  final String pharmacyName;
  final String licenseNumber;
  final Address address;
  final List<Medicine> inventory;
  final double rating;
  final PharmacyUser? userId; // Populated user data
  final List<dynamic> medicines; // Raw medicine data from backend

  Pharmacy({
    required this.id,
    required this.pharmacyName,
    required this.licenseNumber,
    required this.address,
    this.inventory = const [],
    this.rating = 0.0,
    this.userId,
    this.medicines = const [],
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['_id'] ?? json['id'],
      pharmacyName: json['pharmacyName'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      inventory: json['inventory'] != null
          ? (json['inventory'] as List).map((m) => Medicine.fromJson(m)).toList()
          : [],
      medicines: json['medicines'] ?? json['inventory'] ?? [],
      rating: (json['rating']?['average'] ?? 0).toDouble(),
      userId: json['userId'] != null ? PharmacyUser.fromJson(json['userId']) : null,
    );
  }
}

class PharmacyUser {
  final String name;
  final String phone;
  final String email;

  PharmacyUser({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory PharmacyUser.fromJson(Map<String, dynamic> json) {
    return PharmacyUser(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String zipCode; // Alias for pincode
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.country = 'India',
  }) : zipCode = pincode;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? json['zipCode'] ?? '',
      country: json['country'] ?? 'India',
    );
  }

  String get fullAddress => '$street, $city, $state - $pincode';
}

class Medicine {
  final String id;
  final String medicineName;
  final String? genericName;
  final String? manufacturer;
  final String category;
  final double price;
  final int stock;
  final DateTime expiryDate;
  final bool requiresPrescription;

  Medicine({
    required this.id,
    required this.medicineName,
    this.genericName,
    this.manufacturer,
    required this.category,
    required this.price,
    required this.stock,
    required this.expiryDate,
    this.requiresPrescription = true,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'] ?? json['id'] ?? '',
      medicineName: json['medicineName'],
      genericName: json['genericName'],
      manufacturer: json['manufacturer'],
      category: json['category'] ?? 'Other',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      expiryDate: DateTime.parse(json['expiryDate']),
      requiresPrescription: json['requiresPrescription'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'genericName': genericName,
      'manufacturer': manufacturer,
      'category': category,
      'price': price,
      'stock': stock,
      'expiryDate': expiryDate.toIso8601String(),
      'requiresPrescription': requiresPrescription,
    };
  }
}
