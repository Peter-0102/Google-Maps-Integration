import 'package:flutter/material.dart';
import 'package:google_maps/models/tienda.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  final List<Tienda> tiendas;
  final void Function(GoogleMapController) onMapCreated;
  final void Function(Tienda) onMarkerTap;

  const MapsScreen({
    super.key,
    required this.tiendas,
    required this.onMapCreated,
    required this.onMarkerTap,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  Set<Marker> get crearMarcadores {
    return widget.tiendas.map((t) {
      return Marker(
        markerId: MarkerId(t.nombre),
        position: LatLng(t.lat, t.lng),
        infoWindow: InfoWindow(title: t.nombre),
        onTap: () {
          widget.onMarkerTap(t);
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: widget.onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(19.4326, -99.1332),
        zoom: 13,
      ),
      markers: crearMarcadores,
    );
  }
}
