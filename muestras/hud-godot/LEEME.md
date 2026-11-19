# HUD del Necrovórtice — prueba nativa Godot

Fecha: 16 de noviembre de 2026. Versión del laboratorio: 0.1.0-hud. Motor utilizado: Godot 4.7.2.

## Probar

- **Windows:** abrir `export/windows/HUD-Necrovortice.exe`. Es una aplicación independiente de la partida principal.
- **Editar:** abrir `project.godot` con Godot 4.7.2 y ejecutar el proyecto (F6 también permite probar la escena seleccionada).
- **Web:** ejecutar `abrir-web.ps1` y abrir la dirección local que indica. Requiere Python; el archivo HTML exportado debe servirse por HTTP. La prueba funciona sin hilos ni cabeceras de aislamiento especiales.

En el laboratorio puedes alternar Estado normal, Vida baja y Mochila llena, ajustar la vida, cambiar la disponibilidad de retirada, activar/desactivar Hostil y probar un objetivo largo. La mochila abre su desglose; Escape o clic fuera la cierran. M solicita mapa, Q solicita poción y Escape solicita menú cuando la mochila está cerrada. Los atajos no se activan al editar controles de entrada. Mapa, menú y poción emiten señales y muestran confirmación en el laboratorio: no abren pantallas de campaña ni aplican curación.

El ZIP fuente omite las compilaciones y la caché del editor. El ZIP Windows incluye el ejecutable listo para probar, sin el proyecto fuente. En la carpeta de trabajo están disponibles ambos.

## Qué se implementó

- Escena nativa reutilizable: `hud/compact_hud.tscn`, con nodos de interfaz Godot y fondo transparente.
- Retrato original recortado mediante AtlasTexture, fuentes locales, iconos SVG y paneles de nueve regiones.
- Barras proporcionales, cifras reales del estado suministrado, alerta de vida baja mediante texto y color.
- Objetivo y progreso separados; textos largos recortados con tooltip completo.
- Hostilidad y disponibilidad de retirada explícitas; mochila con capacidad, riesgo y desglose.
- Distribución adaptable comprobada en tres tamaños. Colocación, colores y tamaños tipográficos se definen en `hud/compact_hud.gd`; la jerarquía de controles se conserva en el archivo de escena.

El aspecto parte de la reconstrucción editable de la HUD compacta, no de una transferencia automática de cada píxel del concepto generativo. Esta es una implementación nativa de la prueba, todavía pendiente de opinión del usuario sobre el acabado.

## Conectar más adelante

Instanciar `hud/compact_hud.tscn` y actualizarla mediante `set_state(Dictionary)`. Acepta cambios parciales: hp, max_hp, mp, max_mp, potions, bag_used, bag_capacity, objective, progress, hostile, retreat_available y materials (lista de diccionarios con name/amount). La escena emite `map_requested`, `menu_requested`, `potion_requested` y `bag_toggled(open)`.

Ejemplo de actualización: `hud.set_state({"hp": 14, "max_hp": 38, "retreat_available": false})`.

No utiliza Game, Expedition, autoloads, disco o guardado. El laboratorio tiene su propio project.godot; nunca inicia los autoloads de la campaña. La interfaz no calcula pesos, reglas de retirada o consumo de objetos: muestra los datos recibidos. El umbral 37 % para Vida baja es provisional del laboratorio. Las cantidades de materiales y capacidad se mantienen como valores de demostración independientes hasta revisar la regla real del juego.

## Comprobaciones

- Importación, compilación y arranque sin errores con Godot 4.7.2.
- `tests/test_hud.gd`: **21 comprobaciones aprobadas, 0 fallos**. Incluye proporciones de barras, actualizaciones parciales, valores inválidos, señales/atajos, protección de foco, mochila, contención y separación de controles con texto largo a 1600×900, 1280×720 y 960×540 de área HUD.
- Windows: ejecutable exportado iniciado con OpenGL/NVIDIA; captura nativa de su viewport generada correctamente y salida 0.
- Web/Chromium: revisión visual de presets, mochila, texto largo, selector de retirada y ventanas a 1280×880, 960×660 y 1600×1100. Sin errores de página/consola durante la prueba final.
- Capturas reales del motor en `capturas/`. La de Windows no es un montaje HTML.
- Comparación SHA-256 antes/después: los 68 archivos fuente/recursos del juego principal y la carpeta existente de guardados conservan sus valores. Se excluyó la caché .godot de la comparación.

Estas pruebas no sustituyen probar la HUD conectada a una expedición real, mando, móvil u otras plataformas. Esa conexión está pendiente; no se ha sustituido la interfaz del juego principal.

## Recursos y compilación

`hud/assets/` conserva las fuentes Pixelify Sans y Atkinson Hyperlegible con licencias OFL, los SVG originales de la muestra editable y una copia del diseño de Caelan aportado por el usuario. Créditos de fuentes en `hud/assets/fonts/FUENTES.md`. No se agregaron recursos externos de pago.

`compilar.ps1` importa, ejecuta las comprobaciones y exporta Windows/Web. Sus valores por defecto utilizan el motor y las plantillas ya disponibles en el workspace. Si se traslada el proyecto, indicar `-GodotExecutable` y configurar las rutas de plantillas en los presets de exportación. Las compilaciones solo se escriben en export/ de este laboratorio.
