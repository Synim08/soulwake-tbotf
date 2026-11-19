# Muestra V3 — HUD sobre escenario 2D con pixel art

Fecha: 16 de noviembre de 2026. Abrir index.html en un navegador. Explorar los paneles con sus botones o M/J/C/O, alternar exploración y diálogo con los botones inferiores o E; Escape cierra. Se trata de una maqueta estática del mundo, no una partida con movimiento o colisiones.

Se conserva la HUD de V2: oro antiguo, cintas turquesa, marcos curvos, retrato de Caelan y Almendra para el cuerpo del diálogo. Se cambia el fondo por una muestra cenital dibujada en una cuadrícula lógica de 400 × 225 píxeles, ampliada sin suavizado mediante CSS. Árboles, senderos, agua, ruinas, cristal y pequeño sprite de Caelan son dibujos provisionales en pixel-world.js. La composición toma como referencia la presentación por pequeñas zonas del prototipo actual, sin reproducir una partida ni un mapa exacto.

## Archivos

- pixel-world.js: dibujo original y editable del escenario en Canvas 2D. No utiliza la ilustración de bosque generada en V1/V2 ni añade reglas del juego.
- style.css, ornaments.css, ui.js y SVG de assets: base de la muestra V2 y sus controles.
- assets/caelan.png: ilustración original del usuario, conservada para el retrato.
- assets/fonts: fuentes locales originales y licencias, descritas en FUENTES.md.
- exploracion.png y dialogo.png: capturas de la maqueta.

El escenario y el sprite son provisionales para comprobar escala, perspectiva y legibilidad de la HUD. No representan el acabado final del arte. Esta prueba no fija una nueva decisión sobre perspectiva ni cambia el requisito de escenario 2D con pixel art.

## Verificación y límites

Carga, fuentes, vistas de exploración/diálogo, Continuar, apertura/cierre de diario comprobados en Chromium. Revisada la composición a 1680 × 1050 y captura a 1280 × 800, sin errores de página/carga durante la prueba. La maqueta conserva el escalado de escritorio de V2; móvil requiere trabajo aparte.

Se respeta D28: no se modificaron archivos del proyecto Godot, compilaciones, reglas ni guardados. V1 y V2 se conservan. Integración en el juego pendiente de una instrucción posterior del usuario.
