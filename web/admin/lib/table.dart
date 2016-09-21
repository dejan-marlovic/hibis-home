import 'dart:async';
import 'dart:html';
import 'query_context.dart';
import '../../lib/messenger.dart';


class Table
{
  Table(this._container)
  {
    _columnSet.add({"id":"id", "type":"text"});

  }

  void addColumnSet(Map<String, String> properties)
  {
    _columnSet.add(properties);
  }

  Future qLoad(String msg, String system, String order_by) async
  {
    _system = system;
    _container.children.clear();
    TableElement table = new TableElement();
    TableSectionElement head = table.createTHead();
    TableRowElement headRow = new TableRowElement();
    head.append(headRow);
    TableSectionElement body = table.createTBody();
    _container.append(table);

    List<String> columnList = new List();
    _columnSet.forEach((row)
    {
      TableCellElement td = new TableCellElement();
      td.setInnerHtml(row["id"]);
      if (row["required"] == "1") td.classes.add("required");
      headRow.append(td);
      columnList.add(row["id"]);
    });

    /// Add buttons column
    TableCellElement td = new TableCellElement();
    td.setInnerHtml("Actions");
    headRow.append(td);

    Request req = new Request(msg, _system, {"columns":columnList.join(", "), "order_by":order_by});
    Response r = await Messenger.post(req);


    Map<String, String> publicationData = r.getNextRow();
    while (publicationData != null)
    {
      String id = publicationData["id"];
      TableRowElement tr = new TableRowElement();
      _columnSet.forEach((row)
      {
        TableCellElement td = new TableCellElement();
        String value = publicationData[row["id"]];
        switch (row["type"])
        {
          case "input-date":
            td.append(_generateInputDate(row, value, id));
            break;

          case "input-email":
            td.append(_generateInputEmail(row, value, id));
            break;

          case "input-file":
            td.append(_generateInputFile(row, value, id));
            break;

          case "input-text":
            td.append(_generateInputText(row, value, id));
            break;

          case "input-textarea":
            td.append(_generateInputTextArea(row, value, id));
            break;

          case "input-url":
            td.append(_generateInputUrl(row, value, id));
            break;

          case "text":
            td.setInnerHtml(value);
            break;
        }

        tr.append(td);
      });

      TableCellElement td = new TableCellElement();
      ButtonElement delete = new ButtonElement();
      delete.className = "button";
      delete.setInnerHtml("Delete");

      delete.onClick.listen((_) async => await _qDelete(id));

      td.append(delete);
      tr.append(td);

      body.append(tr);
      publicationData = r.getNextRow();
    }
  }

  Future _qDelete(String id) async
  {
    await Messenger.post(new Request("delete", _system, {"id":id}));
    window.location.reload();
  }

  DateInputElement _generateInputDate(Map<String, String> properties, String value, String row_id)
  {
    DateInputElement input = new DateInputElement();
    _defaultProperties(properties, input);
    _defaultInputProperties(properties, input, value);
    _defaultUpdate(input, properties["id"], row_id);
    return input;
  }

  EmailInputElement _generateInputEmail(Map<String, String> properties, String value, String row_id)
  {
    EmailInputElement input = new EmailInputElement();
    _defaultProperties(properties, input);
    _defaultInputProperties(properties, input, value);
    _defaultUpdate(input, properties["id"], row_id);
    return input;
  }

  DivElement _generateInputFile(Map<String, String> properties, String value, String row_id)
  {
    DivElement container = new DivElement();
    ImageElement thumb = new ImageElement();
    thumb.className = "thumb";
    if (value != null)
    {
      if (value.startsWith("data:image/")) thumb.src = value;
      else thumb.src = "../gfx/pdf-icon.png";

      container.append(thumb);
    }

    FileUploadInputElement input = new FileUploadInputElement();

    container.append(input);
    _defaultProperties(properties, input);
    if (properties["required"] == "1") input.required = true;
    if (properties["accept"] != null) input.accept = properties["accept"];

    input.onChange.listen((_)
    {
      if (_system == null) return;
      input.disabled = true;
      FileReader reader = new FileReader();
      reader.readAsDataUrl(input.files.first);
      reader.onLoad.listen((_) async
      {
        await Messenger.post(new Request("update", _system, {"column":properties["id"], "value":reader.result, "id":row_id}));
        if (reader.result.toString().startsWith("data:image/")) thumb.src = reader.result;
        else thumb.src = "../gfx/pdf-icon.png";
        input.disabled = false;
      });
    });

    return container;
  }

  TextInputElement _generateInputText(Map<String, String> properties, String value, String row_id)
  {
    TextInputElement input = new TextInputElement();
    _defaultProperties(properties, input);
    _defaultInputProperties(properties, input, value);
    _defaultUpdate(input, properties["id"], row_id);
    if (properties["maxlength"] != null) input.maxLength = int.parse(properties["maxlength"]);
    return input;
  }

  TextAreaElement _generateInputTextArea(Map<String, String> properties, String value, String row_id)
  {
    TextAreaElement input = new TextAreaElement();
    _defaultProperties(properties, input);
    _defaultInputProperties(properties, input, value);
    _defaultUpdate(input, properties["id"], row_id);
    if (properties["maxlength"] != null) input.maxLength = int.parse(properties["maxlength"]);
    if (properties["rows"] != null) input.rows = int.parse(properties["rows"]);

    return input;
  }

  UrlInputElement _generateInputUrl(Map<String, String> properties, String value, String row_id)
  {
    UrlInputElement input = new UrlInputElement();
    _defaultProperties(properties, input);
    _defaultInputProperties(properties, input, value);
    _defaultUpdate(input, properties["id"], row_id);
    if (properties["maxlength"] != null) input.maxLength = int.parse(properties["maxlength"]);
    return input;
  }

  void _defaultProperties(Map<String, String> properties, Element element)
  {
    if (properties["width"] != null) element.style.width = properties["width"];
  }

  void _defaultInputProperties(Map<String, String> properties, dynamic input, String value)
  {
    if (properties["required"] == "1") input.required = true;
    input.value = value;
  }

  void _defaultUpdate(dynamic element, String column, String id)
  {
    element.onBlur.listen((_) async
    {
      element.disabled = true;
      await _qUpdateColumn(column, element.value, id);
      element.disabled = false;
    });
  }

  Future _qUpdateColumn(String column, String value, String row_id) async
  {
    if (_system == null) return;
    await Messenger.post(new Request("update", _system, {"column":column, "value":value, "id":row_id}));
  }


  List<Map<String, String>> _columnSet = new List();
  final DivElement _container;
  String _system;
}