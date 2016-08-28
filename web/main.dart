// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/page.dart';
import 'lib/messenger.dart';
import 'lib/dynamic_html.dart';
import 'lib/utility.dart';


final DivElement upcomingEventsContainer = querySelector("#upcoming-events-container");

Future main() async
{
  await Page.init();


  String now = Utility.dfMySql.format(new DateTime.now());
  Response response = await Messenger.post(new Request("get_rows", "events", {"where":"date_start > '$now'", "limit":"3", "order_by":"id DESC"}));
  Map<String, String> row = response.getNextRow();
  while (row != null)
  {
    upcomingEventsContainer.append(DynamicHtml.generateEventRow(row, true));
    row = response.getNextRow();
  }

  Page.show();

}


