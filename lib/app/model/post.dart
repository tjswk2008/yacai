import 'package:meta/meta.dart';
class Post {
  int id; // post id
  String title; // 标题
  String detail; // 详情
  int viewers; // 已读人数
  int votes; // 点赞人数
  String latestStatus; // 最新状态
  String askedBy; // 提问者
  String askedAt; // 提问时间
  List<Answer> answers; // 回复

  Post({
    this.id,
    @required this.title,
    @required this.detail,
    @required this.viewers,
    @required this.votes,
    @required this.latestStatus,
    @required this.askedBy,
    @required this.askedAt,
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
        latestStatus: map['latestStatus'],
        askedBy: map['askedBy'],
        askedAt: map['askedAt'],
        answers: Answer.fromList(map['answers']),
    );
  }
}

class Answer{
  String answer; // 答复详情
  String answerBy; // 答复人
  String answerAt; // 答复时间
  String votes; // 点赞数
  List<Commet> commets; // 追评

  Answer({
    this.answer,
    this.answerBy,
    this.answerAt,
    this.votes,
    this.commets,
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
        answer: map['answer'],
        answerBy: map['answerBy'],
        answerAt: map['answerAt'],
        votes: map['votes'],
        commets: Commet.fromList(map['commets']),
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
