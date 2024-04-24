// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
// import 'dart:convert';

class MessageModel {
  String messageId;
  String chatId;
  Role role;
  StringBuffer message;
  List<String> imageUrls;
  DateTime timeSent;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imageUrls,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      'message': message.toString(),
      'imageUrls': imageUrls,
      'timeSent': timeSent.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] as String,
      chatId: map['chatId'] as String,
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imageUrls: List<String>.from((map['imageUrls'] as List<String>)),
      timeSent: DateTime.parse(
        map['timeSent'],
      ),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory MessageModel.fromJson(String source) =>
  //     MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  MessageModel copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imageUrls,
    DateTime? timeSent,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      message: message ?? this.message,
      imageUrls: imageUrls ?? this.imageUrls,
      timeSent: timeSent ?? this.timeSent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}

enum Role {
  user,
  assistant,
}
