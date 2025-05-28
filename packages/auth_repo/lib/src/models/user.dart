// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.phone,
    required this.metaData,
    required this.role,
    required this.fullPhone,
    required this.countryCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromDbJson(Map<String, dynamic> json) => _$UserFromDbJson(json);

  final String? id;
  final String? avatar;
  final String? name;
  final String? email;
  final String? phone;
  final String? metaData;
  final String? role;
  final String? fullPhone;
  final String? countryCode;

  /// Empty user instance
  static const empty = User(
    id: '',
    avatar: '',
    name: '',
    email: '',
    phone: '',
    metaData: '',
    role: '',
    fullPhone: '',
    countryCode: '',
  );

  User copyWith({
    String? id,
    String? avatar,
    String? name,
    String? metaData,
    String? email,
    String? phone,
    String? role,
    String? fullPhone,
    String? countryCode,
  }) {
    return User(
      id: id ?? this.id ?? '',
      avatar: avatar ?? this.avatar ?? '',
      name: name ?? this.name ?? '',
      metaData: metaData ?? this.metaData ?? '',
      email: email ?? this.email ?? '',
      phone: phone ?? this.phone ?? '',
      role: role ?? this.role ?? '',
      fullPhone: fullPhone ?? this.fullPhone ?? '',
      countryCode: countryCode ?? this.countryCode ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  ///installing in db
  Map<String, dynamic> toJsonDb() => _$UserToJsonDb(this);

  @override
  String toString() {
    return '''$id, $avatar, $name, $metaData, $email, $phone,  $role, $fullPhone, $countryCode''';
  }

  @override
  List<Object?> get props => [
        id,
        avatar,
        name,
        metaData,
        email,
        phone,
        role,
        fullPhone,
        countryCode,
      ];
}

Map<String, dynamic> _$UserToJsonDb(User instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'name': instance.name,
      'metaData': instance.metaData,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'fullPhone': instance.fullPhone,
      'countryCode': instance.countryCode,
    };

User _$UserFromDbJson(Map<String, dynamic> json) => User(
      id: json['id'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      name: json['name'] as String? ?? '',
      metaData: json['metaData'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
      fullPhone: json['fullPhone'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '',
    );
