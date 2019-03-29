// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library signup_component;

import 'dart:async';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../lib/messenger.dart';

@Component(
    selector: 'hibis-signup',
    styleUrls: ['signup_component.css'],
    templateUrl: 'signup_component.html',
    directives: [formDirectives, materialDirectives, NgIf],
    providers: [FORM_PROVIDERS],
    pipes: [DatePipe],
    preserveWhitespace: false)
class SignupComponent implements OnActivate {
  String eventId;

  String dialogTitle;

  String dialogMessage;

  int randomNumber;
  final FormBuilder _formBuilder;

  ControlGroup form;
  String firstname = "";
  String lastname = "";

  String title = "";
  String email = "";
  String phone = "";
  bool loading = false;
  String eventTitle;
  String eventCity;

  DateTime eventDateStart;
  DateTime eventDateEnd;
  SignupComponent(this._formBuilder) {
    form = ControlGroup({
      "organisation": Control('',
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "department":
          Control("", Validators.compose([Validators.maxLength(128)])),
      "payment_reference":
          Control("", Validators.compose([Validators.maxLength(128)])),
      "street": Control("",
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "zip": Control("",
          Validators.compose([Validators.required, Validators.maxLength(32)])),
      "city": Control("",
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "country": Control("",
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "firstname": Control("",
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "lastname": Control("",
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "title": Control("", Validators.maxLength(64)),
      "email": Control("",
          Validators.compose([Validators.required, Validators.maxLength(128)])),
      "telephone": Control("", Validators.compose([isPhoneNumber])),
      "antispam": Control(
          "", Validators.compose([matchesRandomNumber, Validators.required])),
      "comments": Control("", Validators.compose([Validators.maxLength(2000)]))
    });

    Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
    randomNumber = rnd.nextInt(8999) + 1000;
  }
  Map<String, String> isPhoneNumber(AbstractControl control) {
    if (Validators.required(control) != null) return null;
    String value = control.value;
    Map<String, String> output = Map();
    RegExp r = RegExp("[\+]{0,1}[0-9]{7,32}");
    if (r.stringMatch(value) == null ||
        r.stringMatch(value).length != value.length) {
      output["material-input-error"] =
          "Enter a valid phone number without spaces or dashes (+461234567)";
    }
    return output;
  }

  Map<String, String> matchesRandomNumber(AbstractControl control) {
    String value = control.value;
    Map<String, String> output = Map();

    if (value.compareTo(randomNumber.toString()) != 0) {
      output["material-input-error"] = "Match the number";
    }
    return output;
  }

  @override
  void onActivate(RouterState previous, RouterState current) async {
    if (current.queryParameters.isEmpty) {
      eventId = null;
      dialogTitle = "An error occured";
      dialogMessage =
          "No event id has been specified, please specify an event using url parameters (fraudacademy.hibis.com/signup.html?event=[id])";
    } else {
      eventId = current.queryParameters.values.first;
      final req =
          Request("get_properties", "events", {"id": eventId.toString()});
      final r = await Messenger.post(req);
      if (r.result == false) {
        dialogTitle = "Event not found";
        dialogMessage =
            "The event with id $eventId could not be found, please try again with a difference event id";
      } else {
        eventTitle = r.result["name"];
        eventCity = r.result["city"];
        eventDateStart = DateTime.parse(r.result["date_start"]);
        eventDateEnd = DateTime.parse(r.result["date_end"]);
      }
    }
  }

  Future onSubmit() async {
    Request r = Request("signup", "customers", form.value);
    r.params["event_id"] = eventId;

    loading = true;
    Response response = await Messenger.post(r);
    loading = false;
    if (response.success) {
      dialogTitle = "Thank you!";
      dialogMessage =
          "We have received your application and sent an email to ${form.controls["email"].value}. with additional information about the event.";
      firstname = lastname = title = email = phone = "";
    } else {
      dialogTitle = "An error occured";
      dialogMessage = response.result;
    }
  }
}
