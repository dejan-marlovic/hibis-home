// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'components/app_component.dart';

import 'dart:async';
import 'lib/page.dart';

Future main() async
{
  bootstrap(AppComponent, [FORM_PROVIDERS, ROUTER_PROVIDERS, materialProviders]);

  await Page.init();
  Page.show();
}