// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'lib/dynamic_html.dart';
import 'lib/page.dart';
import 'lib/messenger.dart';

Future main() async
{
  await Page.init();

  Page.highlightNavigationLink(querySelector("#nav_publications"));

  /// List all books
  final DivElement booksContainer = querySelector("#books-container");
  Response response = await Messenger.post(new Request("get_rows", "books", {"columns":"id, name, author, format, brief, image", "order_by":"id ASC"}));
  Map<String, String> row = response.getNextRow();
  while (row != null)
  {
    booksContainer.append(DynamicHtml.generateBookColumn(row));
    row = response.getNextRow();
  }
  if (booksContainer.children.isNotEmpty) booksContainer.children.last.classes.add("end");

  /// List all publications
  final DivElement articlesContainer = querySelector("#publications-container");
  response = await Messenger.post(new Request("get_rows", "publications", {"columns":"id, name, date, icon, url_pdf, url_publisher, author", "order_by":"date DESC"}));
  row = response.getNextRow();
  while (row != null)
  {
    articlesContainer.append(DynamicHtml.generateArticleColumn(row));
    row = response.getNextRow();
  }
  if (articlesContainer.children.isNotEmpty) articlesContainer.children.last.classes.add("end");


  ScriptElement shareFacebookScript = new ScriptElement();
  shareFacebookScript.innerHtml =
  """
        (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.7";
        fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));

    """;
  DivElement shareFacebookRoot = new DivElement();
  shareFacebookRoot.id = "fb-root";
  document.body.children.insert(0, shareFacebookRoot);
  document.body.children.insert(1, shareFacebookScript);

  ScriptElement shareLinkedInScript = new ScriptElement();
  shareLinkedInScript.src = "//platform.linkedin.com/in.js";
  shareLinkedInScript.type = "text/javascript";
  shareLinkedInScript.setInnerHtml(" lang: en_US");
  document.body.children.insert(2, shareLinkedInScript);

  Page.show();
}