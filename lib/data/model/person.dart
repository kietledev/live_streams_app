import 'package:equatable/equatable.dart';

class Person extends Equatable {
  const Person({
    required this.id,
    this.role,
    this.email,
    this.firstName,
    this.lastName,
    this.birthDay,
    this.address,
    this.photo,
    this.iosToken,
    this.androidToken,
    this.verify,
    this.verifyRequest,
  });

  final String id;
  final int? role;
  final String? email;

  final String? firstName;
  final String? lastName;
  final String? birthDay;
  final String? address;
  final String? photo;
  final String? iosToken;
  final String? androidToken;
  final bool? verify;
  final bool? verifyRequest;

  static const empty = Person(id: '');

  bool get isEmpty => this == Person.empty;

  bool get isNotEmpty => this != Person.empty;

  @override
  List<Object?> get props => [
        id,
        role,
        email,
        firstName,
        lastName,
        birthDay,
        address,
        photo,
        iosToken,
        androidToken,
        verify,
        verifyRequest
      ];

  factory Person.fromJson(Map<String, dynamic> map) {
    return Person(
      id: map['id'] as String? ?? "",
      role: map['role'] as int? ?? 0,
      email: map['email'] as String? ?? "",
      firstName: map['firstName'] as String? ?? "",
      lastName: map["lastName"] as String? ?? "",
      birthDay: map["birthDay"] as String? ?? "",
      address: map["address"] as String? ?? "",
      photo: map['photo'] as String? ?? "",
      iosToken: map['iosToken'] as String? ?? "",
      androidToken: map['androidToken'] as String? ?? "",
      verify: map['verify'] as bool? ?? false,
      verifyRequest: map['verifyRequest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "role": role,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "birthDay": birthDay,
        "address": address,
        "photo": photo,
        "iosToken": iosToken,
        "androidToken": androidToken,
        "verify": verify,
        "verifyRequest": verifyRequest,
      };
}
