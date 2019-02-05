// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/resume.dart';

final resumeReducer = combineReducers<Resume>([
  TypedReducer<Resume, SetResumeAction>(_setResume)
]);

Resume _setResume(Resume resume, SetResumeAction action) {
  return action.resume;
}
