import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class RoadTax extends Equatable {
  const RoadTax({
    required this.uuid,
    required this.email,
    required this.makeAndModel,
    required this.numberPlate,
    required this.issuedDate,
    required this.expiryDate,
    required this.status,
    this.image,
  });

  /// Convert a map into a DriverLicense instance
  factory RoadTax.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      throw ArgumentError('Invalid date format for issuedDate/expiryDate');
    }

    return RoadTax(
      makeAndModel: map['makeAndModel'] as String,
      numberPlate: map['numberPlate'] as String,
      issuedDate: parseDate(map['issuedDate']),
      expiryDate: parseDate(map['expiryDate']),
      status: map['status'] as String,
      email: map['email'] as String,
      uuid: map['uuid'] as String,
      image: map['image'] as String?,
    );
  }

  final String makeAndModel;
  final String numberPlate;
  final DateTime issuedDate;
  final DateTime expiryDate;
  final String status;
  final String uuid;
  final String email;
  final String? image;

  /// Check if the driver's license is expired
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  /// Get the formatted expiry date in "yyyy-MM-dd" format
  String get formattedExpiryDate => DateFormat('yyyy-MM-dd').format(expiryDate);

  /// Get the formatted issued date in "yyyy-MM-dd" format
  String get formattedIssuedDate => DateFormat('yyyy-MM-dd').format(issuedDate);

  /// Check if the driver's license is expired
  String get currentStatus => isExpired ? 'Expired' : 'Active';

  /// Convert DriverLicense instance into a map
  Map<String, dynamic> toMap() {
    return {
      'makeAndModel': makeAndModel,
      'numberPlate': numberPlate,
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
      [makeAndModel, numberPlate, issuedDate, expiryDate, status, image, uuid, email];
}
