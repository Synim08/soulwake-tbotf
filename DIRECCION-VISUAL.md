# Dirección visual del Necrovórtice

Fecha: 14 de noviembre de 2026. Estado: dirección visual y muestra HTML de exploración/diálogo preparada. Revisión tipográfica «Pixel art legible» elegida por el usuario. Integración en el juego pendiente.

## Requisito acordado

El usuario quiere conservar la estética del Necrovórtice independientemente del HUD escogido. Las referencias enviadas desde Pinterest sirven para adaptar composición, formas y jerarquía; sus temas, iconos, textos y colores particulares no definen el universo. La identidad narrativa sigue siendo Ascendant Odyssey y la base jugable es el roguelite actual.

## Lectura de las tres referencias

| Referencia | Rasgo aprovechable | Adaptación propuesta | Uso preferido |
|---|---|---|---|
| [1 Marcos de energía](referencias/interfaz/01-marcos-energia.png) | Curvas, anillos y energía alrededor de paneles; versiones de distinta intensidad | Órbitas incompletas, grietas y filamentos turquesa con acentos de oro antiguo. Simplificar ornamentación y reconstruirla sobre una misma cuadrícula de píxeles | Títulos, selección de protagonista, reliquias importantes y momentos del faro |
| [2 HUD pixel](referencias/interfaz/02-hud-pixel.png) | Agrupación compacta de nombre, barras, iconos y accesos en rombos | Identidad/retrato de Caelan, PV/PM claros y pequeños accesos a personaje, diario, mapa y mochila. Símbolos propios del Vórtice y etiquetas legibles | Base estructural del HUD de exploración y lenguaje pixel art |
| [3 Marcos de diálogo](referencias/interfaz/03-marcos-dialogo.png) | Marcos jerárquicos, placa de nombre y ornamentación concentrada en esquinas | Panel horizontal de diálogo con retrato y nombre, centro limpio y borde sutil. Cartas verticales para protagonistas o reliquias | Conversaciones, selección de personajes y recompensas |

La primera referencia tiene mucho más detalle y trazo curvo que la segunda; no mezclar directamente ambos acabados. Convertir motivos a un lenguaje pixelado común. La tercera usa composiciones verticales de chat; el formato del diálogo del juego debe aprovechar la pantalla horizontal.

## Paleta propuesta, todavía revisable

- Fondo y panel: azul petróleo muy oscuro (`#10242B`) y petróleo medio (`#203F43`).
- Texto principal: marfil (`#EEE7D0`); no colocar texto largo sobre energía o fondos ilustrados de alto contraste.
- Necrovórtice: turquesa (`#53CFC0`) con focos blanco verdoso (`#D0FFF0`).
- Acentos: oro antiguo (`#C7A56B`) para jerarquía; ámbar cálido para Caelan y vida del refugio.
- Vida y peligro: coral/rojo cálido; maná: azul/cian. Mantener números, símbolos y palabras además de color.

El Necrovórtice une vida, almas y transformación: los motivos principales serían núcleos, órbitas, resonancias, runas y fracturas. El cráneo y el nombre Necromancer de la segunda referencia no describen a Caelan. Rosas/coronas de la tercera y criaturas ornamentales de la primera no se adoptan como símbolos universales. Hueso, hielo y otros motivos particulares pueden pertenecer a personajes o facciones cuando corresponda.

## Aplicación por pantalla

Exploración: mundo dominante, retrato/nombre y barras agrupados en una esquina; objetivo breve desplegable; mochila en riesgo con acceso visible y cantidades. Los rombos pueden ser accesos secundarios. Información contextual cerca del objeto y menús de copias/ajustes accesibles sin llenar el escenario de botones.

Combate: enemigo y protagonista visibles; intención legible y estados comprensibles; acciones en posiciones fijas en la zona inferior. Tomar del rombo una forma de botón o agrupación, manteniendo rótulos y foco por teclado. Evitar que un cambio de texto desplace acciones, problema ya observado y corregido en el piloto.

Diálogo: retrato de Caelan/personaje a un lado, nombre en placa y texto horizontal en pocas líneas. Ornamentación en esquinas; energía discreta que no atraviese las letras. Fuente de cuerpo compatible con tildes y eñes y tamaño cómodo; títulos pixelados si mantienen claridad.

Selección/recompensas: cartas verticales inspiradas en la tercera referencia, con ilustración, nombre, descripción y acción clara. Mayor ornamentación para hitos narrativos; conservar comparación de efectos y compatibilidad de especialización.

## Pixel art y producción propuesta

Mantener una escala coherente para terreno, personajes, iconos y marcos. Adaptar el cabello oscuro, ojos dorados y ropa clara de Caelan a un sprite propio reconocible. Reservar el detalle de las ilustraciones para retratos; no reducir una lámina completa para simular un sprite animado.

Diseñar primero un marco de panel, un botón, un rombo, barras y una pequeña familia de símbolos reutilizables. Preparar una pantalla de exploración, un diálogo del prólogo y un combate con el guardián como muestras. Revisar legibilidad antes de ampliar arte y pantallas.

Las imágenes conservadas son referencias de diseño, no sprites, botones o recursos finales ya incorporados al juego. Su presencia en documentación no cambia licencias ni acredita autoría. La muestra de concepto descrita abajo explora esta dirección; los recursos de producción e integración en Godot siguen pendientes.

## Primera muestra y revisión de fuente — 2026-11-14

