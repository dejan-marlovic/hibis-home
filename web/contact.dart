// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/page.dart';
import 'lib/messenger.dart';

final ButtonElement submit = querySelector("#submit");

Future main() async
{
  await Page.init();
  submit.onClick.listen(querySubmit);
  Page.show();
}

Future querySubmit(MouseEvent e) async
{
  if (e.button == 0)
  {
    Map<String, String> params = new Map();
    params["organisation"] = (querySelector("#organisation") as InputElement).value;
    params["department"] = (querySelector("#department") as InputElement).value;
    params["address"] = (querySelector("#address") as InputElement).value;
    params["postal_code"] = (querySelector("#postal_code") as InputElement).value;
    params["city"] = (querySelector("#city") as InputElement).value;
    params["country"] = (querySelector("#country") as InputElement).value;
    params["firstname"] = (querySelector("#firstname") as InputElement).value;
    params["lastname"] = (querySelector("#lastname") as InputElement).value;
    params["title"] = (querySelector("#title") as InputElement).value;
    params["email"] = (querySelector("#email") as InputElement).value;
    params["telephone"] = (querySelector("#telephone") as InputElement).value;
    params["comments"] = (querySelector("#comments") as TextAreaElement).value;
    List<RadioButtonInputElement> radioList = querySelectorAll(".forum").toList(growable:false);
    radioList.forEach((radio)
    {
      if (radio.checked)
        params["forum"] = radio.value;
    });
    Response r = await Messenger.post(new Request("contact", "customers", params));
    print(r.success);
  }

}