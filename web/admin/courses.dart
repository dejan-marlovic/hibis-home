import 'dart:async';
import 'dart:html';
import 'lib/query_context.dart';
import '../lib/page.dart';
import 'lib/table.dart';

final ButtonElement add = querySelector("#add");
final TextInputElement name = querySelector("#name");
final TextInputElement descShort = querySelector("#description_short");
final TextAreaElement descLong = querySelector("#description_long");
final UrlInputElement urlInfo = querySelector("#info");
final FileUploadInputElement pdf = querySelector("#pdf");

final List<dynamic> inputElements = [name, descShort, descLong, urlInfo];
final List<FileUploadInputElement> fileElements = [pdf];

Future main() async
{

  Table table = new Table(querySelector("#table_container"));

  table.addColumnSet({"id":"name", "type":"input-text", "maxlength":"128", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"description_short", "type":"input-text", "maxlength":"1024", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"description_long", "type":"input-textarea", "maxlength":"4096", "required":"1", "width":"30em", "rows":"4"});
  table.addColumnSet({"id":"url_info", "type":"input-url", "maxlength":"256", "required":"1", "width":"20em"});
  table.addColumnSet({"id":"pdf", "type":"input-file", "accept":".pdf", "width":"13em", "required":"1"});


  await table.qLoad("get_rows", "courses", "name DESC");

  add.onClick.listen((_) async => await QueryContext.qAdd(add, "courses", inputElements, fileElements));

  Page.show();
}






