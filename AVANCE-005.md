# Entrega 0.5.0-dev — HUD conectada a la expedición

Fecha: 16 de noviembre de 2026. Godot 4.7.2. Se integra la HUD de exploración en el piloto 0.4 disponible en este workspace, conservando su escenario 2D y sus reglas.

## Jugar

- [Windows 0.5](compilaciones/expediciones-0.5/windows/Aventura-del-Valle.exe).
- Web: servir compilaciones/expediciones-0.5/web por HTTP y abrir su index.html. No se publicó en internet.
- [Proyecto editable](juego/project.godot).

El juego utiliza la misma ranura de expediciones y esquema de guardado que 0.3/0.4. Las compilaciones 0.4 se conservan en compilaciones/expediciones. El respaldo anterior a esta integración está en respaldos/antes-hud-integrada-2026-11-16, con proyecto/compilaciones y copia del guardado de Windows.

## Cambios

La escena hud/compact_hud.tscn se conecta mediante scripts/expedition_hud_adapter.gd al estado real. Vida, maná máximo, pociones, materiales, etapa y estado de retirada se actualizan con cada cambio, incluido cargar una partida. Desaparecen el encabezado de texto, panel lateral y botones redundantes de exploración. Menú/Escape conserva preparación, proyectos, rutas, retirada, ayuda y copias de partida. M abre rutas y la mochila muestra los materiales.

El piloto no tiene límite de capacidad ni nivel de personaje. Se muestra la cantidad total de materiales sin inventar un /12 y se oculta el nivel ficticio. En el pueblo se muestra Almacén / Guardado; en la salida, Mochila / En riesgo. La identidad mostrada es la especialización del modelo actual, sin introducir todavía la campaña narrativa de Caelan.

Las pociones respetan la regla existente: solo se usan en combate. Q invoca la misma acción que su botón; fuera de combate aparece desactivado. La retirada usa Rules.ready_to_leave: no se anuncia disponible ante combate, recompensa o decisión obligatoria pendiente. El nombre de lugar se muestra brevemente al entrar. El aviso de interacción solo aparece cerca de un objetivo. Abrir la mochila detiene la marcha; cerrarla con un clic exterior no ejecuta un movimiento accidental.

Los combates, recompensas, resultados y copias conservan sus pantallas existentes y ocultan/desactivan temporalmente la HUD de exploración. No se añaden reglas, niveles, límites de inventario, arte de terreno ni diálogos nuevos. El laboratorio independiente anterior permanece disponible como referencia.

## Verificación

- 1981 comprobaciones anteriores aprobadas: núcleo42, persistencia11, estilos45, expedición167, guardado1610 y variaciones106.
- 75 comprobaciones de integración aprobadas: enlaces de menú/mapa, bloqueo de marcha con mochila, proporciones y valores, poción real por Q, recogida, viaje, recarga desde un archivo de prueba aislado, retirada con depósito, expedición completa con victoria y retorno, caída con pérdida de materiales y restauración de la HUD entre modos.
- El recorrido automatizado completo utiliza los controles/acciones existentes; fija variantes de encuentro para ser reproducible. La caída utiliza un estado de vida preparada. No se presenta como una prueba humana completa de diversión, balance o todos los recorridos.
- Web/Chromium, mediante ratón y teclado reales sobre la exportación: Patio, inicio, marcha al cartel, rutas, variante Slime acorazado, victoria, mejora Reserva arcana, recarga del navegador con15/15PM y materiales persistidos, retirada y regreso al pueblo. Se usó el origen local de prueba8781, separado de otras partidas web. Sin errores de consola durante esa revisión.
- Windows: captura GPU desde el proyecto nativo mediante controlador de prueba sin persistencia. El ejecutable exportado arranca y termina con código0 en comprobación headless con --test-mode. No se acredita aquí un recorrido manual Windows de extremo a extremo.
- Reglas, mapa/dibujo del mundo y almacenamiento comparados byte a byte con el respaldo: sin modificaciones. Cinco archivos de partida originales de Windows (principales/respaldos) conservaron sus SHA-256. Los archivos de prueba de guardado se usaron por separado.

[Exploración nativa](capturas/hud-0.5/exploracion-windows.png) · [Recarga Web](capturas/hud-0.5/exploracion-recargada-web.png) · [Retirada Web](capturas/hud-0.5/retirada-web.png) · [Almacén tras regresar](capturas/hud-0.5/almacen-web.png).

## Pendientes

Probar humanamente 0.5 con la partida habitual, especialmente legibilidad y navegación. La nueva HUD no convierte la ilustración conceptual del bosque en un mapa jugable: se conserva el escenario provisional de la base local. La revisión visual de combate, adaptación móvil/mando y campaña narrativa siguen pendientes. Esta entrega no cambia el balance de clases.
