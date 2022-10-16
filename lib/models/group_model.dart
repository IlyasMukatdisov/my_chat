import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupModel {
  final String senderId;
  final String senderName;
  final String name;
  final String groupUid;
  final String lastMessage;
  final String groupProfilePic;
  final DateTime timeSent;
  final List<String> membersUid;

  GroupModel({
    required this.senderId,
    required this.senderName,
    required this.name,
    required this.groupUid,
    required this.lastMessage,
    required this.groupProfilePic,
    required this.timeSent,
    required this.membersUid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderName': senderName,
      'name': name,
      'groupUid': groupUid,
      'lastMessage': lastMessage,
      'groupProfilePic': groupProfilePic,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'membersUid': membersUid,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      name: map['name'] as String,
      groupUid: map['groupUid'] as String,
      lastMessage: map['lastMessage'] as String,
      groupProfilePic: map['groupProfilePic'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      membersUid: List<String>.from(map['membersUid']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
