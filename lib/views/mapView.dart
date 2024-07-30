import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:practica_final/controllers/Service.dart';
import 'package:practica_final/models/ResponseGeneric.dart';
import 'package:practica_final/views/menuView.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<Marker> _markers = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      Service service = Service();
      ResponseGeneric response = await service.listData();

      if (response.code == '200') {
        List<Marker> markers = [];
        DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');

        for (var item in response.datos) {
          // Verifica que los valores no sean null antes de usarlos
          double lat = double.tryParse(item['latitud'] ?? '') ?? 0.0;
          double lng = double.tryParse(item['longitud'] ?? '') ?? 0.0;
          DateTime fechaVen;
          try {
            fechaVen = dateFormat.parse(item['fecha_ven'] ?? '');
          } catch (e) {
            fechaVen = DateTime.now(); // Maneja el error estableciendo una fecha predeterminada
          }
          bool isExpired = fechaVen.isBefore(DateTime.now());

          markers.add(
            Marker(
              point: LatLng(lat, lng),
              width: 200,
              height: 120,
              // Usa 'child' en lugar de 'builder'
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Sombra del marcador
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isExpired ? Colors.red : Colors.green,
                          size: 24,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item['nombre_sucuarsal'] ?? 'Sin nombre', // Asegúrate de que el campo es correcto
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Descripción: ${item['descripcion'] ?? 'Sin descripción'}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Estado: ${item['estado'] ?? 'Desconocido'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpired ? Colors.red : Colors.green,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Fecha de vencimiento: ${item['fecha_ven'] ?? 'Sin fecha'}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        setState(() {
          _markers = markers;

          // Centra el mapa en la primera ubicación de los datos si hay marcadores
          if (_markers.isNotEmpty) {
            // Encuentra el punto central entre todos los marcadores
            double latSum = 0.0;
            double lngSum = 0.0;

            for (var marker in _markers) {
              latSum += marker.point.latitude;
              lngSum += marker.point.longitude;
            }

            double avgLat = latSum / _markers.length;
            double avgLng = lngSum / _markers.length;

            _mapController.move(LatLng(avgLat, avgLng), 12); // Ajusta el nivel de zoom según sea necesario
          }
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuBarView(message: 'Mapa'),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _markers.isNotEmpty 
              ? LatLng(
                  _markers.map((m) => m.point.latitude).reduce((a, b) => a + b) / _markers.length,
                  _markers.map((m) => m.point.longitude).reduce((a, b) => a + b) / _markers.length
                ) 
              : LatLng(0.0, 0.0), // Coordenadas predeterminadas si no hay datos
          zoom: 12, // Ajusta el nivel de zoom según sea necesario
          minZoom: 3, // Zoom mínimo
          maxZoom: 18, // Zoom máximo
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all, // Permite todo tipo de interacción
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: _markers,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => (Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
