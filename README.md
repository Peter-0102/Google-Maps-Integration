
# Buscador de Tiendas con Google Maps – Flutter App

Aplicación móvil desarrollada en **Flutter** que permite buscar **tiendas por categoría dentro de una ciudad** y mostrarlas directamente en un mapa interactivo.  
La app utiliza **Google Maps** para la visualización y **geolocalización en tiempo real** para mejorar los resultados según la ubicación del usuario.

Este proyecto forma parte de mi portafolio y está pensado para demostrar el uso de mapas, ubicación, manejo de estado y una arquitectura clara en Flutter.

---

## Funcionalidades principales

### Pantalla de bienvenida
La aplicación cuenta con una pantalla de bienvenida antes de acceder a la pantalla principal.

### Búsqueda de tiendas
El usuario puede buscar tiendas por nombre o categoría.  
Por ejemplo, al buscar **"abarrotes"**, la app mostrará todas las tiendas relacionadas con ese término.

### Mapa interactivo
- Visualización de tiendas mediante marcadores.
- Marcadores generados dinámicamente.
- Interacción directa con cada tienda desde el mapa.

### Ubicación actual del usuario
- Obtención de la ubicación en tiempo real.
- Posibilidad de centrar el mapa en la ubicación del usuario.
- Base para implementar búsquedas por cercanía.

### Marcadores dinámicos
- Los marcadores se crean a partir de una lista de tiendas.
- Se pueden agregar nuevas tiendas manualmente.
- Interacción entre lista de resultados y mapa.

---

## Arquitectura del proyecto

El proyecto está organizado separando responsabilidades para mantener el código limpio y escalable.

### Estructura general
- **home.dart**
  - Maneja el estado principal de la aplicación.
  - Controla la búsqueda de tiendas.
  - Gestiona la lista de resultados y la interacción con el mapa.

- **map.dart (MapsScreen)**
  - Se encarga exclusivamente de mostrar el mapa.
  - Recibe datos y callbacks desde `home.dart`.
  - No contiene lógica de negocio.

---

## Modelo de datos

Las tiendas se representan mediante un modelo que incluye:

- Nombre
- Latitud
- Longitud
- Rating
- Horario
- Dirección

---

## Tecnologías y herramientas

- Flutter  
- Google Maps API  
- Geolocator  
- Dart  

---

## Qué demuestra este proyecto

- Integración de APIs externas en Flutter.
- Uso de mapas interactivos y geolocalización.
- Manejo de estado y comunicación entre widgets.
- Separación clara entre UI y lógica.
- Enfoque en experiencia de usuario.

---

## Posibles mejoras futuras

- Búsqueda de tiendas por distancia.
- Filtros avanzados por categoría.
- Guardar tiendas favoritas.
- Mostrar rutas desde la ubicación del usuario.
- Persistencia de datos con base de datos local o remota.

---

## Autor

**Pedro Cruz López**  
Estudiante de Ingeniería en Computación  

Proyecto desarrollado como parte de mi portafolio personal.
