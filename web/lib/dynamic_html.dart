library dynamic_html;

import 'dart:html';

import 'messenger.dart';
import 'page.dart';
import 'utility.dart';

class DynamicHtml {
  static DivElement generateArticleColumn(Map<String, String> data) {
    DivElement column = DivElement();
    DivElement content = DivElement();
    HeadingElement name = HeadingElement.h4();
    ParagraphElement dateAndAuthor = ParagraphElement();
    DivElement pdfLink = DivElement();
    DivElement viewPdfContainer = DivElement();
    ImageElement viewPdfIcon = ImageElement(src: "gfx/blue_arrow.png")
      ..className = "arrow";
    SpanElement viewPdfLabel = SpanElement();
    ParagraphElement shareButtonsContainer = ParagraphElement();
    shareButtonsContainer.className = "share-buttons-container";

    content.append(name);
    content.append(dateAndAuthor);
    content.append(pdfLink);

    pdfLink.append(viewPdfContainer);
    viewPdfContainer.append(viewPdfIcon);
    viewPdfContainer.append(viewPdfLabel);
    if (data.containsKey("icon") && data["icon"] != null) {
      ImageElement icon = ImageElement();
      icon.src = data["icon"];
      if (data.containsKey("url_publisher") && data["url_publisher"] != null) {
        icon.onClick.listen((e) {
          window.open(data["url_publisher"], "_blank");
        });
      }
      icon.className = "icon";
      viewPdfContainer.append(icon);
    }
    content.append(shareButtonsContainer);

    column.className = "large-6 columns article-column";
    name.className = "color-2 bold no-margin";
    dateAndAuthor.className = "link_description normal no-margin";
    viewPdfContainer.className =
        "pdf_download_button background-color-3-light color-2";
    viewPdfLabel.className = "normal";
    pdfLink.className = "clickable inline";

    name.setInnerHtml(data["name"]);
    DateTime dt = DateTime.parse(data["date"]);
    String dateFormatted = Utility.dfMonthYear.format(dt);

    //String author = (data["author"] == null) ? "" : data["author"];
    if (data["author"] != null)
      dateAndAuthor.setInnerHtml("${data["author"]}, $dateFormatted");
    else
      dateAndAuthor.setInnerHtml(dateFormatted);

    //dateAndAuthor.setInnerHtml("$author, $dateFormatted");

    viewPdfLabel.setInnerHtml(" view PDF");
    pdfLink.onClick
        .listen((MouseEvent e) async => window.open(data["url_pdf"], "_blank"));

    ImageElement shareEmailImage = ImageElement(src: "gfx/email-icon.png")
      ..className = "email-icon float-right";
    AnchorElement shareEmailAnchor = AnchorElement();
    String subject = data["name"];
    String link = data["url_pdf"];
    shareEmailAnchor.href = "mailto:?Subject=$subject&body=$link";
    shareEmailAnchor.append(shareEmailImage);
    shareButtonsContainer.append(shareEmailAnchor);

    DivElement shareFacebook = DivElement();
    shareFacebook.className = "fb-share-button float-right";
    shareFacebook.dataset["href"] = link;
    shareFacebook.dataset["layout"] = "button";
    shareFacebook.dataset["size"] = "small";
    shareFacebook.dataset["mobile-iframe"] = "true";
    AnchorElement shareFacebookAnchor =
        AnchorElement(href: "https://www.facebook.com/sharer/sharer.php?$link");
    shareFacebookAnchor.className = "fb-xfbml-parse-ignore";
    shareFacebookAnchor.target = "_blank";
    shareFacebook.append(shareFacebookAnchor);
    shareButtonsContainer.append(shareFacebook);

    DivElement linkedInScriptContainer = DivElement()
      ..className = "float-right";
    ScriptElement linkedInScript = ScriptElement();
    linkedInScript.type = "IN/Share";
    linkedInScript.dataset["url"] = link;
    linkedInScript.className = "float-right";
    linkedInScriptContainer.append(linkedInScript);
    shareButtonsContainer.append(linkedInScriptContainer);

    column.append(content);
    return column;
  }

