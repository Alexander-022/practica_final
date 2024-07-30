import 'package:practica_final/models/ResponseGeneric.dart';

class Product extends ResponseGeneric {
  String token = '';
  void add (ResponseGeneric rs) {
    code = rs.code;
    msg = rs.msg;
    datos = rs.datos;
  }
}
