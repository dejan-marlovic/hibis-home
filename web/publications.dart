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
  Response response = await Messenger.post(new Request("list_all", "books", {"columns":"name, author, format, brief", "order_by":"name ASC"}));
  Map<String, String> row = response.getNextRow();
  while (row != null)
  {
    booksContainer.append(DynamicHtml.generateBookColumn(row));
    row = response.getNextRow();
  }
  if (booksContainer.children.isNotEmpty) booksContainer.children.last.classes.add("end");

  /// List all publications
  final DivElement articlesContainer = querySelector("#publications-container");
  response = await Messenger.post(new Request("get_rows", "publications", {"columns":"name, date, url_pdf", "order_by":"date DESC"}));
  row = response.getNextRow();
  while (row != null)
  {
    articlesContainer.append(DynamicHtml.generateArticleColumn(row));
    row = response.getNextRow();
  }
  if (articlesContainer.children.isNotEmpty) articlesContainer.children.last.classes.add("end");


  Page.show();
}