// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/page.dart';

Future main() async
{
  await Page.init();
  Page.highlightNavigationLink(querySelector("#nav_watch_play_act"));

  List<Element> clickableElements = querySelectorAll(".clickable");

  for(Element clickableElement in clickableElements)
  {
    clickableElement.onClick.listen((MouseEvent e)
    {
      SpanElement longDescription = querySelector("#" + clickableElement.dataset["target"]);

      if (longDescription.classes.contains("is-hidden"))
      {
        clickableElement.setInnerHtml("&lt;Show less&gt;");
        longDescription.classes.remove("is-hidden");
      }
      else
      {
        clickableElement.setInnerHtml("&lt;Show more&gt;");
        longDescription.classes.add("is-hidden");
      }

    });
  }
  Page.show();
}

