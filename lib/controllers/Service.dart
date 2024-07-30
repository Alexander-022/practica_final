import 'package:practica_final/controllers/Conexion.dart';
import 'package:practica_final/models/ResponseGeneric.dart';
import 'package:practica_final/models/Session.dart';

class Service {
  Connection _con = Connection();
  String getMedia() {
    return Connection.URL_MEDIA;
  }

  Future<Session> session(Map<dynamic, dynamic> map) async {
    ResponseGeneric rg = await _con.post("session", map);
    Session s = Session();
    s.add(rg);
    if (rg.code != '200') {
      s.token = s.datos["token"];
      s.user = s.datos["user"];
    } 
    return s;
  }

  Future<ResponseGeneric> listData() async{
    ResponseGeneric rg = await _con.get("lproducto");
    return rg;
  }



   
}
