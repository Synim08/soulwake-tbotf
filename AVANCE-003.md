# Avance 003 — primer piloto roguelite 0.3.0-dev

Fecha: 13 de noviembre de 2026. Motor: Godot 4.7.2.stable.official.ed1daf0bf, GDScript, Compatibility. Dirección D09–D11; especificación [EXPEDICION-001.md](EXPEDICION-001.md).

## Estado de la entrega

El Bosque del Sendero está implementado como una campaña piloto independiente: preparación gratuita, tres especializaciones iniciales, pequeños escenarios explorables, rutas ramificadas, enemigos con intenciones, mejoras compatibles y regreso con resultados persistentes. X01–X05 tienen implementación y comprobaciones automáticas de lógica/persistencia. X06 tiene exportaciones y recorrido web comprobados; continúa parcial por las pruebas humanas de ritmo y balance y la revisión visual nativa completa.

No se modifica la aventura incremental guardada de 0.2. Las compilaciones históricas siguen en `compilaciones/windows` y `compilaciones/web`. Las nuevas salidas se sitúan en `compilaciones/expediciones/windows/Aventura-del-Valle.exe` y `compilaciones/expediciones/web/`. El estado exacto de compilación/exportación se registra abajo.

## Alcance implementado

- Patio inicial gratuito; Guerrero/Guardián, Asesino/Duelista y Mago/Piromante. Las especializaciones se eligen antes de salir.
- Grafo fijo con dos bifurcaciones y cuatro recorridos; siete escenarios visitados en una salida completa. Se camina hasta enemigos, objetos, personajes y cartel de salida.
- Slime, lobo, murciélago, veterano y jefe. Preparaciones sin daño, guardia de un golpe, drenaje de PM y segunda fase anunciada del jefe.
- Doce mejoras temporales, ofertas compatibles no duplicadas y armas de potencia/tácticas por especialización. Ofertas persistidas para que recargar no cambie las elecciones.
- Hierbas, descanso único, cofre, alijo y contacto con Mara. La interacción opcional permite explorar desvíos; los eventos se consumen una vez.
- Mochila temporal y almacén separados. Retirada deposita todos los materiales; derrota pierde toda la mochila; victoria deposita y habilita el hito del jefe una sola vez. Sin huida en combate; doble caída cuenta como derrota.
- Mara se consolida al regresar a salvo tras contactarla. Botica de campaña y Banco de equipo consumen materiales una vez y abren kits/armas iniciales alternativos.
- Ranura piloto `valley_roguelite_slot_v1.json`, respaldo y esquema/modo propios. Autoload legado inactivo en el modo piloto; sin importación automática desde 0.2.
- Copias JSON por interfaz, descarga web y pegado asíncrono. Rechazo de datos incompatibles, recuperación de respaldo y bloqueo de guardado si no hay copia válida recuperable.

## Comprobaciones automáticas

Build actual: [release-0.3-build.log](../../work/release-0.3-build.log).

| Suite | Comprobaciones del build actual | Resultado |
|---|---:|---|
| Núcleo histórico | 42 | 0 fallos |
| Persistencia histórica | 11 | 0 fallos |
| Estilos/migración históricos | 45 | 0 fallos |
| Lógica de expedición | 167 | 0 fallos |
| Guardado/validación de expedición | 1577 | 0 fallos |
| **Total** | **1842** | **0 fallos** |

La suite de persistencia recorre estados tras comandos y su cantidad de comprobaciones puede variar con las ofertas/acciones de esa ejecución; 1842 describe este build, no un número fijo de pruebas de interfaz.

Lógica: recorridos naturales para las tres clases, cuatro combinaciones de rutas y dos políticas de combate/recompensas; límites de acciones inválidas, derrota simultánea, pérdida total de materiales, almacén intacto, selección incompatible rechazada y recompensas/costes sin duplicación. Estos recorridos son automatizados, no sesiones humanas.

Persistencia: lectura/escritura en archivos aislados, recuperación de respaldo, rechazo de estados corruptos o incompatibles, serialización de ofertas/combate/resultados y validación de estados intermedios de los recorridos. Las suites usan `-- --test-mode` y no acceden a la ranura real.