  static DivElement generateArticleRow(Map<String, String> data) {
    DivElement row = DivElement();
    DivElement col1 = DivElement();
    DivElement col2 = DivElement();
    HeadingElement name = HeadingElement.h4();
    SpanElement date = SpanElement();
    DivElement pdfLink = DivElement();
    DivElement viewPdfContainer = DivElement();
    ImageElement viewPdfIcon = ImageElement(src: "gfx/blue_arrow.png")
      ..className = "arrow";
    SpanElement viewPdfLabel = SpanElement();
    row.append(col1);
    row.append(col2);
    col2.append(name);
    col2.append(date);
    col2.append(pdfLink);
    pdfLink.append(viewPdfContainer);
    viewPdfContainer.append(viewPdfIcon);
    viewPdfContainer.append(viewPdfLabel);

    row.className = "bold row collapse";
    col1.className = "small-1 columns";
    col2.className = "small-11 columns";
    name.className = "color-2 bold no-margin";
    date.className = "link_description normal";
    viewPdfContainer.className =
        "pdf_download_button background-color-3-light color-2";
    viewPdfLabel.className = "normal";
    pdfLink.className = "clickable inline";

    col1.setInnerHtml("&raquo;");
    name.setInnerHtml(data["name"]);

    DateTime dt = DateTime.parse(data["date"]);
    date.setInnerHtml(Utility.dfMonthYear.format(dt));

    /// TODO phrase
    viewPdfLabel.setInnerHtml(" view PDF");

    pdfLink.onClick
        .listen((MouseEvent e) async => window.open(data["url_pdf"], "_blank"));

    return row;
  }

  static DivElement generateBookColumn(Map<String, String> data) {
    DivElement column = DivElement();
    DivElement row1 = DivElement();
    DivElement col1 = DivElement();
    ImageElement cover = ImageElement(src: data["image"]);
    DivElement col2 = DivElement();
    HeadingElement title = HeadingElement.h4();
    ParagraphElement info = ParagraphElement();

    column.append(row1);
    row1.append(col1);
    row1.append(col2);
    col1.append(cover);
    col2.append(title);
    col2.append(info);

    column.className =
        "large-6 large-offset-0 medium-10 medium-offset-1 columns";
    row1.className = "row";

    col1.className = "right-blue-border small-6 columns book-column";
    col2.className = "small-6 columns book-column";
    title.className = "bolder color-1 no-margin";
    info.className = "text-left";

    cover.alt = data["name"];
    title.setInnerHtml(data["name"].toUpperCase());
    info.setInnerHtml(
        "<strong>Author:</strong><br />${data["author"]}<br /><strong>Format:</strong><br />${data["format"]}");

    if (data["brief"] != null && data["brief"].isNotEmpty) {
      ParagraphElement toggle = ParagraphElement();
      col2.append(toggle);
      DivElement row2 = DivElement();
      DivElement col3 = DivElement();
      ParagraphElement brief = ParagraphElement();
      column.append(row2);
      row2.append(col3);
      col3.append(brief);
      row2.className = "row is-hidden no-margin";
      col3.className = "columns";
      toggle.className = "clickable";
      brief.className = "book-brief";
      toggle.setInnerHtml("&lt;Read more&gt;");
      brief.setInnerHtml(data["brief"], validator: Page.htmlValidator);
      toggle.onClick.listen((MouseEvent e) {
        if (e.button == 0) {
          if (row2.classes.contains("is-hidden")) {
            row2.classes.remove("is-hidden");
            toggle.setInnerHtml("&lt;Show less&gt;");
          } else {
            row2.classes.add("is-hidden");
            toggle.setInnerHtml("&lt;Read more&gt;");
          }
        }
      });
    }

    return column;
  }

  static DivElement generateEventRow(Map<String, String> data,
      [bool sign_up = false]) {
    DivElement row = DivElement();
    DivElement column = DivElement();
    HeadingElement name = HeadingElement.h4();
    DivElement description = DivElement();
    SpanElement where = SpanElement();
    description.append(where);
    column.append(name);
    column.append(description);
    if (data["has_pdf"] == "1" ||
        (data["url_readmore"] != null && data["url_readmore"].isNotEmpty)) {
      ButtonElement readMore = ButtonElement();
      readMore.setInnerHtml("Read more");
      readMore.className = "large-margin-left-1";
      if (data["has_pdf"] == "1") {
        readMore.onClick.listen((MouseEvent e) async {
          if (e.button == 0) {
            WindowBase w = window.open("loading.html", "_blank");
            Request req = Request("get_rows", "events", {
              "columns": "id, pdf",
              "where": "id=${data["id"]}",
              "limit": "1"
            });
            Response r = await Messenger.post(req);
            if (r.success && !r.isEmpty) {
              Map<String, String> row = r.getNextRow();
              if (row["pdf"] != null) w.location.href = row["pdf"];
            }
          }
        });
      } else if (data["url_readmore"] != null) {
        readMore.onClick.listen((MouseEvent e) {
          window.open(data["url_readmore"], "_blank");
        });
      }
      column.append(readMore);
    }
    row.append(column);

    row.className = "row";
    column.className = "columns";
    name.className = "bold color-2 no-margin";
    description.className = "large-margin-left-1 link_description";

    DateTime dateStart = DateTime.parse(data["date_start"]);
    DateTime dateEnd = DateTime.parse(data["date_end"]);

    String dateString;
    String day = Utility.dfDay.format(dateStart);
    day += Utility.getDayOfMonthSuffix(int.parse(day));
    String day_end = Utility.dfDay.format(dateEnd);
    day_end += Utility.getDayOfMonthSuffix(int.parse(day_end));
    String monthYear = Utility.dfMonthYear.format(dateStart);

    if (dateEnd.difference(dateStart).inDays > 0) {
      if (dateStart.month == dateEnd.month) {
        /// Start/end date are in same month
        dateString = "$day - $day_end  of $monthYear";
      } else {
        /// Course start/end are on different months
        String monthStart = Utility.dfMonth.format(dateStart);
        String monthYearEnd = Utility.dfMonthYear.format(dateEnd);
        dateString = "$day $monthStart - $day_end $monthYearEnd";
      }
    } else
      dateString = "$day $monthYear";

    name.setInnerHtml("&raquo;&nbsp;&nbsp;${data["name"]}",
        validator: Page.htmlValidator);
    where.setInnerHtml(
        "${data["city"]}, ${data["country"]} ($dateString) - in ${data["lang"]}");

    if (sign_up == true) {
      ButtonElement signUp = ButtonElement();
      column.append(signUp);
      signUp.className = "large-margin-left-1";
      signUp.setInnerHtml("Register");

      signUp.onClick.listen((MouseEvent e) {
        if (e.button == 0) {
          window.open(data["url_signup"], "_blank");
        }
      });
    }

    return row;
  }

