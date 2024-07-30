import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:practica_final/views/menuView.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MenuBarView(message: 'Menu'),
        body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(51.509364, -0.128928),
            initialZoom: 5,
            interactionOptions: InteractionOptions(
              
            flags: InteractiveFlag.doubleTapDragZoom | InteractiveFlag.pinchZoom)
                  
            
          ),
          children: [
            
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            const MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(51.509364, -0.128928),
                  width: 80,
                  height: 80,
                  child: Column(
                    children: [Icon(Icons.maps_ugc),
                      Text("Aqui estoy")
                    ],

                  ),
                )
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () =>
                      (Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ));
  }
}