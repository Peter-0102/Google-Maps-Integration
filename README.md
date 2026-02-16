Buscador de Tiendas con Google Maps – Flutter App

Aplicación móvil desarrollada en Flutter que permite buscar tiendas por categoría dentro de una ciudad y mostrarlas directamente en un mapa interactivo.
La app utiliza Google Maps para la visualización y geolocalización en tiempo real para mejorar los resultados según la ubicación del usuario.

Este proyecto forma parte de mi portafolio y está pensado para demostrar el uso de mapas, ubicación, manejo de estado y una arquitectura clara en Flutter.

Qué hace la aplicación
Pantalla de bienvenida

La app cuenta con una pantalla de bienvenida que introduce al usuario antes de acceder a la pantalla principal.

Búsqueda de tiendas

El usuario puede buscar tiendas por tipo o categoría.
Por ejemplo, si busca “abarrotes”, la app mostrará todas las tiendas relacionadas con esa categoría dentro de la ciudad.

Mapa interactivo

Las tiendas se muestran como marcadores en el mapa.

Cada marcador representa una tienda con su ubicación.

Al tocar un marcador, se puede interactuar con la tienda seleccionada.

Ubicación actual del usuario

La app obtiene la ubicación en tiempo real del usuario.

El mapa puede centrarse automáticamente en esa ubicación.

Esto permite trabajar posteriormente con búsquedas por cercanía.

Marcadores dinámicos

Los marcadores se generan dinámicamente a partir de una lista de tiendas.

Se pueden agregar nuevos marcadores desde la lógica principal de la app.

También se manejan marcadores temporales creados al tocar el mapa.

Arquitectura y decisiones técnicas

El proyecto está organizado separando responsabilidades para mantener el código claro y escalable:

home.dart

Maneja el estado principal.

Controla los marcadores.

Gestiona la lógica de interacción y eventos.

map.dart (MapsScreen)

Se encarga únicamente de mostrar el mapa.

Recibe datos y callbacks desde home.dart.

No contiene lógica de negocio.

Este enfoque facilita:

El mantenimiento del código

La reutilización de componentes

La escalabilidad del proyecto

Tecnologías y herramientas utilizadas

Flutter
Framework principal para el desarrollo de la aplicación.

Google Maps API
Para mostrar mapas, marcadores y controlar la cámara.

Geolocator
Para obtener la ubicación actual del usuario y manejar permisos de localización.

Dart
Lenguaje utilizado en todo el proyecto.

Qué demuestra este proyecto

Integración de APIs externas en Flutter.

Uso de mapas interactivos y geolocalización.

Manejo de estado y comunicación entre widgets.

Separación clara entre UI y lógica.

Enfoque en experiencia de usuario y funcionalidad real.

Posibles mejoras a futuro

Búsqueda por distancia.

Filtros avanzados.

Guardar tiendas favoritas.

Mostrar rutas desde la ubicación del usuario.

Persistencia de datos con base de datos local o remota.

Autor

Pedro Cruz López
Ingeniería en Computación

Proyecto desarrollado como parte de mi portafolio personal y crecimiento como desarrollador.
