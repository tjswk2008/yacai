// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:meta/meta.dart';

@immutable
class AppState {
  final String userName;

  AppState({this.userName = ''});

  @override
  String toString() {
    return 'AppState{userName: $userName}';
  }
}
