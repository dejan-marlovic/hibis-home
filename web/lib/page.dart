// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library page;

import 'dart:async';
import 'dart:html';
import 'messenger.dart';
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
      Response response = await Messenger.post(new Request("get_rows", "publications", {"columns":"id, name, date, url_pdf", "order_by":"date DESC", "limit":"3"}));
      Map<String, String> row = response.getNextRow();
      while (row != null)
      {
        container.append(DynamicHtml.generateArticleRow(row));
        row = response.getNextRow();
      }
      //Adding link more dynamically;
      SpanElement more = new SpanElement();
      more.setInnerHtml("&lt;more&gt;");
      AnchorElement link = new AnchorElement();
      link.href = "publications.html";
      DivElement rowMore = new DivElement();
      rowMore.className = "row collapse";
      DivElement column = new DivElement();
      column.className = "small-11 small-offset-1 columns";
      link.append(more);
      column.append(link);
      rowMore.append(column);
      container.append(rowMore);
    }
    else if (panelRightSmall != null)
    {
      await importHtml("inc-panel-right-small.html", panelRightSmall);
      ScriptElement twitterWidget = new ScriptElement();
      twitterWidget.src = "//platform.twitter.com/widgets.js";
      twitterWidget.charset = "utf-8";
      document.body.append(twitterWidget);
    }

    if (header != null)
    {
      await importHtml("inc-header.html", header);
      ImageElement hamburger = header.querySelector("#hamburger");
      UListElement smallLinks = header.querySelector("#small-links");
      hamburger.onClick.listen((_)
      {
        if (smallLinks.classes.contains("is-hidden")) smallLinks.classes.remove("is-hidden");
        else smallLinks.classes.add("is-hidden");
      });
    }
    if (footer != null) await importHtml("inc-footer.html", footer);





    search.onKeyUp.listen((KeyboardEvent e)
    {
      if (e.keyCode == KeyCode.ENTER || e.keyCode == KeyCode.MAC_ENTER)
      {
        window.location.href = "search.html?keywords=" + search.value;
      }
    });

    searchButton.onClick.listen((MouseEvent e)
    {
      if (e.button == 0)
      {
        window.location.href = "search.html?keywords=" + search.value;
      }
    });

  }

  static void highlightNavigationLink(AnchorElement e)
  {
    e.classes.add("highlighted");

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
  ..allowElement('span', attributes: ['data-exp', 'style'])
  ..allowElement('h4', attributes: ['data-exp', 'style'])
  ..allowElement('i', attributes: ['aria-hidden'])
  ..allowNavigation(new UriPolicyExternal());


  static final DivElement header = querySelector("#header");
  static final DivElement panelRight = querySelector("#panel-right");
  static final DivElement panelRightSmall = querySelector("#panel-right-small");
  static final DivElement footer = querySelector("#footer");
  static final TextInputElement search = querySelector("#search");
  static final Element searchButton = querySelector("#search_icon");
}

class UriPolicyExternal implements UriPolicy
{
  bool allowsUri(String uri) => true;
}
