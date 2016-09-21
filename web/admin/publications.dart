import 'dart:async';
import 'dart:html';
import '../lib/messenger.dart';
import '../lib/page.dart';
import 'lib/table.dart';

final ButtonElement add = querySelector("#add");
final TextInputElement name = querySelector("#name");
final TextInputElement publisher = querySelector("#publisher");
final DateInputElement date = querySelector("#date");
final TextAreaElement brief = querySelector("#brief");
final UrlInputElement urlInfo = querySelector("#url_info");
final UrlInputElement urlPublisher = querySelector("#url_publisher");
final FileUploadInputElement pdf = querySelector("#pdf");
final FileUploadInputElement icon = querySelector("#icon");

final List<dynamic> inputElements = [name, publisher, date, brief, urlInfo, urlPublisher];
final List<FileUploadInputElement> fileElements = [pdf, icon];

Future main() async
{

  Table table = new Table(querySelector("#table_container"));

  table.addColumnSet({"id":"name", "type":"input-text", "maxlength":"128", "required":"1", "width":"30em"});
  table.addColumnSet({"id":"brief", "type":"input-textarea", "maxlength":"1024", "width":"30em", "rows":"3"});
  table.addColumnSet({"id":"url_info", "type":"input-url", "maxlength":"256", "width":"20em"});
  table.addColumnSet({"id":"pdf", "type":"input-file", "accept":".pdf", "width":"13em"});
  table.addColumnSet({"id":"icon", "type":"input-file", "accept":".png, .jpg", "width":"13em"});
  table.addColumnSet({"id":"date", "type":"input-date", "required":"1"});
  table.addColumnSet({"id":"publisher", "type":"input-text", "maxlength":"256", "required":"1", "width":"15em"});
  table.addColumnSet({"id":"url_publisher", "type":"input-url", "maxlength":"256", "width":"20em"});
  await table.qLoad("get_rows", "publications", "date DESC");

  add.onClick.listen((_) async => await qAdd("publications", inputElements));

  Page.show();
}

Future qAdd(String system, List<dynamic> input_elements) async
{
  Map<String, String> params = new Map();

  /// Validation check
  for (int i = 0; i < input_elements.length; i++)
  {
    if (!input_elements[i].validity.valid)
    {
      input_elements[i].focus();
      window.alert("${input_elements[i].validationMessage} (${input_elements[i].id})");
      return;
    }
  }

  /// Validation passed
  add.disabled = true;
  input_elements.forEach((e)
  {
    params[e.id] = e.value;
    e.disabled = true;
  });

  loadFileUploadElementsRecursive(0, fileElements, system, params);
}

void loadFileUploadElementsRecursive(int index, List<FileUploadInputElement> file_inputs, String system, Map<String, String> params)
{
  if (index < file_inputs.length)
  {
    FileReader reader = new FileReader();
    reader.readAsDataUrl(file_inputs[index].files.first);
    reader.onLoad.listen((_)
    {
      params[file_inputs[index].id] = reader.result;
      loadFileUploadElementsRecursive(index + 1, file_inputs, system, params);
    });
  }
  else Messenger.post(new Request("add", system, params)).then((_) => window.location.reload());
}