[Muestra editable](muestras/necrovortice-v1/index.html), [exploración](muestras/necrovortice-v1/exploracion.png) y [diálogo](muestras/necrovortice-v1/dialogo.png). El usuario valoró favorablemente la composición y pidió cambiar la fuente; escogió «Pixel art legible». Se aplicó Pixelify Sans en nombres/títulos/cifras y Atkinson Hyperlegible en textos largos y etiquetas. Fuentes incluidas con sus licencias, sin conexión externa al abrir la muestra.

La escena de bosque se generó con image_gen integrado a partir del diseño original de Caelan; el HUD se construyó con HTML/CSS/SVG editables. La ilustración del escenario no es un mapa ni un tileset. La frase del diálogo es texto demostrativo. Procedencia, prompt y comprobaciones en [LEEME de la muestra](muestras/necrovortice-v1/LEEME.md).

X12 queda parcial: exploración/diálogo preparados y tipografía revisada; falta revisar esta versión con el usuario y diseñar la vista de combate antes de preparar recursos e interfaz Godot. No se cambió la versión jugable 0.4 ni sus guardados.


### Prueba posterior del cuerpo de diálogo

El usuario aclaró qué texto quería cambiar y aportó la referencia [Arcane Fable](referencias/interfaz/05-fuente-arcane-fable.png). El texto señalado era [el cuerpo del diálogo](referencias/interfaz/04-dialogo-fuente-a-cambiar.png). Se ensaya Almendra Regular, con remates de fantasía, a 32 px e interlineado 1,35; títulos y resto de la composición conservados. [Detalle de la prueba](muestras/necrovortice-v1/dialogo-almendra-detalle.png). La similitud es una interpretación visual; no se identifica Almendra como la misma fuente. Esperar opinión del usuario antes de fijarla para producción.


## V2 — marcos de resonancia, D27

La respuesta favorable del usuario mantiene Almendra en el diálogo. Nueva petición: acercar cuadros y HUD general a [la referencia 06](referencias/interfaz/06-marcos-curvos-energia.png). Adoptar filamentos curvos dorados, cintas turquesa, anillos asimétricos, cartelas y un contraste entre bordes elaborados y centros despejados.

[Muestra V2](muestras/necrovortice-v2/index.html) · [Exploración](muestras/necrovortice-v2/exploracion.png) · [Diálogo](muestras/necrovortice-v2/dialogo.png) · [Detalle](muestras/necrovortice-v2/dialogo-detalle.png). La V1 queda conservada.

Se redibujaron los marcos en SVG y se adaptaron estado de Caelan, barras, objetivo, mochila, accesos, aviso de interacción y paneles. Los símbolos siguen siendo órbitas/cristales propios del Necrovórtice. La muestra conserva el bosque anterior. [Alcance y comprobaciones](muestras/necrovortice-v2/LEEME.md).

X12 sigue parcial: propuesta V2 entregada para revisión; vista de combate, acabado de producción, escalas de pixel art, comportamiento adaptable e integración en Godot pendientes. No se cambia el ejecutable 0.4.


## Restricción confirmada — D28

El escenario seguirá siendo 2D con pixel art, manteniendo la dirección del juego actual. La ilustración de bosque de la muestra es una referencia conceptual, no el sustituto del escenario jugable. Los marcos y cuadros de texto de V2 orientan la futura interfaz.

El usuario pidió explícitamente no implementar todavía. La integración en Godot queda pendiente de una nueva instrucción suya; esta anotación no cambia el juego.


## Muestra V3 sobre pixel art 2D — 2026-11-16

El usuario pidió visualizar la HUD en el estilo 2D manteniendo la instrucción de no implementar en el juego. Se preparó [muestra independiente V3](muestras/necrovortice-v3-2d/index.html), con [exploración](muestras/necrovortice-v3-2d/exploracion.png) y [diálogo](muestras/necrovortice-v3-2d/dialogo.png).

Conserva marcos/fuentes de V2 y prueba una vista cenital de pequeñas zonas con pixel art dibujado en Canvas: árboles, senderos, ruinas, agua y sprite provisional. Sustituye la ilustración conceptual por un dibujo de escala de juego, sin instalarlo en Godot. La perspectiva de esta prueba y el acabado del sprite/terreno quedan sujetos a opinión; no se presentan como arte definitivo. D28 sigue vigente.


## Alcance actual: solo HUD y piezas editables — 2026-11-16

El usuario precisa que por ahora solo le interesa la HUD. Se prepara [una base editable independiente](muestras/hud-compacta-editable/index.html), con marcos/iconos separados, fuentes locales, barras proporcionales y estados simulados de vida, mochila y retirada. [Recursos y límites](muestras/hud-compacta-editable/LEEME.md).

No se revisa ni modifica el escenario. La primera base sirve para ajustar acabado, fuentes, tamaño y separación; no se declara idéntica al concepto generativo ni aprobada para producción. La integración en Godot continúa pendiente conforme a D28.


## Primera implementación nativa de HUD — D30

Tras la autorización del usuario, se implementó [la prueba Godot independiente](muestras/hud-godot/project.godot), con [ejecutable Windows](muestras/hud-godot/export/windows/HUD-Necrovortice.exe). Usa nodos nativos, recursos separados, estados simulados, señales de acciones y set_state para futuras conexiones. [Informe y capturas](AVANCE-HUD-001.md). La HUD del juego principal y el escenario permanecen intactos; falta revisar esta entrega y conectar los datos reales posteriormente.


Actualización D31 — 2026-11-16: HUD de exploración integrada en la campaña 0.5.0-dev con datos reales, menú/mapa/mochila y reglas existentes. Ver AVANCE-005.md. La conexión y las pruebas automatizadas están hechas; quedan revisión humana y dirección visual de combate, móvil/mando y arte/narrativa. El laboratorio de HUD se conserva como referencia.
