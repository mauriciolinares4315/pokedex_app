# 🎮 Taller — Pantalla de Detalle Pokémon en Flutter

**Programación para Dispositivos Móviles**  
Universidad Pontificia Bolivariana · Prof. Luis Castilla

---

## 🎯 Objetivo

Construir una **pantalla de detalle de Pokémon** usando Flutter, aplicando los widgets fundamentales de forma progresiva. Al terminar tendrás una app visual completa que conecta con el taller anterior de Dart y la PokéAPI.

### Widgets que practicarás

| # | Widget | Para qué lo usamos |
|---|--------|--------------------|
| 1 | `Scaffold` | Estructura base de la pantalla |
| 2 | `AppBar` + `body` | Barra superior y zona de contenido |
| 3 | `Image.network` | Imagen del Pokémon desde internet |
| 4 | `Padding` | Espaciado interno de los elementos |
| 5 | `Text` | Nombre, ID, tipos y estadísticas |
| 6 | `Container` | Tarjeta con bordes y fondo oscuro |
| 7 | `Center` | Centrar la imagen en la pantalla |
| 8 | Widgets propios | `_TypeChip`, `_InfoItem`, `_StatBar` |

---

## 🏁 Resultado final

```
+----------------------------------+
|  [<]      Pokédex        [♡]     |  ← AppBar
+----------------------------------+
|                                  |
|         [imagen pikachu]         |  ← Image + Center
|                                  |
|  #025                            |  ← Text (ID)
|  PIKACHU               ⚡electric |  ← Text + _TypeChip
|                                  |
|  +----------------------------+  |
|  |  Altura   Peso    XP base  |  |  ← Container (tarjeta)
|  |  0.4m     6.0kg   112      |  |  ← _InfoItem x3
|  |                            |  |
|  |  -- Stats --               |  |  ← Text
|  |  hp      ████████░░  35    |  |  ← _StatBar
|  |  attack  █████████░  55    |  |  ← _StatBar
|  |  defense ██████████  40    |  |  ← _StatBar
|  |  speed   ████████░░  50    |  |  ← _StatBar
|  +----------------------------+  |
|                                  |
+----------------------------------+
```

---

## 📁 Estructura del proyecto

```
taller_widgets/
├── pubspec.yaml
└── lib/
    ├── main.dart                        ← punto de entrada
    └── screens/
        └── pokemon_detail_screen.dart   ← toda la UI del taller
```

---

## ⚙️ Setup

```bash
# Crear el proyecto
flutter create taller_widgets
cd taller_widgets

# Reemplaza lib/main.dart y lib/screens/pokemon_detail_screen.dart
# con los archivos del taller

# Correr
flutter run
```

---

## 🗺️ Fases del taller

El taller se construye en **8 fases**. Cada fase agrega un widget sobre lo que ya funciona. **No avances a la siguiente fase hasta que la actual se vea correctamente en el emulador.**

```
FASE 1 ──► main.dart              → MaterialApp + ThemeData
FASE 2 ──► Scaffold + AppBar      → estructura y barra superior
FASE 3 ──► Image                  → imagen del Pokémon
FASE 4 ──► Padding + Text         → nombre, ID y tipos
FASE 5 ──► Container              → tarjeta de estadísticas
FASE 6 ──► Widgets personalizados → _TypeChip, _InfoItem, _StatBar
FASE 7 ──► SingleChildScrollView  → scroll en pantallas pequeñas
FASE 8 ──► Reto: conectar la API  → datos reales desde PokéAPI
```

---

## 🟢 Fase 1 — MaterialApp y ThemeData (`lib/main.dart`)

**Widget introducido:** `MaterialApp`, `ThemeData`

### Tu trabajo

Configura el punto de entrada de la app con un tema oscuro estilo Pokédex.

```dart
void main() => runApp(const PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCC0000),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const PokemonDetailScreen(pokemon: kPikachuData),
    );
  }
}
```

### ✅ Verificar

Al correr la app debes ver la pantalla con **fondo azul oscuro** y la barra superior **roja**. Por ahora el body dice "Fase 2 — ¡Scaffold funcionando!".

---

## 🟢 Fase 2 — Scaffold + AppBar (`pokemon_detail_screen.dart`)

**Widget introducido:** `Scaffold`, `AppBar`, `IconButton`

### Concepto

