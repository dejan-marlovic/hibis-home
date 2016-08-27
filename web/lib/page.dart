library page;

import 'dart:async';
import 'dart:html';

class Page
{
  static Future init() async
  {
    if (header != null) await importHtml("inc-header.html", header);
    if (footer != null) await importHtml("inc-footer.html", footer);


  }

  static Future importHtml(String source, DivElement into) async
  {
    HttpRequest req = new HttpRequest();
    HttpRequest.getString(source, withCredentials: false);


  }


  static final DivElement header = querySelector("#header");
  static final DivElement footer = querySelector("#footer");


}