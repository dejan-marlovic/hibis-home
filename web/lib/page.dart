// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library page;

import 'dart:async';
import 'dart:html';
import 'messenger.dart';
import 'utility.dart';

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
        container.append(generateArticleRowHtml(row));
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

  static DivElement generateArticleRowHtml(Map<String, String> data)
  {
    DivElement row = new DivElement();
    DivElement col1 = new DivElement();
    DivElement col2 = new DivElement();
    HeadingElement name = new HeadingElement.h4();
    SpanElement date = new SpanElement();
    AnchorElement link = new AnchorElement(href:data["url_pdf"]);
    DivElement viewPdfContainer = new DivElement();
    ImageElement viewPdfIcon = new ImageElement(src:"gfx/blue_arrow.png");
    SpanElement viewPdfLabel = new SpanElement();
    row.append(col1);
    row.append(col2);
    col2.append(name);
    col2.append(date);
    col2.append(link);
    link.append(viewPdfContainer);
    viewPdfContainer.append(viewPdfIcon);
    viewPdfContainer.append(viewPdfLabel);

    row.className = "bold row collapse";
    col1.className = "small-1 columns";
    col2.className = "small-11 columns";
    name.className = "color-2 bold no-margin";
    date.className = "link_description normal";
    viewPdfContainer.className = "pdf_download_button background-color-3-light color-2";
    viewPdfLabel.className = "normal";

    col1.setInnerHtml("&raquo;");
    name.setInnerHtml(data["name"]);

    DateTime dt = DateTime.parse(data["date"]);

    date.setInnerHtml(Utility.dfMonthYear.format(dt));
    /// TODO phrase
    viewPdfLabel.setInnerHtml(" view PDF");

    return row;
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