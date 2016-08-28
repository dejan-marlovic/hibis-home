library messenger;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

class Messenger
{
  static Future<Response> post(Request req) async
  {
    Map<String, String> post = new Map();
    post["msg"] = req.msg;
    post["system"] = req.system;
    post["params"] = req.paramsJSON;

    Map<String, String> headers = new Map();
    String auth = BASE64.encode(UTF8.encode("$_user:$_password"));
    headers["authorization"] = "Basic $auth";
    headers["content-type"] = "application/x-www-form-urlencoded";
    HttpRequest request = await HttpRequest.postFormData(parserUrl, post, requestHeaders: headers);
    Response response = new Response(request.responseText);
    return response;
  }

  static final String parserUrl = "http://api.hibis.com";
  static final String _user = "auto";
  static final String _password = "lok13rum";
}

class Request
{
  Request(this._msg, this._system, [this._params = null])
  {
    _paramsJSON = JSON.encode(_params);
  }

  String get msg => _msg;
  String get system => _system;
  Map<String, dynamic> get params => _params;
  String get paramsJSON => _paramsJSON;

  String _msg;
  String _system;
  Map<String, dynamic> _params;
  String _paramsJSON;
}

class Response
{
  Response(String response)
  {
    print("response: $response");
    if (response.isEmpty)
    {
      _result = new Map<String, String>();
      _success = true;
    }
    else
    {
      Map<String, dynamic> r = JSON.decode(response);
      _success = r["success"];
      _result = r["result"];
    }
  }

  Map<String, String> getRow([int index = 0])
  {
    if (isEmpty) throw new Exception(emptyResultMsg);
    if (isMap && index != 0 || isList && index >= (_result as List).length || index < 0) throw new Exception("Row index out of bounds ($index)");
    return isMap ? (_result as Map) : (_result as List)[index];
  }

  Map<String, String> getNextRow()
  {
    if (isEmpty || (isMap && _nextRowIndex != 0) || (isList && _nextRowIndex >= (_result as List).length)) return null;
    _nextRowIndex++;
    return isMap ? (_result as Map) : (_result as List)[_nextRowIndex-1];
  }

  List<Map<String, String>> getTable()
  {
    if (isEmpty) throw new Exception(emptyResultMsg);
    if (isList) return _result;
    else
    {
      List<Map> list = new List();
      list.add(_result);
      return list;
    }
  }

  bool get isEmpty => _result.isEmpty;
  bool get isList => _result is List<Map>;
  bool get isMap => _result is Map;

  bool get success => _success;
  bool _success;
  dynamic _result;
  int _nextRowIndex = 0;

  static final emptyResultMsg = "Result is empty";
}