`Scaffold` es el esqueleto de cualquier pantalla Flutter. Tiene ranuras predefinidas: `appBar`, `body`, `floatingActionButton`, `drawer`, etc. `AppBar` es el widget estándar para la barra superior.

### Tu trabajo

Completa el `AppBar` dentro del `Scaffold`:

```dart
appBar: AppBar(
  title: const Text(
    'Pokédex',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  centerTitle: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.favorite_border, color: Colors.white),
      onPressed: () {},
    ),
  ],
),
```

### ✅ Verificar

La barra superior muestra **"Pokédex"** centrado con un **corazón** a la derecha.

### 💡 Pista — propiedades clave de AppBar

| Propiedad | Para qué |
|-----------|----------|
| `title` | Widget central (normalmente `Text`) |
| `centerTitle` | `true` centra el título |
| `actions` | Lista de widgets a la derecha |
| `leading` | Widget a la izquierda (auto: ← si hay navegación) |
| `backgroundColor` | Color del AppBar |

---

## 🟢 Fase 3 — Image (`pokemon_detail_screen.dart`)

**Widget introducido:** `Image.network`, `Column`, `CircularProgressIndicator`

### Concepto

`Image.network` descarga y muestra una imagen desde una URL. El `loadingBuilder` permite mostrar un indicador mientras carga, y `errorBuilder` muestra algo si falla la descarga.

### Tu trabajo

Reemplaza el `body` del `Scaffold` con:

```dart
body: Column(
  children: [
    Center(
      child: Image.network(
        pokemon.imageUrl,
        height: 220,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFCC00),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stack) => const Icon(
          Icons.catching_pokemon,
          size: 80,
          color: Color(0xFFFFCC00),
        ),
      ),
    ),
  ],
),
```

### ✅ Verificar

Aparece la imagen oficial de Pikachu centrada. Mientras carga ves un spinner amarillo. Si desconectas internet ves el ícono de Pokéball.

### 💡 Pista — BoxFit

| Valor | Comportamiento |
|-------|----------------|
| `BoxFit.contain` | Ajusta sin recortar (respeta proporciones) ✅ |
| `BoxFit.cover` | Rellena recortando |
| `BoxFit.fill` | Estira para llenar |
| `BoxFit.fitWidth` | Ajusta al ancho |

---

## 🟡 Fase 4 — Padding + Text (`pokemon_detail_screen.dart`)

**Widget introducido:** `Padding`, `Text`, `EdgeInsets`, `TextStyle`

### Concepto

`Padding` añade espacio interno alrededor de su hijo. `EdgeInsets` define cuánto espacio en cada lado. `Text` con `TextStyle` permite estilizar cualquier texto.

### Tu trabajo

Agrega esto **dentro del `Column` del body**, después de la imagen:

```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ID
      Text(
        '#${pokemon.id.toString().padLeft(3, '0')}',
        style: const TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 4),

      // Nombre + tipos en la misma fila
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            pokemon.name.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          // TODO FASE 6: agrega aquí los _TypeChip
          // Row(
          //   children: pokemon.types
          //     .map((t) => _TypeChip(type: t))
          //     .toList(),
          // ),
        ],
      ),
    ],
  ),
),
```

### ✅ Verificar

Debajo de la imagen aparece `#025` en gris y `PIKACHU` en blanco y negrita.

### 💡 Pista — EdgeInsets

```dart
EdgeInsets.all(16)                    // igual en los 4 lados
EdgeInsets.symmetric(
  horizontal: 24, vertical: 8)        // horizontal y vertical
EdgeInsets.only(
  left: 16, top: 8, right: 0, bottom: 0) // lado por lado
```

---

## 🟡 Fase 5 — Container (`pokemon_detail_screen.dart`)

**Widget introducido:** `Container`, `BoxDecoration`, `BorderRadius`, `Divider`

### Concepto

`Container` es el widget más versátil. Con `decoration: BoxDecoration` puedes añadir color de fondo, bordes redondeados, sombras y gradientes. Úsalo para crear tarjetas personalizadas.

### Tu trabajo

Agrega esto en el `Column` del body, después del `Padding` de la fase 4:

