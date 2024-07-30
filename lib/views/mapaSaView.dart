import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:practica_final/controllers/Service.dart';
import 'package:practica_final/models/ResponseGeneric.dart';
import 'package:practica_final/views/menuView.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MapaSaView extends StatefulWidget {
  const MapaSaView({Key? key}) : super(key: key);

  @override
  _MapaSaViewState createState() => _MapaSaViewState();
}

class _MapaSaViewState extends State<MapaSaView> {
  final MapController _mapController = MapController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _nombreSucursalController = TextEditingController();
  final TextEditingController _fechaFabController = TextEditingController();
  final TextEditingController _fechaVenController = TextEditingController();
  
  LatLng? _selectedLatLng;
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _fechaFabController.text = _getCurrentDate();
    _fechaVenController.text = _getCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuBarView(message: 'Mapa de Productos'),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4, // Ajusta la altura del mapa
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(-3.99313, -79.20422), // Centra el mapa en Loja, Ecuador
                zoom: 12,
                minZoom: 3,
                maxZoom: 18,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (_selectedMarker != null) MarkerLayer(markers: [_selectedMarker!]),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_nombreController, 'Nombre del Producto'),
                  _buildTextField(_cantidadController, 'Cantidad'),
                  _buildTextField(_estadoController, 'Estado'),
                  _buildTextField(_descripcionController, 'Descripción'),
                  _buildTextField(_nombreSucursalController, 'Nombre de la Sucursal'),
                  _buildTextField(_fechaFabController, 'Fecha de Fabricación'),
                  _buildTextField(_fechaVenController, 'Fecha de Vencimiento'),
                  _buildTextField(
                    TextEditingController(text: _selectedLatLng?.latitude.toString() ?? ''),
                    'Latitud',
                    enabled: false,
                  ),
                  _buildTextField(
                    TextEditingController(text: _selectedLatLng?.longitude.toString() ?? ''),
                    'Longitud',
                    enabled: false,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveData,
                    child: const Text('Guardar Datos'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, {bool enabled = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: enabled ? null : Icon(Icons.lock, color: Colors.grey),
      ),
      enabled: enabled,
      maxLines: 1, // Limita la altura del TextFormField
      maxLength: 100, // Limita el ancho del texto
    );
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
      _selectedMarker = Marker(
        point: latLng,
        width: 80,
        height: 80,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              ),
              Text(
                'Marcado',
                style: TextStyle(color: Colors.black, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

      _fechaFabController.text = _getCurrentDate();
      _fechaVenController.text = _getCurrentDate();
    });
  }

  String _getCurrentDate() {
    return DateFormat('yyyy/MM/dd').format(DateTime.now());
  }

  Future<void> _saveData() async {
    if (_selectedLatLng == null) {
      Fluttertoast.showToast(
        msg: "Error: No se ha seleccionado una ubicación.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    try {
      Service service = Service();
      Map<String, String> datos = {
        'nombre': _nombreController.text,
        'latitud': _selectedLatLng!.latitude.toString(),
        'longitud': _selectedLatLng!.longitude.toString(),
        'cantidad': _cantidadController.text,
        'estado': _estadoController.text,
        'descripcion': _descripcionController.text,
        'nombre_sucursal': _nombreSucursalController.text,
        'fecha_fab': _fechaFabController.text,
        'fecha_ven': _fechaVenController.text,
      };

      ResponseGeneric response = await service.saveProduct(datos);

      if (response.code == '200') {
        Fluttertoast.showToast(
          msg: "Datos guardados correctamente.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );

        // Limpiar los campos después de guardar
        _nombreController.clear();
        _cantidadController.clear();
        _estadoController.clear();
        _descripcionController.clear();
        _nombreSucursalController.clear();
        _fechaFabController.text = _getCurrentDate();
        _fechaVenController.text = _getCurrentDate();
        setState(() {
          _selectedLatLng = null;
          _selectedMarker = null;
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error al guardar los datos: ${response.msg}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al guardar los datos: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }
}
