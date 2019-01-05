import 'dart:convert';

import 'package:meta/meta.dart';

class Message {
  final String name;
  final String avatar;
  final String company;
  final String position;
  final String msg;

  Message({
    @required this.name,
    @required this.avatar,
    @required this.company,
    @required this.position,
    @required this.msg,
  });

    static List<Message> fromJson(String json) {
      List<Message> _messages = [];
      for (var value in new JsonDecoder().convert(json)['list']) {
        _messages.add(Message.fromMap(value));
      }
      return _messages;
  }

  static Message fromMap(Map map) {
    return new Message(
        name: map['name'],
        avatar: map['avatar'],
        company: map['company'],
        position: map['position'],
        msg: map['msg']
    );
  }
}