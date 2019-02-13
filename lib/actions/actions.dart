// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.
import 'package:flutter_app/app/model/resume.dart';
import 'package:flutter_app/app/model/job.dart';

class DeleteUserNameAction {
  DeleteUserNameAction();

  @override
  String toString() {
    return 'DeleteUserNameAction';
  }
}

class AddUserNameAction {
  final String userName;

  AddUserNameAction(this.userName);

  @override
  String toString() {
    return 'AddUserNameAction{todo: $userName}';
  }
}

class SetResumeAction {
  final Resume resume;

  SetResumeAction(this.resume);
}

class SetJobsAction {
  final List<Job> jobs;

  SetJobsAction(this.jobs);
}
