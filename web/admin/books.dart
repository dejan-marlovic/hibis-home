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
      "id": "author",
      "type": "input-text",
      "maxlength": "512",
      "required": "1",
      "width": "30em"
    })
    ..addColumnSet({
      "id": "format",
      "type": "input-text",
      "maxlength": "128",
      "required": "1",
      "width": "20em"
    })
    ..addColumnSet({
      "id": "brief",
      "type": "input-textarea",
      "maxlength": "2046",
      "required": "1",
      "width": "30em",
      "rows": "4"
    })
    ..addColumnSet({
      "id": "image",
      "type": "input-file",
      "accept": ".png, .jpg",
      "width": "13em"
    });
  await table.qLoad("get_rows", "books", "name DESC");

  add.onClick.listen((_) async =>
      await QueryContext.qAdd(add, "books", inputElements, fileElements));

  Page.show();
}

final ButtonElement add = querySelector("#add");
final TextInputElement author = querySelector("#author");
final TextAreaElement brief = querySelector("#brief");
final List<FileUploadInputElement> fileElements = [image];
final TextInputElement format = querySelector("#format");

final FileUploadInputElement image = querySelector("#image");
final List<dynamic> inputElements = [name, author, format, brief];

final TextInputElement name = querySelector("#name");
