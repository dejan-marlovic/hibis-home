// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/page.dart';
import 'lib/messenger.dart';
import 'lib/event_manager.dart';

final DivElement upcomingEventsContainer = querySelector("#upcoming-events-container");

Future main() async
{
  await Page.init();

  Response response = await Messenger.post(new Request("get_rows", "events", {"limit":"3", "order_by":"id DESC"}));
  Map<String, String> row = response.getNextRow();
  while (row != null)
  {
    upcomingEventsContainer.append(EventManager.generateEventRowHtml(row));
    row = response.getNextRow();
  }

  Page.show();

}


