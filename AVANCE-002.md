# Avance 002 — cierre de F1 y comienzo de F2

Fecha: 9 de noviembre de 2026.

## Cierre de F1

El usuario confirmó completar la aventura hasta derrotar al guardián y restaurar el faro. Se completaron las comprobaciones pendientes mediante la versión web, en un perfil Chromium persistente separado de su partida de Windows.

- Exportación por botón de portapapeles, importación desde el menú y nueva exportación: se conservaron exactamente 137 monedas, 6 de madera, 17 minerales, 8 lingotes y los hitos de herrería, espada, jefe y faro de una partida de prueba preparada.
- Derrota real mediante la interfaz desde un estado de prueba con 1 PV y 137 monedas. Al recargar se conservó la derrota con 132 monedas. Tras confirmar y volver a cargar: pueblo, 38 PV y las mismas 132 monedas; no se repitió la penalización.
- Cierre completo y reapertura del navegador con el mismo perfil: resumen de 39 segundos de ausencia y producción de 4 lingotes. La producción siguió activa al regresar; el resultado respetó el consumo de mineral.
- Descarga de archivo JSON desde el menú: archivo recibido y contenido comprobado.
- Suite de lógica: 42 comprobaciones aprobadas. Suite nueva de persistencia: 11 comprobaciones aprobadas, incluyendo importación transaccional, rechazo de datos, fallo de escritura simulado y liquidación offline sin doble cobro.

Se encontró que Ctrl+V podía usar una copia anterior en la prueba web. Se añadió un botón de pegado que espera la lectura asíncrona del navegador, y se comprobó con una copia distinta de la anterior. Si se deniega el permiso, el juego conserva el contenido y permite pegar manualmente. La descarga JSON ofrece otra forma de conservar una copia.

La importación ahora escribe primero la copia validada; si falla el almacenamiento, no sustituye la sesión actual. Las suites se ejecutan con `-- --test-mode`, sin leer ni escribir la ranura real del jugador.

F1 se considera completada para el alcance inicial de escritorio/navegador horizontal. No implica soporte móvil, mando, todos los navegadores ni una auditoría exhaustiva de almacenamiento. Estos trabajos siguen abiertos para ampliaciones y publicación.

## Primera parte de F2

En preparación: guerrero defensivo, mago de estados y explorador de críticos; dos talentos alternativos por estilo; equipo con efectos; entrenamiento repetible sin recompensas. La ampliación debe conservar partidas 0.1, incluida la restauración del faro. La validación y las reglas de la nueva versión se añadirán aquí al terminarla.
