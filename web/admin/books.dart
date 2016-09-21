import 'dart:async';
import 'dart:html';
import 'lib/query_context.dart';
import '../lib/page.dart';
import 'lib/table.dart';

final ButtonElement add = querySelector("#add");
final TextInputElement name = querySelector("#name");
final TextInputElement author = querySelector("#author");
final TextInputElement format = querySelector("#format");
final TextAreaElement brief = querySelector("#brief");
final FileUploadInputElement image = querySelector("#image");

final List<dynamic> inputElements = [name, author, format, brief];
final List<FileUploadInputElement> fileElements = [image];

Future main() async
{

  Table table = new Table(querySelector("#table_container"));

  table.addColumnSet({"id":"name", "type":"input-text", "maxlength":"256", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"author", "type":"input-text", "maxlength":"512", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"format", "type":"input-text", "maxlength":"128", "required":"1", "width":"20em"});
  table.addColumnSet({"id":"brief", "type":"input-textarea", "maxlength":"2046", "required":"1", "width":"30em", "rows":"4"});
  table.addColumnSet({"id":"image", "type":"input-file", "accept":".png, .jpg", "width":"13em"});
  await table.qLoad("get_rows", "books", "name DESC");

  add.onClick.listen((_) async => await QueryContext.qAdd(add, "books", inputElements, fileElements));

  Page.show();
}






