// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library signup_component;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

@Component(
    selector: 'hibis-signup',
    styleUrls: const ['signup_component.css'],
    templateUrl: 'signup_component.html',
    directives: const [FORM_DIRECTIVES],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class SignupComponent
{
  SignupComponent(this._formBuilder)
  {
    /*
    form = _formBuilder.group
    (

    );
    */
  }

  Future onSubmit() async
  {

  }

  final FormBuilder _formBuilder;
  ControlGroup form;
}
