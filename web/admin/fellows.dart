import 'dart:async';
import 'dart:html';

import '../lib/page.dart';
import 'lib/query_context.dart';
import 'lib/table.dart';

Future main() async {
  final table = Table(querySelector("#table_container"))
    ..addColumnSet({
      "id": "firstname",
      "type": "input-text",
      "maxlength": "256",
      "required": "1",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "lastname",
      "type": "input-text",
      "maxlength": "256",
      "required": "1",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "email",
      "type": "input-email",
      "maxlength": "256",
      "required": "1",
      "width": "30em"
    })
    ..addColumnSet({
      "id": "phone",
      "type": "input-text",
      "maxlength": "32",
      "required": "1",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "phone_2",
      "type": "input-text",
      "maxlength": "32",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "city",
      "type": "input-text",
      "maxlength": "128",
      "required": "1",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "country",
      "type": "input-text",
      "maxlength": "128",
      "required": "1",
      "width": "15em"
    })
    ..addColumnSet({
      "id": "description_short",
      "type": "input-textarea",
      "maxlength": "1024",
      "required": "1",
      "width": "20em",
      "rows": "3"
    })
    ..addColumnSet({
      "id": "description_long",
      "type": "input-textarea",
      "maxlength": "2048",
      "required": "1",
      "width": "30em",
      "rows": "3"
    })
    ..addColumnSet({
      "id": "image",
      "type": "input-file",
      "required": "1",
      "accept": ".jpg",
      "width": "13em"
    })
    ..addColumnSet({
      "id": "logo",
      "type": "input-file",
      "required": "0",
      "accept": ".png",
      "width": "13em"
    });
  await table.qLoad("get_rows", "fellows", "firstname DESC, lastname DESC");

  add.onClick.listen((_) async =>
      await QueryContext.qAdd(add, "fellows", inputElements, fileElements));

  Page.show();
}

final ButtonElement add = querySelector("#add");
final TextInputElement city = querySelector("#city");
final TextInputElement country = querySelector("#country");
final TextAreaElement descLong = querySelector("#description_long");
final TextAreaElement descShort = querySelector("#description_short");
final EmailInputElement email = querySelector("#email");
final List<FileUploadInputElement> fileElements = [image, logo];
final TextInputElement firstname = querySelector("#firstname");
final FileUploadInputElement image = querySelector("#image");
final List<dynamic> inputElements = [
  firstname,
  lastname,
  email,
  phone,
  phone2,
  city,
  country,
  descShort,
  descLong
];
final TextInputElement lastname = querySelector("#lastname");

final FileUploadInputElement logo = querySelector("#logo");
final TelephoneInputElement phone = querySelector("#phone");

final TelephoneInputElement phone2 = querySelector("#phone_2");
