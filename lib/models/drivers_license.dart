import 'package:equatable/equatable.dart';

class DriverLicense extends Equatable {
  const DriverLicense( {
    required this.uuid,
    required this.email,
    required this.name,
    required this.licenseNumber,
    required this.issuedDate,
    required this.expiryDate,
    required this.status,
    this.image,
  });

  /// Convert a map into a DriverLicense instance
  factory DriverLicense.fromMap(Map<String, dynamic> map) {
    return DriverLicense(
      name: map['name'] as String,
      licenseNumber: map['licenseNumber'] as String,
      issuedDate: DateTime.parse(map['issuedDate'] as String),
      expiryDate: DateTime.parse(map['expiryDate'] as String),
      status: map['status'] as String,
      email: map['email'] as String,
      uuid: map['uuid'] as String,
      image: map['image'] as String?,
    );
  }

  final String name;
  final String licenseNumber;
  final DateTime issuedDate;
  final DateTime expiryDate;
  final String status;
  final String uuid;
  final String email;
  final String? image;

  /// Check if the driver's license is expired
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  /// Check if the driver's license is expired
  String get currentStatus => isExpired ? 'Expired' : 'Active';

  /// Convert DriverLicense instance into a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'licenseNumber': licenseNumber,
      'issuedDate': issuedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'status': status,
      'email': email,
      'uuid': uuid,
      'image': image,
    };
  }

  @override
  List<Object?> get props =>
      [name, licenseNumber, issuedDate, expiryDate, status, image, uuid, email];
}
