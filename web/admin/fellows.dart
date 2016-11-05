import 'dart:async';
import 'dart:html';
import 'lib/query_context.dart';
import '../lib/page.dart';
import 'lib/table.dart';

final ButtonElement add = querySelector("#add");
final TextInputElement firstname = querySelector("#firstname");
final TextInputElement lastname = querySelector("#lastname");
final EmailInputElement email = querySelector("#email");
final TelephoneInputElement phone = querySelector("#phone");
final TelephoneInputElement phone2 = querySelector("#phone_2");
final TextInputElement city = querySelector("#city");
final TextInputElement country = querySelector("#country");
final TextAreaElement descShort = querySelector("#description_short");
final TextAreaElement descLong = querySelector("#description_long");
final FileUploadInputElement image = querySelector("#image");
final FileUploadInputElement logo = querySelector("#logo");

final List<dynamic> inputElements = [firstname, lastname, email, phone, phone2, city, country, descShort, descLong];
final List<FileUploadInputElement> fileElements = [image, logo];

Future main() async
{
  Table table = new Table(querySelector("#table_container"));

  table.addColumnSet({"id":"firstname", "type":"input-text", "maxlength":"256", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"lastname", "type":"input-text", "maxlength":"256", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"email", "type":"input-email", "maxlength":"256", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"phone", "type":"input-text", "maxlength":"32", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"phone_2", "type":"input-text", "maxlength":"32", "width":"15em"});
  table.addColumnSet({"id":"city", "type":"input-text", "maxlength":"128", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"country", "type":"input-text", "maxlength":"128", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"description_short", "type":"input-textarea", "maxlength":"1024", "required":"1", "width":"20em", "rows":"3"});
  table.addColumnSet({"id":"description_long", "type":"input-textarea", "maxlength":"2048", "required":"1", "width":"30em", "rows":"3"});
  table.addColumnSet({"id":"image", "type":"input-file", "required":"1", "accept":".jpg", "width":"13em"});
  table.addColumnSet({"id":"logo", "type":"input-file", "required":"0", "accept":".png", "width":"13em"});
  await table.qLoad("get_rows", "fellows", "firstname DESC, lastname DESC");

  add.onClick.listen((_) async => await QueryContext.qAdd(add, "fellows", inputElements, fileElements));

  Page.show();
}






