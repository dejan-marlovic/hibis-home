library dynamic_html;
import 'dart:html';
import 'utility.dart';

class DynamicHtml
{
  static DivElement generateArticleColumn(Map<String, String> data)
  {
    DivElement column = new DivElement();
    HeadingElement name = new HeadingElement.h4();
    ParagraphElement date = new ParagraphElement();
    AnchorElement link = new AnchorElement(href:data["url_pdf"]);
    DivElement viewPdfContainer = new DivElement();
    ImageElement viewPdfIcon = new ImageElement(src:"gfx/blue_arrow.png");
    SpanElement viewPdfLabel = new SpanElement();

    column.append(name);
    column.append(date);
    column.append(link);
    link.append(viewPdfContainer);
    viewPdfContainer.append(viewPdfIcon);
    viewPdfContainer.append(viewPdfLabel);

    column.className = "large-6 columns article-column";
    name.className = "color-2 bold no-margin";
    date.className = "link_description normal no-margin";
    viewPdfContainer.className = "pdf_download_button background-color-3-light color-2";
    viewPdfLabel.className = "normal";

    name.setInnerHtml(data["name"]);
    DateTime dt = DateTime.parse(data["date"]);
    date.setInnerHtml(Utility.dfMonthYear.format(dt));
    /// TODO phrase
    viewPdfLabel.setInnerHtml(" view PDF");


    return column;
  }

  static DivElement generateArticleRow(Map<String, String> data)
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

  static DivElement generateBookColumn(Map<String, String> data)
  {
    DivElement column = new DivElement();
    DivElement row1 = new DivElement();
    DivElement col1 = new DivElement();
    ImageElement cover = new ImageElement(src:data["image_url"]);
    DivElement col2 = new DivElement();
    HeadingElement title = new HeadingElement.h4();
    ParagraphElement info = new ParagraphElement();

    column.append(row1);
    row1.append(col1);
    row1.append(col2);
    col1.append(cover);
    col2.append(title);
    col2.append(info);

    column.className = "large-6 large-offset-0 medium-10 medium-offset-1 columns";
    row1.className = "row";

    col1.className = "right-blue-border small-6 columns book-column";
    col2.className = "small-6 columns book-column";
    title.className = "bolder color-1 no-margin";
    info.className = "text-left";

    cover.alt = data["name"];
    title.setInnerHtml(data["name"].toUpperCase());
    info.setInnerHtml("<strong>Author:</strong><br />${data["author"]}<br /><strong>Format:</strong><br />${data["format"]}");

    if (data["brief"] != null && data["brief"].isNotEmpty)
    {
      ParagraphElement toggle = new ParagraphElement();
      col2.append(toggle);
      DivElement row2 = new DivElement();
      DivElement col3 = new DivElement();
      ParagraphElement brief = new ParagraphElement();
      column.append(row2);
      row2.append(col3);
      col3.append(brief);
      row2.className = "row is-hidden no-margin";
      col3.className = "columns";
      toggle.className = "clickable";
      brief.className = "book-brief";
      toggle.setInnerHtml("&lt;Read more&gt;");
      brief.setInnerHtml(data["brief"]);
      toggle.onClick.listen((MouseEvent e)
      {
        if (e.button == 0)
        {
          if (row2.classes.contains("is-hidden"))
          {
            row2.classes.remove("is-hidden");
            toggle.setInnerHtml("&lt;Show less&gt;");
          }
          else
          {
            row2.classes.add("is-hidden");
            toggle.setInnerHtml("&lt;Read more&gt;");
          }
        }
      });
    }



    return column;
  }

  static DivElement generateEventRow(Map<String, String> data, [bool signup = false])
  {
    DivElement row = new DivElement();
    DivElement column = new DivElement();
    HeadingElement name = new HeadingElement.h4();
    DivElement description = new DivElement();
    SpanElement where = new SpanElement();
    ButtonElement readMore = new ButtonElement();
    description.append(where);
    column.append(name);
    column.append(description);
    column.append(readMore);
    row.append(column);

    row.className = "row";
    column.className = "columns";
    name.className = "bold color-2 no-margin";
    description.className = "large-margin-left-1 link_description";
    readMore.className = "large-margin-left-1";

    DateTime dateStart = DateTime.parse(data["date_start"]);
    DateTime dateEnd = DateTime.parse(data["date_end"]);

    String dateString;

    if (dateStart.difference(dateEnd).inDays < 1)
    {
      String day = Utility.dfDay.format(dateStart);
      day += Utility.getDayOfMonthSuffix(int.parse(day));
      String monthYear = Utility.dfMonthYear.format(dateStart);
      dateString = "$day $monthYear";
    }
    else if (dateStart.month == dateEnd.month)
    {
      /// Start/end date are in same month
      String dayStart = Utility.dfDay.format(dateStart);
      String dayEnd = Utility.dfDay.format(dateEnd);
      String monthYear = Utility.dfMonthYear.format(dateStart);
      dayStart += Utility.getDayOfMonthSuffix(int.parse(dayStart));
      dayEnd += Utility.getDayOfMonthSuffix(int.parse(dayEnd));
      dateString = "$dayStart - $dayEnd $monthYear";
    }
    else
    {
      /// Course start/end are on different months
      String dayStart = Utility.dfDay.format(dateStart);
      String dayEnd = Utility.dfDay.format(dateEnd);
      dayStart += Utility.getDayOfMonthSuffix(int.parse(dayStart));
      dayEnd += Utility.getDayOfMonthSuffix(int.parse(dayEnd));
      String monthStart = Utility.dfMonth.format(dateStart);
      String monthYearEnd = Utility.dfMonthYear.format(dateEnd);
      dateString = "$dateStart $monthStart - $dayEnd $monthYearEnd";
    }

    name.setInnerHtml("&raquo;&nbsp;&nbsp;${data["name"]}");
    where.setInnerHtml("${data["city"]}, ${data["country"]} ($dateString) - in ${data["lang"]}");
    /// TODO phrase this
    readMore.setInnerHtml("Read more");
    readMore.onClick.listen((MouseEvent e)
    {
      if (e.button == 0) /// LMB
      {
        window.open(data["url_pdf"], data["name"]);
      }
    });

    if (signup == true)
    {
      ButtonElement signUp = new ButtonElement();
      column.append(signUp);
      signUp.className = "large-margin-left-1";
      signUp.setInnerHtml("Sign up");

      signUp.onClick.listen((MouseEvent e)
      {
        if (e.button == 0)
        {
          window.open(data["url_signup"], data["name"]);
        }
      });

    }


    return row;
  }
}