import 'package:flutter/material.dart';
import 'package:practica_final/controllers/Service.dart'; // Importa el servicio
import 'package:practica_final/views/menuView.dart';
import 'package:practica_final/models/ResponseGeneric.dart';

// Define data structure for a sucursal
class Sucursal {
  String nombre; // Nombre de la sucursal
  double cantidad; // Cantidad de productos en la sucursal
  Sucursal({required this.nombre, required this.cantidad});
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Sucursal> _sucursales = []; 

  @override
  void initState() {
    super.initState();
    _loadSucursales();
  }

  Future<void> _loadSucursales() async {
    try {
      Service s = Service();
      ResponseGeneric rg = await s.listData();

      if (rg.code == '200') {
        setState(() {
          _sucursales = (rg.datos as List).map<Sucursal>((item) {
            return Sucursal(
              nombre: item['nombre_sucuarsal'] ?? '', // Mapear el campo correcto
              cantidad: double.tryParse(item['cantidad'].toString()) ?? 0.0, // Convertir a double
            );
          }).toList();
        });
      } else {
        print('Error: ${rg.msg}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuBarView(message: 'Menu'),
      body: ListView.builder(
        padding: const EdgeInsets.all(30),
        itemCount: _sucursales.length,
        itemBuilder: (context, index) {
          final sucursal = _sucursales[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(sucursal.nombre),
              subtitle: Text('Cantidad de productos: ${sucursal.cantidad}'),
            ),
          );
        },
      ),
    );
  }
}