```dart
Container(
  margin: const EdgeInsets.all(24),
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: const Color(0xFF16213E),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Fila de datos básicos
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // TODO FASE 6: reemplaza estos Text por _InfoItem
          Text('Altura\n${pokemon.height}m',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFE0E0E0))),
          Text('Peso\n${pokemon.weight}kg',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFE0E0E0))),
          Text('XP base\n${pokemon.baseXp}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFE0E0E0))),
        ],
      ),

      // Separador
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Divider(color: Colors.white12),
      ),

      // Título stats
      const Text(
        'Stats',
        style: TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 13,
          letterSpacing: 1.5,
        ),
      ),
      const SizedBox(height: 12),

      // TODO FASE 6: reemplaza estos Text por _StatBar
      ...pokemon.stats.map((s) => Text(
        '${s['name']}: ${s['value']}',
        style: const TextStyle(color: Color(0xFFE0E0E0)),
      )),
    ],
  ),
),
```

### ✅ Verificar

Aparece una tarjeta oscura con bordes redondeados que muestra los datos básicos y los stats como texto plano (se mejorarán en la Fase 6).

### 💡 Pista — BoxDecoration

```dart
BoxDecoration(
  color: Colors.black87,              // color de fondo
  borderRadius: BorderRadius.circular(16),  // esquinas redondeadas
  border: Border.all(color: Colors.white12, width: 1),  // borde
  boxShadow: [                        // sombra
    BoxShadow(
      color: Colors.black45,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
)
```

---

## 🔴 Fase 6 — Widgets Personalizados (`pokemon_detail_screen.dart`)

**Widget introducido:** `StatelessWidget` propio, `LinearProgressIndicator`, `ClipRRect`

### Concepto

En Flutter, cuando un bloque de UI se repite o es complejo, se extrae en un `StatelessWidget` propio. Esto mantiene el código limpio, reutilizable y fácil de leer.

### Tu trabajo — 3 widgets a implementar

#### Widget 1: `_TypeChip`

Muestra el tipo del Pokémon como pastilla coloreada.

```
  electric        fire          water
+----------+  +----------+  +----------+
| electric |  |   fire   |  |  water   |
+----------+  +----------+  +----------+
  fondo amber   fondo orange  fondo blue
```

```dart
class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip({required this.type});

  Color _colorForType(String type) {
    switch (type) {
      case 'fire':     return Colors.deepOrange;
      case 'water':    return Colors.blue;
      case 'electric': return Colors.amber;
      case 'grass':    return Colors.green;
      case 'psychic':  return Colors.pink;
      case 'normal':   return Colors.grey;
      default:         return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    
      // TODO: padding horizontal 12, vertical 4
      // decoration con _colorForType(type) y borderRadius circular 20
      // child: Text con el tipo en oscuro y bold
    );
  }
}
```

#### Widget 2: `_InfoItem`

Muestra una etiqueta y su valor apilados verticalmente.

```
  Altura        Peso        XP base
  0.4m          6.0kg       112
```

```dart
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      // TODO: crossAxisAlignment.center
      // children: label pequeño gris + SizedBox(4) + value grande blanco
    );
  }
}
```

#### Widget 3: `_StatBar`

Muestra nombre + barra de progreso + valor numérico.

```
hp      ████████░░░░░░░░  35
attack  █████████░░░░░░░  55
defense ██████████░░░░░░  40
speed   ████████░░░░░░░░  50
```

```dart
class _StatBar extends StatelessWidget {
  final String name;
  final int value;
  const _StatBar({required this.name, required this.value});

  Color _barColor() {
    if (value >= 80) return Colors.green;
    if (value >= 50) return Colors.amber;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // 1. Nombre del stat (ancho fijo 72)
          SizedBox(
            width: 72,
            child: Text(name,
              style: const TextStyle(
                color: Color(0xFF9E9E9E), fontSize: 12)),
          ),
          // 2. Barra de progreso (ocupa el espacio restante)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 150,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(_barColor()),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 3. Valor numérico (ancho fijo 32)
          SizedBox(
            width: 32,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFFE0E0E0), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Una vez implementados, actualiza la tarjeta (Fase 5):

```dart
// En la fila de datos básicos — reemplaza los Text temporales:
_InfoItem(label: 'Altura',  value: '${pokemon.height}m'),
_InfoItem(label: 'Peso',    value: '${pokemon.weight}kg'),
_InfoItem(label: 'XP base', value: '${pokemon.baseXp}'),

// En los stats — reemplaza el map temporal:
...pokemon.stats.map((s) =>
  _StatBar(name: s['name'] as String, value: s['value'] as int)),

