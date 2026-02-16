import 'package:flutter/material.dart';
import 'package:google_maps/models/tienda.dart';
import 'package:google_maps/widgets/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Tienda> resultado = [];
  bool _panelVisible = true;

  GoogleMapController? _mapController;
  Tienda? tiendaSeleccionada;

  //Variables para agregar un nueva tienda:
  final _nombreCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  final _horarioCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();


  LatLng? miUbicacion;
  Marker? marcadorTemporal;


final List<Tienda> misTiendas = [
  // --- ABARROTES Y COMIDA ---
  Tienda("Abarrotes 'La Guadalupana'", 19.4326, -99.1332),
  Tienda("Miscelánea 'El Recreo'", 19.4350, -99.1410),
  Tienda("Frutas y Verduras 'Don Chucho'", 19.4410, -99.1290),
  Tienda("Tortillería 'La Maizena'", 19.4380, -99.1250),
  Tienda("Panadería 'La Flor de Trigo'", 19.4385, -99.1350),
  Tienda("Carnicería 'La Selecta'", 19.4290, -99.1310),

  // --- SERVICIOS Y SALUD ---
  Tienda("Farmacia 'La Saludable'", 19.4250, -99.1380),
  Tienda("Ferretería 'El Tornillo'", 19.4300, -99.1200),
  Tienda("Papelería 'El Lápiz Loco'", 19.4310, -99.1450),
  Tienda("Lavandería 'Burbujas'", 19.4360, -99.1480),
  Tienda("Zapatería 'El Paso Firme'", 19.4335, -99.1375),
  Tienda("Óptica 'Visión Clara'", 19.4285, -99.1420),

  // --- REGALOS Y VARIOS ---
  Tienda("Tienda de Regalos 'Detallitos'", 19.4270, -99.1280),
  Tienda("Florería 'El Rosal'", 19.4340, -99.1220),
  Tienda("Juguetería 'Mundo de Fantasía'", 19.4395, -99.1390),
  Tienda("Mercería 'El Hilo de Oro'", 19.4315, -99.1265),
  Tienda("Relojería 'El Tiempo Antiguo'", 19.4305, -99.1345),
  Tienda("Librería 'Páginas Sueltas'", 19.4372, -99.1435),
];

//Mi ubicacion actual

Future<void> marcarMiUbicacion() async {
  final ubicacion = await obtenerUbicacionActual();
  if (ubicacion == null) return;

  setState(() {
    miUbicacion = ubicacion;
  });

  // Opcional: mover la cámara al usuario
  _mapController?.animateCamera(
    CameraUpdate.newLatLngZoom(ubicacion, 15),
  );
}

void _crearMarcadorTemporal(LatLng position) {
  final ahora = TimeOfDay.now();
  final hora = '${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}';

  setState(() {
    marcadorTemporal = Marker(
      markerId: const MarkerId('temporal'),
      position: position,
      infoWindow: InfoWindow(
        title: 'Marcador temporal',
        snippet: 'Hora: $hora',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    );
  });
}


Future<LatLng?> obtenerUbicacionActual() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1️⃣ Verificar si el GPS está activo
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // 2️⃣ Verificar permisos
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  // 3️⃣ Obtener posición
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return LatLng(position.latitude, position.longitude);
}


  //Modal para crear una nueva tienda:
  void mostrarModalCrearTienda() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Nueva tienda",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),

                TextField(
                  controller: _latCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Latitud"),
                ),

                TextField(
                  controller: _lngCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Longitud"),
                ),

                TextField(
                  controller: _ratingCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Rating"),
                ),

                TextField(
                  controller: _horarioCtrl,
                  decoration: const InputDecoration(labelText: "Horario"),
                ),

                TextField(
                  controller: _direccionCtrl,
                  decoration: const InputDecoration(labelText: "Dirección"),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: guardarTienda,
                    child: const Text("Guardar"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Funcion para guardar tienda:
  void guardarTienda() {
    final nombre = _nombreCtrl.text.trim();
    final lat = double.tryParse(_latCtrl.text);
    final lng = double.tryParse(_lngCtrl.text);

    if (nombre.isEmpty || lat == null || lng == null) {
      return; // puedes mostrar un SnackBar luego
    }

    final tienda = Tienda(
      nombre,
      lat,
      lng,
      rating: double.tryParse(_ratingCtrl.text) ?? 4.5,
      horario: _horarioCtrl.text.isEmpty
          ? "9:00 AM - 9:00 PM"
          : _horarioCtrl.text,
      direccion: _direccionCtrl.text.isEmpty
          ? "Dirección no disponible"
          : _direccionCtrl.text,
    );

    setState(() {
      misTiendas.add(tienda);
      resultado = misTiendas;
    });

    _limpiarFormulario();
    Navigator.pop(context);
  }

  void _limpiarFormulario() {
    _nombreCtrl.clear();
    _latCtrl.clear();
    _lngCtrl.clear();
    _ratingCtrl.clear();
    _horarioCtrl.clear();
    _direccionCtrl.clear();
  }

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
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
        onPressed: mostrarModalCrearTienda,
        child: const Icon(Icons.add_location_alt),
      ),
       SizedBox(height: 16),
       FloatingActionButton(
  heroTag: "ubicacion",
  onPressed: marcarMiUbicacion,
  child: const Icon(Icons.my_location),
),

        ],
      ),

      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                MapsScreen(
                  tiendas: resultado.isEmpty ? misTiendas : resultado,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onMarkerTap: onTiendaSeleccionada,
                  onMapTouch: () {
                    setState(() {
                      _panelVisible = false;
                    });
                  },
                  onMapTap: _crearMarcadorTemporal,
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: _panelVisible ? 220 : 50,
            width: double.infinity,
            curve: Curves.easeInOut,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _panelVisible = !_panelVisible;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: _panelVisible
                      ? (resultado.isEmpty
                            ? const Center(
                                child: Text(
                                  "No hay resultados",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                itemCount: resultado.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final tienda = resultado[index];

                                  return Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(14),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(14),
                                      onTap: () => enfocarTienda(tienda),
                                      onLongPress: () =>
                                          onTiendaSeleccionada(tienda),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.store,
                                              color: Colors.blueAccent,
                                            ),
                                            const SizedBox(width: 12),

                                            // Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    tienda.nombre,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        size: 16,
                                                        color: Colors.amber,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        tienda.rating
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 4),

                                                  Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 14,
                                                        color: Colors.redAccent,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          "Ver ubicación en el mapa",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              Icons.chevron_right,
                                              color: Colors.black38,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ))
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
