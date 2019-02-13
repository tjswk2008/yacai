// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_app/reducers/user_name_reducer.dart';
import 'package:flutter_app/reducers/resume_reducer.dart';
import 'package:flutter_app/reducers/job_reducer.dart';
import 'package:flutter_app/app/model/app.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    userName: userNameReducer(state.userName, action),
    resume: resumeReducer(state.resume, action),
    jobs: jobReducer(state.jobs, action),
  );
}
