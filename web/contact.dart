// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'lib/page.dart';
import 'lib/messenger.dart';

final ButtonElement submit = querySelector("#submit");
final Element antiSpamOutput = querySelector("#anti_spam_number");
List<InputElement> formInputs;
List<TextAreaElement> formTextAreas;
String antiSpam;

List<Element> invalidInputs = new List();


Future main() async
{
  await Page.init();
  Page.highlightNavigationLink(querySelector("#nav_contact"));

  Element form = querySelector(".form");
  formInputs = form.querySelectorAll("input").toList(growable: false);
  formTextAreas = form.querySelectorAll("textarea").toList(growable: false);
  formInputs.first.focus();

  Random rng = new Random();
  antiSpam = rng.nextInt(9999).toString();
  antiSpamOutput.setInnerHtml("&lArr; $antiSpam");

  setupOnBlurValidityRules();

  submit.onClick.listen(querySubmit);
  Page.show();
}

Future querySubmit(MouseEvent e) async
{
  if (e.button == 0 && checkOnSubmitValidity() == true)
  {
    submit.disabled = true;
    Map<String, String> params = new Map();

    formInputs.forEach((input) => params[input.id] = input.value);
    formTextAreas.forEach((ta) => params[ta.id] = ta.value);

    /// Specials
    querySelectorAll(".forum").toList(growable:false).forEach((radio)
    {
      if (radio.checked) params["forum"] = radio.value;
    });

    Response r = await Messenger.post(new Request("contact", "customers", params));
    if (r.success)
    {
      window.alert("Thank you!\r\nWe have received your request and will return to you with an answer soon.");
      window.location.href = "index.html";
    }
    else window.alert("Something went wrong, please try again.");
    submit.disabled = false;

  }
}

bool checkOnSubmitValidity()
{
  invalidInputs.clear();
  formInputs.forEach((input)
  {
    if (!input.validity.valid) invalidInputs.add(input);
  });

  formTextAreas.forEach((text_area)
  {
    if (!text_area.validity.valid) invalidInputs.add(text_area);
  });

  /// Specials
  TextInputElement antiSpamInput = querySelector("#anti_spam");
  if (antiSpamInput.value != antiSpam)
  {
    if (!invalidInputs.contains(antiSpamInput)) invalidInputs.add(antiSpamInput);
  }

  invalidInputs.forEach((Element e)
  {
    e.classes.add("invalid");
  });

  if (invalidInputs.isEmpty) return true;
  else
  {
    Element firstInvalid = invalidInputs.first;
    firstInvalid.focus();
    window.alert(firstInvalid.dataset["validation-message"]);
    return false;
  }
}

void setupOnBlurValidityRules()
{
  formInputs.forEach((input)
  {
    input.onInput.listen((_)
    {
      if (input.validity.valid) input.classes.remove("invalid");
      else input.classes.add("invalid");
    });
  });

  formTextAreas.forEach((ta)
  {
    ta.onInput.listen((_)
    {
      if (ta.validity.valid) ta.classes.remove("invalid");
      else ta.classes.add("invalid");
    });
  });

  /// Special
  TextInputElement antiSpamInput = querySelector("#anti_spam");
  antiSpamInput.onInput.listen((_)
  {
    if (antiSpamInput.value == antiSpam) antiSpamInput.classes.remove("invalid");
    else antiSpamInput.classes.add("invalid");
  });
}
