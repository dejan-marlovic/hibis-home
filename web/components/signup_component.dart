// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library signup_component;

import 'dart:async';
import 'dart:math';
import 'package:angular_components/angular_components.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import '../lib/messenger.dart';
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'hibis-signup',
    styleUrls: const ['signup_component.css'],
    templateUrl: 'signup_component.html',
    directives: const [formDirectives, materialDirectives, NgIf],
    providers: const [FORM_PROVIDERS],
    pipes: const [DatePipe],
    preserveWhitespace: false
)

class SignupComponent implements OnActivate
{
  SignupComponent(this._formBuilder)
  {

    form = _formBuilder.group
    (
        {
          "organisation":["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "department":["", Validators.compose([Validators.maxLength(128)])],
          "payment_reference":["", Validators.compose([Validators.maxLength(128)])],
          "street":["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "zip":["", Validators.compose([Validators.required, Validators.maxLength(32)])],
          "city":["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "country":["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "firstname":["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "lastname" : ["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "title" : ["", Validators.maxLength(64)],
          "email" : ["", Validators.compose([Validators.required, Validators.maxLength(128)])],
          "telephone" : ["", Validators.compose([isPhoneNumber])],
          "antispam" : ["", Validators.compose([matchesRandomNumber, Validators.required])],
          "comments" : ["", Validators.compose([Validators.maxLength(2000)])]
        }
    );

    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    randomNumber = rnd.nextInt(8999) + 1000;
  }

  Future routerOnActivate(ComponentInstruction nextInstruction, ComponentInstruction prevInstruction) async
  {
    if (nextInstruction.urlParams.isEmpty)
    {
      eventId = null;
      dialogTitle = "An error occured";
      dialogMessage = "No event id has been specified, please specify an event using url parameters (fraudacademy.hibis.com/signup.html?event=[id])";
    }
    else
    {
      eventId = nextInstruction.urlParams.first.split("=").last;
      Request req = new Request("get_properties", "events", {"id":eventId.toString()});
      Response r = await Messenger.post(req);
      if (r.result == false)
      {
        dialogTitle = "Event not found";
        dialogMessage = "The event with id $eventId could not be found, please try again with a difference event id";
      }
      else
      {
        eventTitle = r.result["name"];
        eventCity = r.result["city"];
        eventDateStart = DateTime.parse(r.result["date_start"]);
        eventDateEnd = DateTime.parse(r.result["date_end"]);
      }
    }
  }

  Future onSubmit() async
  {
    Request r = new Request("signup", "customers", form.value);
    r.params["event_id"] = eventId;

    loading = true;
    Response response = await Messenger.post(r);
    loading = false;
    if (response.success)
    {
      dialogTitle = "Thank you!";
      dialogMessage = "We have received your application and sent an email to ${form.controls["email"].value}. with additional information about the event.";
      firstname = lastname = title = email = phone = "";
    }
    else
    {
      dialogTitle = "An error occured";
      dialogMessage = response.result;
    }
  }

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

  Map<String, String> matchesRandomNumber(AbstractControl control)
  {
    String value = control.value;
    Map<String, String> output = new Map();

    if (value.compareTo(randomNumber.toString()) != 0)
    {
      output["material-input-error"] = "Match the number";
    }
    return output;
  }

  Map<String, String> isPhoneNumber(AbstractControl control)
  {
    if (Validators.required(control) != null) return null;
    String value = control.value;
    Map<String, String> output = new Map();
    RegExp r = new RegExp("[\+]{0,1}[0-9]{7,32}");
    if (r.stringMatch(value) == null || r.stringMatch(value).length != value.length)
    {
      output["material-input-error"] = "Enter a valid phone number without spaces or dashes (+461234567)";
    }
    return output;
  }
}