## Verificación de exportaciones e interfaz

- Windows y Web exportados después de las correcciones de UI. Logs finales: [Web](../../work/release-0.3-web-final.log), [Windows](../../work/release-0.3-windows-final.log).
- Windows: arranque de la aplicación exportada en modo headless durante 60 cuadros con `-- --test-mode`, sin errores en [log nativo](../../work/release-0.3-native-runtime.log). Comprobación antes/después de las ranuras reales: intactas. No equivale a un recorrido visual completo en Windows.
- Chromium a 1280×900, origen local puerto 8773: recorrido completo por interfaz con Guardián, ruta Ribera/Ruinas, hierbas, descanso, ofertas compatibles, contacto con Mara, alijo, combate y victoria del jefe. Sin forzar atributos del personaje durante ese recorrido.
- Resultado natural: 10 madera y 6 mineral depositados, Mara y jefe consolidados. Recarga del resultado y exportación por portapapeles conservaron exactamente esos valores, sin duplicar botín. Banco de equipo construido por interfaz: saldo posterior 2 madera y 0 mineral.
- Reanudación web de posición, combate y oferta pendiente. Exportación JSON por portapapeles y reimportación mediante botón de pegado asíncrono, con copia válida aceptada.
- Casos adicionales preparados mediante importación por la interfaz, separados del recorrido natural: derrota con 1 PV pierde 7 madera/5 mineral y conserva almacén de 2 madera/0 mineral; retirada desde nodo despejado deposita 7/5 sobre ese almacén. Recargas de ambos resultados mantienen la liquidación única. No se presentan como dos recorridos naturales completos.
- Corregidos durante la revisión: formato booleano de guardia, glifos de flechas ausentes, mensajes de acciones inválidas y posición variable de botones al cambiar el texto de intención. Las recargas de la exportación final no registraron nuevos errores de consola.
- Capturas: [pueblo](capturas/pueblo-0.3.png), [combate](capturas/combate-0.3.png), [victoria natural](capturas/victoria-0.3.png), [derrota preparada](capturas/derrota-0.3.png), [retirada preparada](capturas/retirada-0.3.png).
- Descarga web del archivo JSON implementada; esta entrega verificó el flujo de copia por portapapeles, no la descarga de archivo. Servidor y navegador de prueba cerrados al finalizar.

## Límites conocidos y pendientes

Arte provisional, sin audio ni generación procedural de escenarios. Solo una especialización inicial por clase; no hay árbol de subclases, campaña extensa ni integración narrativa definitiva del faro. El presupuesto inicial y las recompensas son parámetros de prototipo.

No se ha medido con jugadores si la expedición dura 15–25 minutos, si invita a repetir o si todas las estrategias resultan igual de atractivas. Faltan prueba humana, revisión de accesibilidad y validación en móvil real, mando, Safari/Firefox y varios dispositivos. Tampoco se acredita rendimiento exhaustivo o estabilidad de sesiones largas.

Siguiente paso: completar X06 y jugar varias salidas para registrar claridad, duración, dificultad y preferencias antes de ampliar clases, regiones o procedural. F2/F3 se mantienen abiertas hasta satisfacer sus condiciones jugables.

## Prueba del usuario posterior a la entrega

El usuario probó 0.3 y confirmó: «funciona todo». Se registra como validación humana del funcionamiento general del piloto. No especificó plataforma, duración, clases ni rutas concretas; no se infieren mediciones de equilibrio ni compatibilidad adicional.

Reportó que las armas tácticas no cambian nada y pidió no priorizar ese punto porque era una prueba. Incidencia Q01: efecto ausente o no perceptible, aún sin diagnóstico/reproducción. Se aplaza su corrección; no se considera demostración de equilibrio del equipo.

La validación permite avanzar desde la prueba funcional hacia una entrega de contenido rejugable. La propuesta siguiente es variar contenido dentro del Bosque del Sendero conservando los escenarios hechos a mano; requiere concretar alcance antes de implementación.
