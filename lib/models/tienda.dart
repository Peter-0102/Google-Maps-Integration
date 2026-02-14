class Tienda {
  final String nombre;
  final double lat;
  final double lng;
  final double rating;
  final String horario;
  final String direccion;

  Tienda(
    this.nombre,
    this.lat,
    this.lng, {
    this.rating = 4.5,
    this.horario = "9:00 AM - 9:00 PM",
    this.direccion = "Dirección no disponible",
  });
}
