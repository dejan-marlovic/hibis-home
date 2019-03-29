// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/dynamic_html.dart';
import 'lib/messenger.dart';
import 'lib/page.dart';

Future main() async {
  await Page.init();
  Page.highlightNavigationLink(querySelector("#nav_fellows_and_facilitators"));

  final DivElement fellowsContainer = querySelector("#fellows-container");
  Response response = await Messenger.post(
      Request("get_rows", "fellows", {"order_by": "hibis DESC, lastname ASC"}));
  Map<String, String> rowData = response.getNextRow();
  while (rowData != null) {
    fellowsContainer.append(DynamicHtml.generateFellowRow(rowData));
    rowData = response.getNextRow();
  }

  Page.show();
}
