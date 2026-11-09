# Backlog y cobertura de ideas

Actualizado: 2026-11-09. F0 y F1 están completadas para el objetivo inicial horizontal; F2 está en curso. Las tareas amplias siguen abiertas aunque exista un primer alcance implementado. Ver AVANCE-002.md para la evidencia actual. El identificador debe mantenerse al cambiar título, fase o prioridad.

Prioridad: P0 = base imprescindible; P1 = siguiente profundidad; P2 = ampliación posterior. Fase inicial significa primer alcance parcial, no finalización de toda la idea.

## Jugabilidad

| ID | Idea | Prioridad | Fases | Criterio de aceptación resumido |
|---|---|---|---|---|
| J01 | Reconstrucción visible del pueblo | P0 | F1, F4 | Reparar cambia el mapa y habilita una función persistente. |
| J02 | Ayudantes con funciones y asignaciones distintas | P0 | F1, F3 | Reasignar cambia producción correctamente y no bloquea al jugador. |
| J03 | Exploración que desbloquea economía | P0 | F1, F3 | Recuperar un lugar abre producción que ayuda a otra aventura. |
| J04 | Combate por turnos con intenciones y respuestas | P0 | F1, F2 | Una intención visible permite decidir entre respuestas útiles. |
| J05 | Jefes con mecánicas propias | P0 | F1, F2, F5 | Cada jefe requiere una decisión distinguible de un enemigo normal. |
| J06 | Tres estilos, talentos y configuraciones | P1 | F2 | Los estilos tienen utilidad diferente; experimentar es comprensible y asequible. |
| J07 | Equipo con efectos sobre habilidades | P1 | F2, F5 | Comparar y equipar cambia una interacción del combate, con efecto comprobado. |
| J08 | Automatización de tareas dominadas | P1 | F3 | Delegar elimina repetición y respeta costes, requisitos y primera superación. |
| J09 | Trabajo y progreso offline con resumen | P0 | F1, F3 | Tiempo y resultados coinciden con reglas documentadas, sin duplicados. |
| J10 | Misiones que transforman y desbloquean | P0 | F1, F2, F4 | Diario claro; completar produce consecuencias guardadas. |
| J11 | Renacimiento voluntario y significativo | P1 | F4 | Vista previa exacta, conservación correcta y una opción jugable nueva. |
| J12 | Secretos, rutas, atajos y viaje rápido | P1 | F2, F5 | Recorridos accesibles y destinos desbloqueados persistentes. |
| J13 | Desafíos opcionales con estrategias alternativas | P2 | F5 | Restricciones claras, salida disponible y recompensa alternativa. |
| J14 | Ritmo para sesiones cortas y ausencias | P0 | F1–F6 | Hay objetivos próximos visibles y no se exigen rachas obligatorias. |

## Técnica

| ID | Trabajo | Prioridad | Fases | Criterio de aceptación resumido |
|---|---|---|---|---|
| T01 | Guardado completo, versiones, respaldo y exportación | P0 | F1, F3–F6 | Recuperar y migrar partida sin pérdida o duplicación; probar fallos y respaldo. |
| T02 | Estados y transiciones explícitas | P0 | F1, F4 | Derrota, victoria y recompensas tienen recuperación coherente. |
| T03 | Simulación por tiempo independiente del dibujo | P0 | F1, F3 | Online/offline equivalentes bajo las mismas reglas. |
| T04 | Definiciones de contenido mediante recursos | P0 | F0–F2 | Añadir una variante por datos sin duplicar el sistema; no mutar estado compartido. |
| T05 | Escenas y responsabilidades reutilizables | P0 | F0–F2 | Las variantes reutilizan comportamiento sin dependencias circulares. |
| T06 | Regiones, mapas, colisiones y apariciones válidas | P0 | F1, F2, F5 | Objetivos y entradas accesibles; generación variable comprobada si se incorpora. |
| T07 | Interfaz adaptable, controles y accesibilidad | P0 | F0–F2, F6 | Menús y texto legibles en tamaños probados; controles sin acciones simultáneas indeseadas. |
| T08 | Herramientas para desarrollo y equilibrio | P0 | F0–F5 | Preparar escenarios y medir progresión sin alterar el flujo normal. |
| T09 | Pruebas de lógica y pruebas reales de juego | P0 | F1–F6 | Evidencia registrada, separando automatización de validación visual y jugable. |
| T10 | Exportación, almacenamiento y rendimiento objetivo | P0 | F0, F1, F6 | Ejecutar versión exportada y registrar plataformas realmente comprobadas. |
| T11 | Precisión y presentación de números grandes | P1 | F3–F6 | Costes y saldos coherentes dentro del rango documentado. |
| T12 | Versionado, documentación, créditos y entregas | P0 | F0–F6 | Cada entrega tiene procedencia, cambios, comprobaciones y siguiente paso. |

## Lista de cuestiones abiertas

