library event_manager;
import 'dart:html';
import 'utility.dart';

class EventManager
{
  static DivElement generateEventRowHtml(Map<String, String> data)
  {
    DivElement row = new DivElement();
    DivElement column = new DivElement();
    AnchorElement link = new AnchorElement();
    HeadingElement name = new HeadingElement.h4();
    DivElement description = new DivElement();
    SpanElement where = new SpanElement();
    ButtonElement readMore = new ButtonElement();
    link.append(name);
    description.append(where);
    column.append(link);
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

    if (dateStart.month == dateEnd.month)
    {
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

    link.href = data["url_signup"];
    link.target = "_blank";
    name.setInnerHtml("&raquo;&nbsp;&nbsp;&quot;${data["name"]}&quot;");
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

    return row;
  }
}