import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica_final/models/ResponseGeneric.dart';

class Connection{
  final String URL = 'http://127.0.0.1:5000/';
  //final String URL = 'http://192.168.0.100:5000/';
  static String URL_MEDIA = "http://localhost/media";

  


  Future <ResponseGeneric> get (String resource) async{ 
    final String _url = URL+resource;
    Map<String, String> headers = {'Content-Type':'application/json'};
    final uri = Uri.parse(_url);
    final response = await http.get (uri, headers: headers);
    //if(response.statusCode == 200){

      Map<dynamic, dynamic> _body = jsonDecode(response.body);
      return _response(_body["code"].toString(), _body["msg"], _body["datos"]);

   // }
  }  

  Future <ResponseGeneric> post (String resource, Map<dynamic, dynamic> map) async{ 
    final String _url = URL+resource;
    Map<String, String> headers ={'Content-Type':'application/json'};
    final uri = Uri.parse(_url);
    final response = await http.post (uri, headers: headers, body: jsonEncode(map));
    //if(response.statusCode == 200){

      Map<dynamic, dynamic> _body = jsonDecode(response.body);
      return _response(_body["code"].toString(), _body["msg"], _body["datos"]);

   // }  

  }
  ResponseGeneric _response(String code, String msg, dynamic map){
    var response = ResponseGeneric();
    response.msg = msg;
    response.code = code;
    response.datos= map;
    return response;
  }
}