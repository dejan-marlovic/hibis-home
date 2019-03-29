import 'dart:async';
import 'dart:html';
import '../lib/page.dart';
import 'lib/table.dart';
import 'lib/query_context.dart';

final ButtonElement add = querySelector("#add");
final TextInputElement name = querySelector("#name");
final TextInputElement publisher = querySelector("#publisher");
final DateInputElement date = querySelector("#date");
final TextAreaElement brief = querySelector("#brief");
final UrlInputElement urlInfo = querySelector("#url_info");
final UrlInputElement urlPublisher = querySelector("#url_publisher");
final FileUploadInputElement pdf = querySelector("#pdf");
final FileUploadInputElement icon = querySelector("#icon");

final List<dynamic> inputElements = [
  name,
  publisher,
  date,
  brief,
  urlInfo,
  urlPublisher
];
final List<FileUploadInputElement> fileElements = [pdf, icon];

Future main() async {
  Table table = Table(querySelector("#table_container"));

  table.addColumnSet({
    "id": "name",
    "type": "input-text",
    "maxlength": "128",
    "required": "1",
    "width": "30em"
  });
  table.addColumnSet({
    "id": "brief",
    "type": "input-textarea",
    "maxlength": "1024",
    "width": "30em",
    "rows": "3"
  });
  table.addColumnSet({
    "id": "url_info",
    "type": "input-url",
    "maxlength": "256",
    "width": "20em"
  });
  table.addColumnSet(
      {"id": "pdf", "type": "input-file", "accept": ".pdf", "width": "13em"});
  table.addColumnSet({
    "id": "icon",
    "type": "input-file",
    "accept": ".png, .jpg",
    "width": "13em"
  });
  table.addColumnSet({"id": "date", "type": "input-date", "required": "1"});
  table.addColumnSet({
    "id": "publisher",
    "type": "input-text",
    "maxlength": "256",
    "required": "1",
    "width": "15em"
  });
  table.addColumnSet({
    "id": "url_publisher",
    "type": "input-url",
    "maxlength": "256",
    "width": "20em"
  });
  await table.qLoad("get_rows", "publications", "date DESC");

  add.onClick.listen((_) async => await QueryContext.qAdd(
      add, "publications", inputElements, fileElements));

  Page.show();
}
