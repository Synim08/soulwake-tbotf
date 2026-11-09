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

Versión entregada: **0.2.0-dev**, Godot 4.7.2. Se implementan guerrero defensivo, mago de quemaduras y explorador de críticos previsibles; dos talentos alternativos por estilo; tres armas de herrería y dos reliquias; configuración recordada por estilo y entrenamiento repetible sin recompensas.

Los cambios de configuración son gratuitos, en el pueblo y fuera de combate. Al fabricar la espada se habilitan las tres armas para experimentar; las reliquias requieren vencer al guardián. Es una economía de desbloqueos provisional, sin árbol de niveles ni fabricación avanzada de equipo todavía.

El entrenamiento presta 38 PV, 12 PM y 3 pociones. Al confirmar victoria, derrota o retirada restaura los suministros anteriores, sin monedas, hitos narrativos ni enemigos vencidos adicionales. Los trabajadores siguen operando con normalidad.

## Compatibilidad y guardado

- Esquema 2 para estilos, talentos, equipo y nuevos estados de combate.
- Migración desde esquema 1 conserva recursos, ayudantes, edificios, faro y resultados de combate pendientes.
- Primera lectura de una ranura antigua conserva una copia separada `.before-schema2.json`. No se reemplaza esa copia en lecturas posteriores; si falla su creación, el guardado automático se detiene y permite exportar.
- Quemaduras, contador de críticos y suministros originales de un entrenamiento sobreviven a la recarga.
- Se mantienen guardado principal, respaldo anterior, exportación/importación y descarga web de JSON.
- La versión HTML original sigue siendo independiente.

## Comprobaciones de 0.2

| Comprobación | Resultado y alcance |
|---|---|
| Lógica base | 42 comprobaciones aprobadas. |
| Persistencia | 11 comprobaciones aprobadas, incluidas escritura fallida y ausencia sin doble cobro. |
| Estilos, equipo y migración | 45 comprobaciones aprobadas: efectos combinados, restricciones, recuperación, copia original y práctica. |
| Viabilidad de configuraciones | Las seis combinaciones estilo/talento vencen al guardián con sus estadísticas reales y una estrategia automatizada sencilla. No acredita igualdad de poder o equilibrio definitivo. |
| Migración web por interfaz | La partida de prueba de esquema 1 conservó faro, 137 monedas, 17 minerales y 8 lingotes al pasar a esquema 2. |
| Configuración desde menús | Cambio de estilo, talento, arma/reliquia y equipo recordado por estilo comprobados en Chromium. |
| Quemadura y recarga | Mago con Canalización y bastón: guardián a 45/64 PV, aventurero a 30/38 PV y 9/12 PM; la recarga conservó esos valores y las 2 acciones restantes de quemadura. |
| Crítico y recarga | Explorador con Puntería y arco: se conservó el contador tras el primer ataque; el siguiente causó 24 de daño y dejó al guardián en 32/64 PV. |
| Victoria de práctica por interfaz | Guardián derrotado con Explorador, defensa y ataques. Tras confirmar se restauraron 38 PV, 12 PM y 3 pociones; permanecieron 137 monedas y 8 lingotes, sin premios de historia adicionales. |
| Consola web | Sin errores ni avisos en el recorrido final de prueba observado. |

Total de comprobaciones automáticas: **98**, sin fallos. Se ejecutan con `-- --test-mode` y archivos de prueba nombrados, sin cargar ni escribir la ranura real del jugador.

La primera entrega incluía una prueba nativa headless; la versión 0.2 también se exporta para Windows y se comprueba su arranque con partida de prueba aislada. La validación visual de la nueva interfaz se realiza en web; no se atribuye al usuario una prueba de 0.2 todavía.

## Pendiente de F2

- Patrones y mecánicas de enemigos más diferenciados: siguen compartiendo la pauta básica de golpe pesado cada tercer turno.
- Nuevas rutas, secretos, atajos y viaje rápido entre destinos.
- Comparación de objetos, catálogo más amplio y conjuntos nombrados.
- Reasignación de controles, mando y revisión móvil real.
- Pruebas humanas de preferencias y equilibrio de los seis talentos.

F2 permanece en curso. No se han implementado todavía renacimiento, campaña extensa, niveles, audio o automatización de combate. No hay validación exhaustiva en otros navegadores ni mediciones de rendimiento para dispositivos modestos.
