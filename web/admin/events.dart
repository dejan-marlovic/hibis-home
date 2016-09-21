import 'dart:async';
import 'dart:html';
import 'lib/query_context.dart';
import '../lib/page.dart';
import 'lib/table.dart';

final ButtonElement add = querySelector("#add");
final TextInputElement name = querySelector("#name");
final TextAreaElement description = querySelector("#description");
final UrlInputElement urlDescription = querySelector("#url_description");
final UrlInputElement urlSignup = querySelector("#url_signup");
final DateInputElement dateStart = querySelector("#date_start");
final DateInputElement dateEnd = querySelector("#date_end");
final TextInputElement street = querySelector("#street");
final TextInputElement city = querySelector("#city");
final TextInputElement country = querySelector("#country");
final TextInputElement language = querySelector("#lang");
final FileUploadInputElement pdf = querySelector("#pdf");

final List<dynamic> inputElements = [name, description, urlDescription, urlSignup, dateStart, dateEnd, street, city, country, language];
final List<FileUploadInputElement> fileElements = [pdf];

Future main() async
{
  Table table = new Table(querySelector("#table_container"));

  table.addColumnSet({"id":"name", "type":"input-text", "maxlength":"256", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"description", "type":"input-textarea", "maxlength":"1024", "rows":"3", "width":"30em"});
  table.addColumnSet({"id":"url_description", "type":"input-url", "maxlength":"256", "width":"30em"});
  table.addColumnSet({"id":"url_signup", "type":"input-url", "required":"1", "maxlength":"256", "width":"30em"});
  table.addColumnSet({"id":"date_start", "type":"input-date", "required":"1"});
  table.addColumnSet({"id":"date_end", "type":"input-date", "required":"1"});
  table.addColumnSet({"id":"street", "type":"input-text", "maxlength":"128", "required":"1", "width":"10em"});
  table.addColumnSet({"id":"city", "type":"input-text", "maxlength":"128", "required":"1", "width":"10em"});
  table.addColumnSet({"id":"country", "type":"input-text", "maxlength":"256", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"lang", "type":"input-text", "maxlength":"128", "required":"1", "width":"10em"});
  table.addColumnSet({"id":"pdf", "type":"input-file", "accept":".pdf", "required":"1", "width":"13em"});
  await table.qLoad("get_rows", "events", "date_start DESC");

  add.onClick.listen((_) async => await QueryContext.qAdd(add, "events", inputElements, fileElements));

  Page.show();
}






