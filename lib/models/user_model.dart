import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String lat;
  final String lng;
  final String urlAvatar;
  UserModel({
    this.name,
    this.email,
    this.password,
    this.lat,
    this.lng,
    this.urlAvatar,
  });

  UserModel copyWith({
    String name,
    String email,
    String password,
    String lat,
    String lng,
    String urlAvatar,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      urlAvatar: urlAvatar ?? this.urlAvatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'lat': lat,
      'lng': lng,
      'urlAvatar': urlAvatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      lat: map['lat'],
      lng: map['lng'],
      urlAvatar: map['urlAvatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, password: $password, lat: $lat, lng: $lng, urlAvatar: $urlAvatar)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserModel &&
      o.name == name &&
      o.email == email &&
      o.password == password &&
      o.lat == lat &&
      o.lng == lng &&
      o.urlAvatar == urlAvatar;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      urlAvatar.hashCode;
  }
}
