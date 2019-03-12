// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:flutter_app/actions/actions.dart';
import 'package:flutter_app/app/model/company.dart';

final companyReducer = combineReducers<Company>([
  TypedReducer<Company, SetCompanyAction>(_setCompany)
]);

Company _setCompany(Company company, SetCompanyAction action) {
  return action.company;
}
