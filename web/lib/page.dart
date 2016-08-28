// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library page;

import 'dart:async';
import 'dart:html';
import 'messenger.dart';
import 'utility.dart';
import 'dynamic_html.dart';

class Page
{
  static Future init() async
  {
    if (panelRight != null)
    {
      await importHtml("inc-panel-right.html", panelRight);
      ScriptElement twitterWidget = new ScriptElement();
      twitterWidget.src = "//platform.twitter.com/widgets.js";
      twitterWidget.charset = "utf-8";
      document.body.append(twitterWidget);

      DivElement container = panelRight.querySelector("#pdf_publications_box");
      /// List latest publications
      Response response = await Messenger.post(new Request("get_rows", "publications", {"columns":"name, date, url_pdf", "order_by":"id DESC", "limit":"3"}));
      Map<String, String> row = response.getNextRow();
      while (row != null)
      {
        container.append(DynamicHtml.generateArticleRow(row));
        row = response.getNextRow();
      }
    }
    else if (panelRightSmall != null)
    {
      await importHtml("inc-panel-right-small.html", panelRightSmall);
      ScriptElement twitterWidget = new ScriptElement();
      twitterWidget.src = "//platform.twitter.com/widgets.js";
      twitterWidget.charset = "utf-8";
      document.body.append(twitterWidget);
    }

    if (header != null) await importHtml("inc-header.html", header);
    if (footer != null) await importHtml("inc-footer.html", footer);
  }

  static void show()
  {
    document.body.style.opacity = "1";
  }

  static Future importHtml(String source, DivElement into) async
  {
    String response = await HttpRequest.getString(source);
    if (into != null) into.setInnerHtml(response, validator:htmlValidator);
    return response;
  }

  static final NodeValidator htmlValidator = new NodeValidatorBuilder.common()
  ..allowElement('a', attributes: ['data-exp', 'data-tweet-limit', 'data-chrome', 'data-link-color', 'href'])
  ..allowElement('span', attributes: ['data-exp'])
  ..allowElement('h4', attributes: ['data-exp'])
  ..allowNavigation(new UriPolicyExternal());

  static final DivElement header = querySelector("#header");
  static final DivElement panelRight = querySelector("#panel-right");
  static final DivElement panelRightSmall = querySelector("#panel-right-small");
  static final DivElement footer = querySelector("#footer");
}

class UriPolicyExternal implements UriPolicy
{
  bool allowsUri(String uri) => true;
}