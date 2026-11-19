# Muestra visual del HUD del Necrovórtice

Fecha: 14 de noviembre de 2026. Versión de diseño 1. Es una muestra independiente para revisar estética, distribución y legibilidad; no es una versión nueva del juego.

## Abrir y revisar

Abrir `index.html` en un navegador. Los recursos son locales y no necesitan cuenta, conexión ni servidor. La muestra permite alternar exploración y diálogo y consultar paneles demostrativos. Los valores, inventario y textos de escena son ilustrativos; no leen ni escriben la partida Godot.

Las capturas `exploracion.png` y `dialogo.png` muestran las dos composiciones revisadas. El HUD utiliza nombre y retrato de Caelan, vida/maná, mochila en riesgo y accesos agrupados en rombos. La energía se expresa con turquesa, marfil, oro antiguo y motivos de órbitas/fragmentos.

## Recursos y procedencia

- `assets/scene.png`: escenario de concepto generado con la herramienta integrada `image_gen`, usando el diseño original de Caelan como referencia visual. Prompt completo en [PROMPT-ESCENA.txt](PROMPT-ESCENA.txt).
- `assets/caelan.png`: copia de la ilustración original de `D:/Synim/Uni cosas/Project Ascension/Caelan.png`, conservada sin editar; la interfaz selecciona visualmente la región del retrato mediante CSS.
- `index.html`, `style.css`, `ui.js`: composición y controles editables de la muestra. Los marcos/iconos se construyen mediante código; no se incorporaron recortes de botones de Pinterest al juego.
- Referencias de composición: imágenes conservadas en `../../referencias/interfaz/`, descritas en `../../DIRECCION-VISUAL.md`.

## Alcance de esta propuesta

La escena es una ilustración raster única: todavía no es un tileset, un mapa con colisiones ni una colección de sprites animados. El personaje visible en ese fondo forma parte de la ilustración. El HUD es una propuesta editable en HTML, no una interfaz Godot ya instalada. No modifica ejecutable, guardado, reglas, Q01 ni el canon del prólogo.

Para integrarlo después habría que adaptar el marco a controles Godot y preparar terreno, personajes, objetos y animaciones como recursos separados, manteniendo la dirección visual elegida. La disposición y ornamentación de esta versión siguen sujetas a revisión del usuario.

## Revisión tipográfica elegida

El usuario eligió «Pixel art legible»: Pixelify Sans para nombres, títulos y cantidades; Atkinson Hyperlegible para descripciones y etiquetas; el cuerpo del diálogo se revisó después con Almendra (véase abajo). Se aumentaron los textos pequeños y el margen de las cifras dentro de las barras. Las fuentes son locales; archivos originales, procedencia y licencias en [assets/fonts/FUENTES.md](assets/fonts/FUENTES.md).

## Comprobación de esta muestra

Revisadas visualmente exploración y diálogo en Chromium a 1680 × 1050 y exploración a 1280 × 800. Comprobados carga local de imágenes/fuentes, cambio de vistas, E/Escape, cuatro paneles, objetivo plegable, cierre al pulsar el fondo y conservación de ajustes al reabrir. Sin errores de página o carga durante esa comprobación. También abrió correctamente desde `file:///` sin servidor.

La muestra está pensada para escritorio. En móvil o ventanas muy pequeñas se reduce como una composición completa y los textos pierden tamaño; un HUD de producción necesitará distribución adaptable y pruebas dentro de Godot. Esta validación no equivale a probar el juego.

## Aclaración del usuario: cuerpo del diálogo

El usuario señaló que se refería a la frase del diálogo y adjuntó Arcane Fable como referencia de estilo. Se prueba **Almendra Regular**, de Ana Sanfelippo, a 32 px virtuales e interlineado 1,35. Conserva mayúsculas y minúsculas y el color marfil. Los nombres y títulos del resto de la muestra mantienen la revisión anterior.

Se trata de una aproximación de fantasía con remates curvos, no de la fuente Arcane Fable. Fuente original y licencia OFL en assets/fonts; referencia conservada en ../../referencias/interfaz/05-fuente-arcane-fable.png. Prueba pendiente de opinión del usuario.

Captura completa actualizada en dialogo.png y detalle en [dialogo-almendra-detalle.png](dialogo-almendra-detalle.png). Comprobadas carga real de Almendra, ausencia de desborde del texto y aspecto en escritorio a 1680 × 1050 y 1280 × 800, sin errores de página/carga durante la revisión por HTTP local. El código de controles no cambió en esta revisión.
