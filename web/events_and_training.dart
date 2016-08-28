// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/page.dart';
import 'lib/messenger.dart';
import 'lib/event_manager.dart';

Future main() async
{
  await Page.init();

  DivElement coursesContainer = querySelector("#flagship-courses");
  Response response = await Messenger.post(new Request("get_rows", "courses", {"order_by":"id ASC", "limit":"3"}));
  Map<String, String> row = response.getNextRow();
  while (row != null)
  {
    coursesContainer.append(generateCourseRow(row));
    row = response.getNextRow();
  }

  DivElement eventsContainer = querySelector("#upcoming-events");
  response = await Messenger.post(new Request("get_rows", "events", {"order_by":"id DESC", "limit":"3"}));
  row = response.getNextRow();
  while (row != null)
  {
    eventsContainer.append(EventManager.generateEventRowHtml(row));
    row = response.getNextRow();
  }


  Page.show();
}

DivElement generateEventRow(Map<String, String> data)
{
  DivElement row = new DivElement();



  return row;
}

DivElement generateCourseRow(Map<String, String> data)
{
  DivElement row = new DivElement();
  DivElement col = new DivElement();
  HeadingElement name = new HeadingElement.h4();
  ParagraphElement descShort = new ParagraphElement();
  ParagraphElement toggle = new ParagraphElement();
  DivElement descLongContainer = new DivElement();
  ParagraphElement descLong = new ParagraphElement();

  row.append(col);
  col.append(name);
  col.append(descShort);
  col.append(toggle);
  col.append(descLongContainer);
  descLongContainer.append(descLong);

  name.className = "bold color-1 no-margin";
  descShort.className = "bold no-margin text-left";
  toggle.className = "color-1 clickable";
  descLongContainer.className = "long-description-container is-hidden";

  name.setInnerHtml(data["name"]);
  descShort.setInnerHtml(data["description_short"]);
  toggle.setInnerHtml("&lt;more&gt;");
  descLong.setInnerHtml(data["description_long"]);

  toggle.onClick.listen((MouseEvent e)
  {
    if (e.button == 0)
    {
      if (descLongContainer.classes.contains("is-hidden")) descLongContainer.classes.remove("is-hidden");
      else descLongContainer.classes.add("is-hidden");
    }

  });

  return row;
}