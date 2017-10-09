// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library app_component;

import 'package:angular/angular.dart';
import 'signup_component.dart';
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'hibis-signup-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const [ROUTER_DIRECTIVES],
    preserveWhitespace: false
)

@RouteConfig(const
[
  const Route(path:'/signup.html', name:'Signup', component: SignupComponent, useAsDefault: true)
])

class AppComponent
{
  AppComponent();
}
