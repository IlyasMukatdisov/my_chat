import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdDate;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdDate,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: List<String>.from((map['photoUrl'] as List<String>)),
      profilePic: map['profilePic'] as String,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      statusId: map['statusId'] as String,
      whoCanSee: List<String>.from((map['whoCanSee'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Status.fromJson(String source) =>
      Status.fromMap(json.decode(source) as Map<String, dynamic>);
}
