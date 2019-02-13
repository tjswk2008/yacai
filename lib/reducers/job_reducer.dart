// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/job.dart';

final jobReducer = combineReducers<List<Job>>([
  TypedReducer<List<Job>, SetJobsAction>(_setJobs)
]);

List<Job> _setJobs(List<Job> jobs, SetJobsAction action) {
  return action.jobs;
}
