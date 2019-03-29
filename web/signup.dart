// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'components/app_component.template.dart' as ng;
import 'lib/page.dart';

void main() async {
  runApp(ng.AppComponentNgFactory);

  await Page.init();
  Page.show();
}
