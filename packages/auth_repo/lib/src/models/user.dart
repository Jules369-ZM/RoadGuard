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

  /// Empty user instance
  static const empty = User(
    id: '',
    avatar: '',
    name: '',
    email: '',
    phone: '',
    metaData: '',
    role: '',
  );

  User copyWith({
    String? id,
    String? avatar,
    String? name,
    String? metaData,
    String? email,
    String? phone,
    String? role,
  }) {
    return User(
      id: id ?? this.id ?? '',
      avatar: avatar ?? this.avatar ?? '',
      name: name ?? this.name ?? '',
      metaData: metaData ?? this.metaData ?? '',
      email: email ?? this.email ?? '',
      phone: phone ?? this.phone ?? '',
      role: role ?? this.role ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  ///installing in db
  Map<String, dynamic> toJsonDb() => _$UserToJsonDb(this);

  @override
  String toString() {
    return '''$id, $avatar, $name, $metaData, $email, $phone,  $role''';
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
    };

User _$UserFromDbJson(Map<String, dynamic> json) => User(
      id: json['id'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      name: json['name'] as String? ?? '',
      metaData: json['metaData'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
