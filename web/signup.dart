// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:angular2/common.dart';
import 'components/signup_component.dart';

import 'dart:async';
import 'lib/page.dart';

Future main() async
{
  bootstrap(SignupComponent, [FORM_PROVIDERS]);



  await Page.init();
  Page.show();
}