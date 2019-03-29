// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library app_component;

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'signup_component.template.dart' as signup_comp;

@Component(
    selector: 'hibis-signup-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    providers: [routerProviders],
    directives: [routerDirectives])
class AppComponent {
  AppComponent();

  final List<RouteDefinition> routes = [
    RouteDefinition(
        routePath: RoutePath(path: '/signup.html', useAsDefault: true),
        component: signup_comp.SignupComponentNgFactory)
  ];
}