  static DivElement generateFellowRow(Map<String, String> data) {
    DivElement row = DivElement();
    DivElement column = DivElement();
    DivElement row1 = DivElement();
    DivElement hidden = DivElement();
    DivElement row2 = DivElement();
    DivElement row3 = DivElement();
    DivElement row4 = DivElement();
    DivElement row4Column = DivElement();
    DivElement row5 = DivElement();
    DivElement row5Column = DivElement();

    row.append(column);
    column.append(row1);
    column.append(hidden);
    hidden.append(row2);
    hidden.append(row3);
    hidden.append(row4);
    column.append(row5);
    row.className = "row margin-top-0-5 margin-bottom-0-5 collapse";
    hidden.className = "is-hidden";

    /// Row 1 (name + short desc + toggle)
    DivElement row1Col = DivElement();
    HeadingElement name = HeadingElement.h4();
    ParagraphElement shortDescription = ParagraphElement();
    shortDescription.className = "no-margin";
    ParagraphElement toggle = ParagraphElement();

    row1.append(row1Col);
    row1Col.append(name);
    row1Col.append(shortDescription);

    row1.className = "row no-margin";
    row1Col.className = "columns";

    name.className = "color-1 bolder";
    toggle.className = "clickable no-margin color-1";
    name.setInnerHtml("${data["firstname"]} ${data["lastname"]}");
    shortDescription.setInnerHtml(data["description_short"]);
    toggle.setInnerHtml("&lt;Read more&gt;");

    toggle.onClick.listen((MouseEvent e) {
      if (e.button == 0) {
        if (hidden.classes.contains("is-hidden")) {
          hidden.classes.remove("is-hidden");
          toggle.setInnerHtml("&lt;Show less&gt;");
        } else {
          hidden.classes.add("is-hidden");
          toggle.setInnerHtml("&lt;Read more&gt;");
        }
      }
    });

    /// Row 2 (long description)
    DivElement row2Col = DivElement();
    ParagraphElement longDescription = ParagraphElement();
    row2.append(row2Col);
    row2Col.append(longDescription);
    ImageElement portrait_image = ImageElement(src: data["image"]);

    row2.className = "row";
    row2Col.className = "columns";
    longDescription.setInnerHtml(data["description_long"]);

    /// Row 3 (portrait + contact info)
    DivElement row3Col1 = DivElement();
    DivElement row3Col2 = DivElement();
    DivElement portrait = DivElement();
    portrait.append(portrait_image);
    HeadingElement contactHeader = HeadingElement.h5();
    AnchorElement email = AnchorElement(href: "mailto:" + data["email"]);
    ParagraphElement phone = ParagraphElement();

    row3.append(row3Col1);
    row3Col1.append(portrait);
    row3.append(row3Col2);
    row3Col2.append(contactHeader);
    row3Col2.append(email);
    row3Col2.append(phone);

    if (data.containsKey("logo")) {
      ImageElement logo = ImageElement(src: data["logo"])
        ..className = "fellow-logo";
      row4Column.append(logo);
    }
    row4.append(row4Column);

    row5.append(row5Column);
    row5Column.append(toggle);

    row3.className = "row no-margin";
    row3Col1.className = "large-2 medium-3 small-4 columns";
    row3Col2.className = "large-10 medium-9 small-8 columns";
    contactHeader.className = "bold";
    row5.className = "row no-margin";
    row5Column.className = "columns";
    contactHeader.setInnerHtml("Contact");
    email.setInnerHtml(data["email"]);
    phone.setInnerHtml("${data["phone"]} <br />${data["phone_2"]}");

    return row;
  }
}
