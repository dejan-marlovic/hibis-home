// Copyright (c) 2016, Hibis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library page;

import 'dart:async';
import 'dart:html';
import 'messenger.dart';

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

      /// List latest publications
      Response response = await Messenger.post(new Request("get_rows", "publications", {"columns":"name, date, url_pdf", "order_by":"id DESC", "limit":"3"}));
      Map<String, String> row = response.getNextRow();
      while (row != null)
      {
        print(row);
        row = response.getNextRow();
      }
    }
    else if (panelRightSmall != null)
    {

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


    /*

    <div class="bold row collapse">
                <div class="small-1 columns">
                    <span>&raquo;</span>
                </div>
                <div class="small-11 columns">
                    <a><h4 class="color-2 bold no-margin lang-exp" data-exp=blinkers_off_counter-fraud_pdf_link">"Blinkers off":counter-fraud,is it a self-serving profession"</h4></a>
                    <span class="link_description normal">April - May 2016</span>
                    <a>
                        <div class="pdf_download_button background-color-3-light color-2">
                            <img src="gfx/blue_arrow.png"/>
                            <span class="normal langexp" data-exp="view_pdf"> view PDF</span>
                        </div>
                    </a>
                </div>
            </div>


     */


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