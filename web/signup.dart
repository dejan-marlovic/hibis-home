// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'components/app_component.dart';

import 'dart:async';
import 'lib/page.dart';

Future main() async
{
  bootstrap(AppComponent, [materialProviders]);

  await Page.init();
  Page.show();
}