# HUD compacta editable — primera base

Fecha: 16 de noviembre de 2026. Alcance: exclusivamente la HUD. No se implementa todavía en Godot y no se modifica escenario, reglas, guardado ni compilaciones.

## Revisar

Abrir index.html en un navegador. El fondo neutro permite concentrarse en la interfaz. Se puede alternar Estado normal, Vida baja y Mochila llena, ajustar los PV con el deslizador y cambiar el estado visual de retirada. La mochila se despliega al pulsarla y se cierra con Escape o al pulsar fuera.

Mapa/M, Menú/Escape y Poción/Q notifican la selección en la zona de revisión; no implementan mapas, menús completos ni curación. Los controles de prueba están fuera de la HUD. No leen ni escriben una partida ni utilizan almacenamiento persistente.

## Recursos separados

- assets/panel.svg: marco original en SVG con cuadrícula de 64 × 64, esquinas escalonadas, oro antiguo y pequeños acentos turquesa. La muestra utiliza recorte de nueve regiones para adaptar paneles sin deformar sus esquinas.
- assets/potion.svg, bag.svg, map.svg, menu.svg, warning.svg y door.svg: iconos originales editables de 32 × 32.
- assets/caelan.png: copia sin editar del diseño original del usuario; el recorte del retrato se presenta mediante CSS, conservando la imagen fuente.
- assets/fonts: Pixelify Sans para nombre/alerta y Atkinson Hyperlegible para datos y etiquetas. Archivos originales previamente obtenidos de Google Fonts y licencias OFL incluidas. No se modificaron las fuentes.
- hud.css: tamaños, colores, tipografía y distribución; hud.js: simulación visual de estados; componentes.json: coordenadas y márgenes de referencia para una adaptación futura.
- referencia.png: copia del concepto generativo anterior. Es una referencia de diseño, no una capa de esta interfaz ni un recurso que deba importar el juego.
- estado-normal.png, vida-baja.png, mochila-llena.png: capturas de la interfaz editable.

La interfaz se reconstruyó mediante HTML/CSS/SVG. Esta primera base permite editar recursos y probar estados; no pretende acreditar una coincidencia exacta con los píxeles o letras de la imagen generada. Falta revisar su acabado con el usuario. La tipografía y los márgenes quedan sujetos a ajuste.

## Estados y límites

Los valores de prueba conservan 14/38 PV, 12/22 PM, dos pociones, capacidad 6/12 y objetivo 1/3. Los otros presets son ilustrativos. El umbral <=14 PV para mostrar Vida baja es un ajuste de esta muestra; no redefine el balance o las reglas del juego. La retirada se cambia manualmente para comprobar ambas etiquetas, sin simular condiciones de combate. El detalle de mochila muestra categorías, sin inventar pesos o cantidades para explicar el 6/12 de la captura.

La vida baja se comunica mediante texto y borde además de color. La retirada bloqueada conserva una etiqueta completa. Las barras representan proporcionalmente sus valores; 14/38 equivale aproximadamente al 36,8 % del recorrido útil. No se agregó una animación intermitente.

Comprobados en Chromium: estados normal/bajo/lleno, proporción de barra, apertura/cierre de mochila, retirada bloqueada, acceso de mapa y carga de imágenes. Revisadas capturas de escritorio a 1680 y 1280 píxeles de ancho; sin errores de página/carga durante esa prueba. XML SVG y sintaxis JavaScript comprobados. En ventanas pequeñas se escala la composición completa: la legibilidad móvil y la adaptación en el motor siguen pendientes.

## Siguiente trabajo

Revisar forma del marco, tipografía, tamaños y espaciados de esta base. Una vez definido el aspecto, preparar los recursos y controles nativos de Godot y conectar los datos reales cuando el usuario autorice esa integración. Este paquete no contiene una escena Godot ni certifica su importación en el motor.