| ID | Cuestión | Cerrar antes de |
|---|---|---|
| O01 | Versión de Godot, resolución base y primer dispositivo objetivo | F1 |
| O02 | Movimiento por casillas o continuo y acciones iniciales de combate | F1 |
| O03 | Recursos y funciones exactas de los dos ayudantes iniciales | F1 |
| O04 | Política de recuperación de derrota y combate interrumpido | F1 |
| O05 | Límite offline, capacidad de almacenamiento y reglas de tiempo | Activar ingresos offline |
| O06 | Identidad de ayudantes: personajes únicos, profesiones o grupos | Ampliar plantilla en F3 |
| O07 | Recursos visuales/sonoros, procedencia y licencias | Integrar cada recurso |
| O08 | Costes, restricciones y desbloqueo de redistribución de talentos | F2 |
| O09 | Reglas de patrulla, retirada y combate offline | Implementar esa automatización |
| O10 | Matriz completa de persistencia del renacimiento y coherencia narrativa | F4 |
| O11 | Alcance de campaña, número de regiones y cierre | Ampliar campaña en F4 |
| O12 | Necesidad real y alcance de mazmorras variables | F5 |

Estas cuestiones no requieren detener la documentación ni decidir todo de una vez. Se resuelven en la fase en que afecten al trabajo, registrando la decisión.

## Fuera del primer hito

Mazmorras variables, campaña extensa, renacimiento completo, combate offline, nube/cuentas, multijugador, monetización y eventos periódicos. Los primeros cinco son ampliaciones o posibilidades documentadas; los restantes no han sido acordados como funciones del juego.

## Cómo registrar avances

Para cada tarea en curso añadir: estado, alcance de la entrega, enlace a cambio/commit, resultado, comprobaciones y pendientes. Una tarea amplia puede completar una parte en F1 y continuar en fases posteriores; no marcar el ID completo como hecho si solo se ha construido su primer alcance.

## Nuevas ideas

Sin entradas adicionales. Añadir aquí futuras propuestas con ID, motivo, coste aproximado si se conoce y fase sugerida. Actualizar también el diseño si se acepta una regla nueva.

## Estado tras la entrega 0.1.0-dev

- Primer alcance implementado de J01–J05, J09–J10 y J14: pueblo, tres áreas, dos ayudantes, tres tipos de enemigo y jefe, cadena de reconstrucción y producción offline. Las tareas completas continúan abiertas.
- Primer alcance implementado de T01–T10 y T12: guardado, estados, economía, recursos de enemigos, mapas, interfaz, herramientas de desarrollo, pruebas y exportaciones. No se acredita aquí su alcance futuro completo.
- O01: Godot 4.7.2, lienzo base 1152×768, escritorio horizontal como objetivo inicial. O02: movimiento por casillas; atacar, Chispa, defender, poción y retirada. O03: Mara minera e Ivo fundidor. O04: resultado de combate persistente; derrota vuelve al pueblo al confirmar y descuenta hasta 5 monedas una sola vez. O05: 8 horas offline y capacidad 9999, provisionales. O07: arte original provisional, sin audio. Estas decisiones operativas están documentadas en LEEME y D06.
- Recorrido principal completado y validado por el usuario el 2026-11-09, hasta derrotar al guardián y restaurar el faro. Pendientes de F1: importación/exportación por interfaz y pruebas adicionales de derrota, reanudación y ausencia real. La adaptación y prueba móvil real continúan pendientes sin atribuirlas a la confirmación del usuario.
- J06–J08 y J11–J13 no se consideran implementados; tampoco T11 como sistema avanzado de números grandes.

## Estado tras la entrega 0.2.0-dev

- Cerradas las comprobaciones de F1 de copia, derrota/reanudación y ausencia real con cierre del navegador. El estado anterior se conserva como registro histórico.
- J06: primer alcance de los tres estilos y dos talentos alternativos por estilo; cambios gratuitos en el pueblo y configuración recordada. Sin árbol de niveles o puntos todavía.
- J07: tres armas de herrería, dos reliquias y su selección por estilo. Efectos sobre maná, daño, quemadura y críticos. Pendiente ampliar catálogo, comparación y conjuntos nombrados.
- T01/T02/T09: migración 1→2, copia previa separada, estados de quemadura/crítico/entrenamiento persistentes y suites ampliadas. Total: 98 comprobaciones automáticas aprobadas.
- Entrenamiento repetible sin recompensas para probar configuraciones después de completar la historia. No es la automatización de J08 ni los desafíos con recompensas de J13.
- O08: redistribución gratuita en el pueblo, fuera de combate, con un talento elegido por estilo. Balance provisional.
- F2 sigue abierta: diferenciar patrones de enemigos, ampliar exploración con secretos y atajos, comparación de equipo y controles configurables/mando. Móvil real sigue pendiente.

## Prioridad acordada después de probar 0.2

El usuario declara que la versión está perfecta y pide dejar los arreglos de clases para más adelante. Se aplaza el ajuste de balance y reglas de J06; no se descarta la función existente. Siguiente bloque de F2: patrones enemigos diferenciados (J04/J05) y exploración con secretos y atajos (J12). Más adelante, comparación de equipo e interfaz. Esta priorización no equivale a implementación ni a validación exhaustiva de todas las clases.
