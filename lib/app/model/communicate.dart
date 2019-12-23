class CommunicateModel {
  final String msg;//消息内容(如果内容是图片，这里就是URL)
  final int jobSeekerId;//求职者ID
  final int jobId;//发消息者sessionId
  final int hunterId;//发消息者sessionId
  final int id;//消息唯一ID
  final String sessionId; // 会话ID
  final String userName; // 求职者名字
  final String name; // 职位名称
  final int role;//1来自求职者，2来自招聘者

  CommunicateModel(
      {this.msg,
      this.jobSeekerId,
      this.sessionId,
      this.hunterId,
      this.jobId,
      this.name,
      this.userName,
      this.role,
      this.id});
  factory CommunicateModel.fromMap(Map<String, dynamic> json) {
    return new CommunicateModel(
      msg: json['msg'],
      id: json["id"],
      role: json["role"],
      jobSeekerId: json['jobSeekerId'],
      sessionId: json['sessionId'],
      hunterId: json['hunterId'],
      jobId: json['jobId'],
      name: json['name'],
      userName: json['userName'],
    );
  }

  static List<CommunicateModel> fromJson(List list) {
    List<CommunicateModel> _posts = [];
    for (var value in list) {
      _posts.add(CommunicateModel.fromMap(value));
    }
    return _posts;
  }
}