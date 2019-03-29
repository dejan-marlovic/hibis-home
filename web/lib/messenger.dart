library messenger;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

class Messenger {
  static Future<Response> post(Request req) async {
    final post = <String, String>{};
    post["msg"] = req.msg;
    post["system"] = req.system;
    post["params"] = req.paramsJSON;

    final headers = <String, String>{};
    final auth = base64.encode(utf8.encode("$_user:$_password"));
    headers["authorization"] = "Basic $auth";
    headers["content-type"] = "application/x-www-form-urlencoded";
    final request = await HttpRequest.postFormData(parserUrl, post,
        requestHeaders: headers);
    final response = Response(request.responseText);

    if (response.success == false) {
      print(response._result);
      print(
          "Request message:${req.msg}, system:${req.system}, params:${req.paramsJSON}");
    }

    return response;
  }

  static final String parserUrl = "https://api.hibis.com";
  static final String _user = "auto";
  static final String _password = "lok13rum";
}

class Request {
  Request(this._msg, this._system, [this._params]) {}

  String get msg => _msg;
  String get system => _system;
  Map<String, dynamic> get params => _params;
  String get paramsJSON => json.encode(_params);

  String _msg;
  String _system;
  Map<String, dynamic> _params;
}

class Response {
  Response(String response) {
    if (response.isEmpty) {
      _result = <String, String>{};
      _success = true;
    } else {
      final r = json.decode(response);
      _success = r["success"];
      _result = r["result"];
    }
  }

  Map<String, String> getRow([int index = 0]) {
    if (isEmpty) throw Exception(emptyResultMsg);
        
    if (isMap && index != 0 ||
        isList && index >= (_result as List).length ||
        index < 0) throw Exception("Row index out of bounds ($index)");
    return isMap ? _result as Map<String, dynamic> : (_result as List<Map<String, dynamic>>)[index];
    
  }

  Map<String, String> getNextRow() {          
    if (isEmpty ||
        (isMap && _nextRowIndex != 0) ||
        (isList && _nextRowIndex >= (_result as List).length)) return null;
    _nextRowIndex++;    
    return isMap ? _result as Map<String, dynamic> : (_result)[_nextRowIndex - 1].cast<String, String>();
    
  }

  List<Map<String, String>> getTable() {
    if (isEmpty) throw Exception(emptyResultMsg);
    if (isList)
      return _result;
    else {
      final list = [_result];      
      return list;
    }
  }

  dynamic get result => _result;

  bool get isEmpty => _result.isEmpty;
  bool get isList => _result is List;
  bool get isMap => _result is Map;

  bool get success => _success;
  bool _success;
  dynamic _result;
  int _nextRowIndex = 0;

  static final String emptyResultMsg = "Result is empty";
}
