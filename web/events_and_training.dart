// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'lib/dynamic_html.dart';
import 'lib/messenger.dart';
import 'lib/page.dart';
import 'lib/utility.dart';

Future main() async {
  await Page.init();
  Page.highlightNavigationLink(querySelector("#nav_events_and_training"));

  DivElement coursesContainer = querySelector("#flagship-courses");
  Response response = await Messenger.post(
      Request("get_rows", "courses", {"order_by": "id ASC", "limit": "3"}));
  Map<String, String> row = response.getNextRow();
  while (row != null) {
    coursesContainer.append(generateFlagshipCourseRow(row));
    row = response.getNextRow();
  }

  DateTime now = DateTime.now();
  String strNow = Utility.dfMySql.format(now);
  DivElement upcomingEventsContainer = querySelector("#upcoming-events");
  response = await Messenger.post(Request("get_rows", "events", {
    "columns":
        "id, name, url_readmore, url_signup, date_start, date_end, street, city, country, lang, CASE WHEN pdf IS NULL THEN '0' ELSE '1' END AS has_pdf",
    "where": "date_start >= '$strNow'",
    "order_by": "date_start ASC",
    "limit": "9999"
  }));
  row = response.getNextRow();

  while (row != null) {
    upcomingEventsContainer.append(DynamicHtml.generateEventRow(row, true));
    row = response.getNextRow();
  }

  DivElement pastEventsContainer = querySelector("#past-events");
  ParagraphElement toggle = querySelector("#past_events_show");
  response = await Messenger.post(Request("get_rows", "events", {
    "columns":
        "id, name, url_readmore, url_signup, date_start, date_end, street, city, country, lang, CASE WHEN pdf IS NULL THEN '0' ELSE '1' END AS has_pdf",
    "where": "date_start < '$strNow'",
    "order_by": "date_start DESC"
  }));
  row = response.getNextRow();
  pastEventsContainer.className = "is-hidden";
  while (row != null) {
    pastEventsContainer.append(DynamicHtml.generateEventRow(row));
    row = response.getNextRow();
  }

  toggle.onClick.listen((MouseEvent e) {
    if (e.button == 0) {
      if (pastEventsContainer.classes.contains("is-hidden")) {
        pastEventsContainer.classes.remove("is-hidden");
        toggle.setInnerHtml("&lt;less&gt;");
      } else {
        pastEventsContainer.classes.add("is-hidden");
        toggle.setInnerHtml("&lt;more&gt;");
      }
    }
  });

  Page.show();
}

DivElement generateFlagshipCourseRow(Map<String, String> data) {
  DivElement row = DivElement();
  DivElement col = DivElement();
  HeadingElement name = HeadingElement.h4();
  ParagraphElement descShort = ParagraphElement();
  ParagraphElement toggle = ParagraphElement();
  DivElement descLongContainer = DivElement();
  ParagraphElement descLong = ParagraphElement();

  row.append(col);
  col.append(name);
  col.append(descShort);
  col.append(descLongContainer);
  descLongContainer.append(descLong);
  col.append(toggle);

  name.className = "bold color-1 no-margin";
  descShort.className = "bold no-margin text-left";
  toggle.className = "color-1 clickable";
  descLongContainer.className = "is-hidden long-description-container";

  name.setInnerHtml(data["name"]);
  descShort.setInnerHtml(data["description_short"],
      validator: Page.htmlValidator);
  toggle.setInnerHtml("&lt;more&gt;");
  descLong.setInnerHtml(data["description_long"],
      validator: Page.htmlValidator);

  toggle.onClick.listen((MouseEvent e) {
    if (e.button == 0) {
      if (descLongContainer.classes.contains("is-hidden")) {
        descLongContainer.classes.remove("is-hidden");
        toggle.classes.add("long-description-container");
        toggle.setInnerHtml("&lt;less&gt;");
      } else {
        descLongContainer.classes.add("is-hidden");
        toggle.classes.remove("long-description-container");
        toggle.setInnerHtml("&lt;more&gt;");
      }
    }
  });

  return row;
}
