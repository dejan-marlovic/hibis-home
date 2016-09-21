import 'dart:async';
import 'dart:html';
import '../../lib/messenger.dart';

class QueryContext
{

  static Future qAdd(ButtonElement add, String system, List<dynamic> input_elements, List<dynamic> file_elements) async
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

    for (int i = 0; i < file_elements.length; i++)
    {
      if (!file_elements[i].validity.valid)
      {
        input_elements[i].focus();
        window.alert("${file_elements[i].validationMessage} (${file_elements[i].id})");
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

    loadFileUploadElementsRecursive(0, file_elements, system, params);
  }

  static void loadFileUploadElementsRecursive(int index, List<FileUploadInputElement> file_inputs, String system, Map<String, String> params)
  {
    if (index < file_inputs.length && file_inputs[index].files.isNotEmpty)
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



}