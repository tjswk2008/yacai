// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';

final userNameReducer = combineReducers<String>([
  TypedReducer<String, AddUserNameAction>(_addUserName),
  TypedReducer<String, DeleteUserNameAction>(_deleteUserName),
]);

String _addUserName(String userName, AddUserNameAction action) {
  return action.userName;
}

String _deleteUserName(String userName, DeleteUserNameAction action) {
  return '';
}
