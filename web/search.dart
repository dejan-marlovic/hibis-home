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

  Response response;
  Map<String, String> row;

  String strKeywords = (window.location.search.startsWith("?keywords=")) ? window.location.search.substring("?keywords=".length) : "";
  List<String> keywords = new List();
  if (strKeywords.isNotEmpty)
  {
    strKeywords = Uri.decodeFull(strKeywords);
    List<String> kws = strKeywords.split(" ");
    kws.forEach((kw) => keywords.add("'%$kw%'"));
  }

  String where = "1";
  if (keywords.isNotEmpty) where = generateWhereString(["name", "city", "country"], keywords);

  /// List matching events
  final DivElement eventsContainer = querySelector("#events-container");
  response = await Messenger.post(new Request("get_rows", "events", {"columns":"*", "order_by":"name ASC", "where":where}));

  if (response.isEmpty)
  {
    ParagraphElement noEventsMessage = new ParagraphElement();
    noEventsMessage.setInnerHtml("No events found");
    eventsContainer.append(noEventsMessage);
  }
  else
  {
    row = response.getNextRow();
    while (row != null)
    {
      eventsContainer.append(DynamicHtml.generateEventRow(row));
      row = response.getNextRow();
    }
  }

  /// List matching books
  where = "1";
  if (keywords.isNotEmpty) where = generateWhereString(["name", "author", "format"], keywords);
  final DivElement booksContainer = querySelector("#books-container");
  response = await Messenger.post(new Request("get_rows", "books", {"columns":"id, name, author, format, brief, image", "order_by":"name ASC", "where":where}));

  if (response.isEmpty)
  {
    ParagraphElement noBooksMessage = new ParagraphElement();
    noBooksMessage.setInnerHtml("No books found");
    booksContainer.append(noBooksMessage);
  }
  else
  {
    row = response.getNextRow();
    while (row != null)
    {
      booksContainer.append(DynamicHtml.generateBookColumn(row));
      row = response.getNextRow();
    }
    if (booksContainer.children.isNotEmpty) booksContainer.children.last.classes.add("end");
  }

  /// List matching publications
  where = "1";
  if (keywords.isNotEmpty) where = generateWhereString(["name"], keywords);
  final DivElement articlesContainer = querySelector("#publications-container");
  response = await Messenger.post(new Request("get_rows", "publications", {"columns":"id, name, date, url_pdf, author", "order_by":"date DESC", "where":where}));

  if (response.isEmpty)
  {
    ParagraphElement noPublicationsMessage = new ParagraphElement();
    noPublicationsMessage.setInnerHtml("No publications found");
    articlesContainer.append(noPublicationsMessage);
  }
  else
  {
    row = response.getNextRow();
    while (row != null)
    {
      articlesContainer.append(DynamicHtml.generateArticleColumn(row));
      row = response.getNextRow();
    }
    if (articlesContainer.children.isNotEmpty) articlesContainer.children.last.classes.add("end");
  }
  Page.show();
}

String generateWhereString(List<String> columns, List<String> keywords)
{
  List<String> pairs = new List();
  columns.forEach((column) => pairs.add("$column LIKE " + keywords.join(" OR $column LIKE ")));
  return pairs.join(" OR ");
}