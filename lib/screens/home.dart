import 'package:flutter/material.dart';
import 'package:google_maps/models/tienda.dart';
import 'package:google_maps/widgets/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Tienda> resultado = [];

  GoogleMapController? _mapController;
  Tienda? tiendaSeleccionada;
  
  final List<Tienda> misTiendas = [
    Tienda("Tienda A", 19.4326, -99.1332),
    Tienda("Tienda B", 19.4400, -99.1400),
    Tienda("Tienda C", 29.4400, -109.1400),
    Tienda("Tienda D", 39.4400, -119.1400),
    Tienda("Tienda E", 49.4400, -130.1400),
    Tienda("Tienda F", 59.4400, -140.1400),
    Tienda("Tienda G", 69.4400, -150.1400),
    Tienda("Tienda H", 79.4400, -160.1400),
  ];

  List<Tienda> buscarTiendasSimilares(String query, List<Tienda> tiendas) {
    final q = query.toLowerCase().trim();

    return tiendas.where((tienda) {
      final nombre = tienda.nombre.toLowerCase();
      return nombre.contains(q);
    }).toList();
  }

  void mostrarInfoTienda(Tienda tienda) {
    setState(() {
      tiendaSeleccionada = tienda;
    });
  }

  void enfocarTienda(Tienda tienda) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(tienda.lat, tienda.lng), zoom: 17),
      ),
    );
  }

  void onTiendaSeleccionada(Tienda tienda) {
    enfocarTienda(tienda);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _bottomSheetTienda(tienda),
    );
  }

  void buscarLocal() {
    final texto = _searchController.text;

    if (texto.isEmpty) return;

    setState(() {
      resultado = buscarTiendasSimilares(texto, misTiendas);
    });
  }

  Widget _bottomSheetTienda(Tienda tienda) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),

          Text(
            tienda.nombre,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 5),
              Text("${tienda.rating}"),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.schedule, size: 20),
              const SizedBox(width: 5),
              Text(tienda.horario),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 20),
              const SizedBox(width: 5),
              Expanded(child: Text(tienda.direccion)),
            ],
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              MapsScreen(
                tiendas: resultado.isEmpty ? misTiendas : resultado,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onMarkerTap: onTiendaSeleccionada,
              ),

              Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  height: 50,
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Buscar tienda...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: buscarLocal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.amberAccent,
            padding: const EdgeInsets.all(20),
            child: tiendaSeleccionada != null
                ? Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tiendaSeleccionada!.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Latitud: ${tiendaSeleccionada!.lat}"),
                          Text("Longitud: ${tiendaSeleccionada!.lng}"),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  tiendaSeleccionada = null;
                                });
                              },
                              child: const Text("Cerrar"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: resultado.length,
                    itemBuilder: (context, index) {
                      final tienda = resultado[index];
                      return InkWell(
                        onTap: () => enfocarTienda(tienda),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(tienda.nombre),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
