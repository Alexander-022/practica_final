import 'package:practica_final/models/ResponseGeneric.dart';

class Session extends ResponseGeneric {
  String token = '';
  String user = '';
  void add (ResponseGeneric rg) {
    code = rg.code;
    msg = rg.msg;
    datos = rg.datos;
  }
}
