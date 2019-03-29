import 'dart:async';
import 'dart:html';

import '../lib/page.dart';
import 'lib/query_context.dart';
import 'lib/table.dart';

Future main() async {
  final table = Table(querySelector("#table_container"))
    ..addColumnSet({
      "id": "name",
      "type": "input-text",
      "maxlength": "256",
      "required": "1",
      "width": "30em"
    })
    ..addColumnSet({
      "id": "url_readmore",
      "type": "input-url",
      "maxlength": "256",
      "width": "30em"
    })
    ..addColumnSet({
      "id": "url_signup",
      "type": "input-url",
      "required": "1",
      "maxlength": "256",
      "width": "30em"
    })
    ..addColumnSet({"id": "date_start", "type": "input-date", "required": "1"})
    ..addColumnSet({"id": "date_end", "type": "input-date", "required": "1"})
    ..addColumnSet({
      "id": "street",
      "type": "input-text",
      "maxlength": "128",
      "required": "0",
      "width": "10em"
    })
    ..addColumnSet({
      "id": "city",
      "type": "input-text",
      "maxlength": "128",
      "required": "1",
      "width": "10em"
    })
    ..addColumnSet({
      "id": "country",
      "type": "input-text",
      "maxlength": "256",
      "required": "1",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "lang",
      "type": "input-text",
      "maxlength": "128",
      "required": "1",
      "width": "10em"
    })
    ..addColumnSet({
      "id": "pdf",
      "type": "input-file",
      "accept": ".pdf",
      "required": "1",
      "width": "13em"
    });
  await table.qLoad("get_rows", "events", "date_start DESC");

  add.onClick.listen((_) async =>
      await QueryContext.qAdd(add, "events", inputElements, fileElements));

  Page.show();
}

final ButtonElement add = querySelector("#add");
final TextInputElement city = querySelector("#city");
final TextInputElement country = querySelector("#country");
final DateInputElement dateEnd = querySelector("#date_end");
final DateInputElement dateStart = querySelector("#date_start");
final List<FileUploadInputElement> fileElements = [pdf];
final List<dynamic> inputElements = [
  name,
  urlReadMore,
  urlSignup,
  dateStart,
  dateEnd,
  street,
  city,
  country,
  language
];
final TextInputElement language = querySelector("#lang");
final TextInputElement name = querySelector("#name");
final FileUploadInputElement pdf = querySelector("#pdf");

final TextInputElement street = querySelector("#street");
final UrlInputElement urlReadMore = querySelector("#url_readmore");

final UrlInputElement urlSignup = querySelector("#url_signup");