// En el nombre — agrega el chip de tipo:
Row(
  children: pokemon.types
    .map((t) => Padding(
      padding: const EdgeInsets.only(left: 6),
      child: _TypeChip(type: t),
    ))
    .toList(),
),
```

### ✅ Verificar

La tarjeta muestra los datos con formato visual. Las barras de stats cambian de color (rojo < 50, amarillo 50–79, verde ≥ 80). El tipo aparece como pastilla coloreada junto al nombre.

---

## 🟡 Fase 7 — SingleChildScrollView

**Widget introducido:** `SingleChildScrollView`

### Concepto

En dispositivos con pantalla pequeña o cuando se abre el teclado, el contenido puede desbordarse. `SingleChildScrollView` envuelve el `Column` y añade scroll automáticamente.

### Tu trabajo

Envuelve el `Column` del body:

```dart
body: SingleChildScrollView(
  child: Column(
    children: [
      // ... todo el contenido de las fases anteriores
    ],
  ),
),
```

### ✅ Verificar

En un emulador con pantalla pequeña (ej. iPhone SE) puedes hacer scroll hacia abajo para ver todos los stats sin overflow.

---

## 🔴 Fase 8 — Reto: Conectar con la PokéAPI

**Conceptos:** `StatefulWidget`, `initState`, `FutureBuilder`, navegación con parámetros

### Tu trabajo

1. Convierte `PokemonDetailScreen` de `StatelessWidget` a `StatefulWidget`
2. Cambia el parámetro de `PokemonData` a `String idONombre`
3. En `initState()` llama a `PokeService.obtenerPokemon()` (del taller anterior)
4. Maneja los tres estados de la carga:

```
Estado: cargando   → CircularProgressIndicator centrado
Estado: error      → Icon + Text con mensaje + TextButton("Reintentar")
Estado: datos ok   → pantalla completa con los datos reales
```

5. En `main.dart` crea una pantalla de inicio con un `TextField` y un botón que navega a `PokemonDetailScreen`:

```dart
// Pantalla de inicio (home en main.dart)
class HomeScreen extends StatefulWidget { ... }

// Al pulsar buscar:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (ctx) => PokemonDetailScreen(
      idONombre: _controller.text.toLowerCase().trim(),
    ),
  ),
);
```

---

## ✅ Criterios de entrega

| Criterio | Descripción |
|----------|-------------|
| Compilación | `flutter run` sin errores ni warnings rojos |
| Fase 1–5 | Scaffold, AppBar, Image, Padding, Text y Container funcionando |
| Fase 6 | Los 3 widgets propios implementados (`_TypeChip`, `_InfoItem`, `_StatBar`) |
| Fase 7 | Scroll funciona en pantallas pequeñas |
| Sin código muerto | Sin `return Container()` ni `return Column()` vacíos |
| Widgets propios | Cada widget en su propia clase (no funciones que retornan widgets) |
| Git | Un commit por fase: `feat: fase 3 — imagen del pokemon` |

---

## 🚀 Retos extra

**Reto 1 — Color de fondo por tipo**  
Cambia el `scaffoldBackgroundColor` del tema según el tipo del Pokémon. Fuego → fondo naranja oscuro, agua → azul oscuro, eléctrico → amarillo oscuro.

**Reto 2 — Animación de entrada**  
Usa `AnimatedOpacity` o `TweenAnimationBuilder` para que la imagen aparezca con fade-in al cargar.

**Reto 3 — Favoritos**  
Haz funcional el botón de corazón. Guarda los Pokémon favoritos en una lista en memoria y cambia el ícono entre `Icons.favorite_border` y `Icons.favorite` (rojo).

---

## 📚 Recursos

| Widget | Documentación oficial |
|--------|-----------------------|
| Scaffold | https://api.flutter.dev/flutter/material/Scaffold-class.html |
| AppBar | https://api.flutter.dev/flutter/material/AppBar-class.html |
| Image | https://api.flutter.dev/flutter/widgets/Image-class.html |
| Padding | https://api.flutter.dev/flutter/widgets/Padding-class.html |
| Text | https://api.flutter.dev/flutter/widgets/Text-class.html |
| Container | https://api.flutter.dev/flutter/widgets/Container-class.html |
| Center | https://api.flutter.dev/flutter/widgets/Center-class.html |
| LinearProgressIndicator | https://api.flutter.dev/flutter/material/LinearProgressIndicator-class.html |
| SingleChildScrollView | https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html |

---

*Programación para Dispositivos Móviles · UPB Bucaramanga · 2025*
# pokedex_app
