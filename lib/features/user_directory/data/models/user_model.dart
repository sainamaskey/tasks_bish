/// Model representing a geographic location
class GeoLocation {
  final double lat;
  final double lng;

  const GeoLocation({required this.lat, required this.lng});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      lat: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['lng']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat.toString(),
    'lng': lng.toString(),
  };
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoLocation geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String? ?? '',
      suite: json['suite'] as String? ?? '',
      city: json['city'] as String? ?? '',
      zipcode: json['zipcode'] as String? ?? '',
      geo: GeoLocation.fromJson(json['geo'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'suite': suite,
    'city': city,
    'zipcode': zipcode,
    'geo': geo.toJson(),
  };

  String get fullAddress => '$street, $suite, $city $zipcode';
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String? ?? '',
      catchPhrase: json['catchPhrase'] as String? ?? '',
      bs: json['bs'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'catchPhrase': catchPhrase,
    'bs': bs,
  };
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: Address.fromJson(json['address'] as Map<String, dynamic>? ?? {}),
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      company: Company.fromJson(json['company'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'address': address.toJson(),
    'phone': phone,
    'website': website,
    'company': company.toJson(),
  };

  GeoLocation get location => address.geo;
}
