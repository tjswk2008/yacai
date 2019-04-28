import 'package:meta/meta.dart';
class Post {
  int id; // post id
  String title; // 标题
  String detail; // 详情
  int viewers; // 已读人数
  int votes; // 点赞人数
  String updateAt; // 最新状态
  String askedBy; // 提问者
  String askedAt; // 提问时间
  int like;
  int type; // 帖子类型
  List<Answer> answers; // 回复

  Post({
    this.id,
    @required this.title,
    @required this.detail,
    @required this.viewers,
    @required this.votes,
    @required this.updateAt,
    @required this.askedBy,
    @required this.askedAt,
    this.type,
    this.like,
    @required this.answers,
  });

  static List<Post> fromJson(List list) {
    List<Post> _posts = [];
    for (var value in list) {
      _posts.add(Post.fromMap(value));
    }
    return _posts;
  }

  static Post fromMap(Map map) {
    return new Post(
      id: map["id"],
      title: map['title'],
      detail: map['detail'],
      viewers: map['viewers'],
      votes: map['votes'],
      updateAt: map['updateAt'],
      askedBy: map['askedBy'],
      askedAt: map['askedAt'],
      type: map['type'],
      like: map['like'],
      answers: Answer.fromList(map['answers']),
    );
  }
}

class Answer{
  int id;
  String answer; // 答复详情
  String answerBy; // 答复人
  String answerAt; // 答复时间
  String avatar;
  int votes; // 点赞数
  int like;
  List<Commet> commets; // 追评

  Answer({
    this.id,
    this.answer,
    this.answerBy,
    this.answerAt,
    this.votes,
    this.like,
    this.commets,
    this.avatar
  });

  static List<Answer> fromList(List list) {
    List<Answer> _answers = [];
    for (var value in list) {
      _answers.add(Answer.fromMap(value));
    }
    return _answers;
  }

  static Answer fromMap(Map map) {
    return new Answer(
        id: map['id'],
        answer: map['answer'],
        answerBy: map['answerBy'],
        answerAt: map['answerAt'],
        votes: map['votes'],
        like: map['like'],
        avatar: map['avatar']
    );
  }
}

class Commet{
  String answer; // 答复详情
  String answerBy; // 答复人
  String answerAt; // 答复时间

  Commet({
    this.answer,
    this.answerBy,
    this.answerAt,
  });

  static List<Commet> fromList(List list) {
    List<Commet> _commets = [];
    for (var value in list) {
      _commets.add(Commet.fromMap(value));
    }
    return _commets;
  }

  static Commet fromMap(Map map) {
    return new Commet(
        answer: map['answer'],
        answerBy: map['answerBy'],
        answerAt: map['answerAt'],
    );
  }
}
