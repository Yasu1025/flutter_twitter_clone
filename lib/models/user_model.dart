// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class User {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final String banerPic;
  final String bio;
  final List<dynamic> followers;
  final List<dynamic> followings;
  final bool isTwitterBlue;
  const User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.banerPic,
    required this.bio,
    required this.followers,
    required this.followings,
    required this.isTwitterBlue,
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    String? banerPic,
    String? bio,
    List<dynamic>? followers,
    List<dynamic>? followings,
    bool? isTwitterBlue,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      banerPic: banerPic ?? this.banerPic,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid, // from appwrite
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'banerPic': banerPic,
      'bio': bio,
      'followers': followers,
      'followings': followings,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['\$id'] as String, // from appwrite
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      banerPic: map['banerPic'] as String,
      bio: map['bio'] as String,
      followers: List<dynamic>.from((map['followers'] as List<dynamic>)),
      followings: List<dynamic>.from((map['followings'] as List<dynamic>)),
      isTwitterBlue: map['isTwitterBlue'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, email: $email, profilePic: $profilePic, banerPic: $banerPic, bio: $bio, followers: $followers, followings: $followings, isTwitterBlue: $isTwitterBlue)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.banerPic == banerPic &&
        other.bio == bio &&
        listEquals(other.followers, followers) &&
        listEquals(other.followings, followings) &&
        other.isTwitterBlue == isTwitterBlue;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        banerPic.hashCode ^
        bio.hashCode ^
        followers.hashCode ^
        followings.hashCode ^
        isTwitterBlue.hashCode;
  }
}
