# Roadmap de Aventura del Valle

Actualizado: 13 de noviembre de 2026. Dirección vigente: **RPG roguelite por turnos con pueblo persistente**. El diseño de la primera expedición está documentado en [EXPEDICION-001.md](EXPEDICION-001.md). La muestra Godot 0.2 es la base histórica; el nuevo ciclo está implementado en 0.3.0-dev y continúa en validación. Ver [AVANCE-003.md](AVANCE-003.md).

## Objetivo

Convertir Aventura del Valle en un roguelite 2D de expediciones. El jugador prepara una incursión desde un pueblo que conserva habitantes y reconstrucciones; explora rutas ramificadas, combate por turnos, elige recompensas y decide hasta dónde arriesgarse. Retirarse o vencer deposita los materiales transportados; caer los pierde todos. Los desbloqueos anteriores y el almacén del pueblo permanecen. Los contactos nuevos se consolidan solo al regresar con éxito según la especificación del piloto.

El tono combina desafío, descubrimiento y recuperación del valle. La muerte debe cerrar una expedición, no borrar la campaña. Las mejoras permanentes deben abrir opciones y sostener la historia, sin sustituir las decisiones tácticas por una escalada ilimitada de estadísticas.

## Resumen de fases

| Fase | Resultado | Estado | Dependencia |
|---|---|---|---|
| F0 | Alcance mínimo y base Godot | Hecho | Ninguna |
| F1 | Prototipo incremental de la primera aventura | Hecho; histórico | F0 |
| F2 | Diseño del nuevo ciclo y prototipo de expedición | Implementado 0.3; validación exportada/humana en curso | F1 como base reutilizable |
| F3 | Vertical slice roguelite con una expedición completa | Base del piloto implementada; pendiente de aceptación jugable | F2 |
| F4 | Pueblo persistente, campaña y variedad de expediciones | Pendiente | F3 |
| F5 | Retos, balance, accesibilidad y contenido avanzado | Pendiente | F4 |
| F6 | Preparación de publicación | Pendiente | Candidato de las fases anteriores |

F1 acredita una aventura completa jugable y sistemas persistentes, pero no valida el género nuevo. Los hitos anteriores y sus pruebas se conservan en [AVANCE-001.md](AVANCE-001.md) y [AVANCE-002.md](AVANCE-002.md).

## F0 — base y reglas mínimas — completada

Proyecto Godot 4.7.2 con GDScript, exportaciones Windows/web, combate por turnos, mapa, economía y guardado. Consultar informes por el alcance exacto. La base se reutilizará donde encaje; no obliga a conservar las reglas incrementales.

## F1 — aventura original — completada como prototipo histórico

La primera versión implementó el pueblo, bosque, mina, herrería, ayudantes, guardián y faro, junto a producción offline y tres estilos. El usuario completó la restauración del faro y probó la versión 0.2. Esta historia y sus activos pueden servir como prólogo, zona inicial o contenido de la campaña, tras adaptarlos al nuevo ciclo.

## F2 — rediseño del ciclo roguelite y prototipo de expedición — implementado, en validación

0.3 implementa las reglas definidas en EXPEDICION-001.md. E1–E5 tienen código y comprobaciones de lógica/persistencia; E6 está en revisión. Mantener como criterios del hito los puntos siguientes y registrar las comprobaciones de plataforma en AVANCE-003.md.

- Diseñar estados y flujo: pueblo → preparar → elegir expedición/ruta → explorar y combatir → jefe, retirada o derrota → resolver botín y regreso.
- Separar explícitamente estado persistente de campaña y estado temporal de expedición. Especificar qué se conserva, pierde, convierte o desbloquea al volver.
- Prototipar una expedición corta con bifurcaciones legibles, encuentros, al menos una decisión de recompensa y un jefe final.
- Usar combate por turnos y los estilos/equipo existentes como andamiaje; registrar clases y talentos como provisionales, sin hacer ahora una pasada de balance que el usuario aplazó.
- Probar una pequeña selección de reliquias/mejoras temporales que genere sinergias y elecciones con costes reales.
- Usar mapa de rutas con pequeños escenarios explorables según D10/D11; generación aleatoria completa no es requisito del prototipo.
- Definir la duración objetivo de una expedición, guardado y reanudación a mitad de intento, retirada voluntaria y recuperación tras cierre inesperado.

Aceptación: una persona puede iniciar, tomar decisiones tácticas, llegar al final o retirarse, entender qué conservó y empezar otra expedición. La segunda tentativa cambia al menos ruta/recompensas/encuentros de forma que produzca decisiones diferentes. La persistencia no duplica premios ni convierte la derrota en pérdida de campaña.

## F3 — vertical slice

- Construir una región de expedición con inicio, varias rutas, encuentros variados, eventos/recompensas y jefe.
- Añadir botín temporal: equipo, consumibles y reliquias que cambien la estrategia dentro de esa tentativa.
- Introducir recursos persistentes obtenidos en expedición y uno o dos proyectos del pueblo que los gasten en desbloqueos concretos.
- Hacer persistente la expedición en curso, incluida semilla/ruta, estado de salas, inventario temporal y resultado pendiente.
- Dar a los enemigos patrones que se puedan leer y responder; la variedad debe producir decisiones, no solo más PV.
- Crear la transición completa de regreso por victoria, retirada o caída, con resumen comprensible.

Aceptación: varias expediciones consecutivas funcionan de extremo a extremo, pueden guardarse y reanudarse, no duplican recompensas y el campamento ofrece una mejora persistente que cambia opciones disponibles. Validación jugable humana requerida además de comprobaciones automáticas.

## F4 — pueblo y campaña persistentes

- Convertir reconstrucción, ayudantes y misiones en metaprogresión conectada a expediciones.
- Desbloquear destinos, personajes, servicios, objetos iniciales, eventos y rutas nuevas mediante hitos de campaña.
- Dar a cada región identidad, bioma, eventos, enemigos, jefe y materiales propios.
- Integrar el faro como hito narrativo en el nuevo orden; decidir si la historia de 0.1/0.2 se conserva como prólogo o se reinicia en una campaña nueva.
- Controlar la inflación: mejoras permanentes favorecen variedad, preparación y comodidad; las mejoras de poder son limitadas y se calibran contra la dificultad.
- Sustituir producción offline continua como fuente principal del progreso. Si se conserva alguna actividad del pueblo entre sesiones, que sea optativa, acotada y subordinada a las expediciones.

Aceptación: la campaña tiene metas próximas y un cierre reconocible; los intentos fallidos aún avanzan por descubrimiento, historia o recursos; nuevos desbloqueos cambian las posibilidades sin hacer trivial el contenido anterior.

## F5 — profundidad y pulido

- Añadir desafíos opcionales/modificadores de dificultad, rutas de riesgo, encuentros especiales y variantes de jefes.
- Completar equipamiento, configuraciones y sinergias, haciendo balance de clases cuando se retome esa prioridad.
- Evaluar generación modular reproducible por semilla; validar conectividad, accesibilidad de recompensas y ritmo antes de usarla a gran escala.
- Mejorar diario, mapa de nodos, resumen de expedición, estadísticas y legibilidad de probabilidades/reglas.
- Revisar controles, accesibilidad, mando, táctil y rendimiento en plataformas objetivo.

Aceptación: diversidad estratégica real entre intentos, dificultad comprensible y ajustable si las pruebas lo justifican; ningún reto opcional bloquea la campaña.

## F6 — preparación de publicación

- Confirmar plataforma y navegadores objetivo; comprobar guardado, suspensión/reanudación, exportación e importación en cada uno.
- Probar tutorial, dificultad, ritmo de sesiones, accesibilidad, audio y rendimiento con jugadores.
- Verificar migración o separación explícita de partidas del prototipo 0.2; ofrecer copia/exportación antes de cambios incompatibles.
- Revisar licencias, créditos, instalación, controles y notas de versión.
- Preparar una versión candidata reproducible. Publicar se decide como acción separada cuando esté en alcance.

Aceptación: lista de comprobaciones con evidencia, limitaciones registradas y paquete reproducible. Una exportación exitosa no sustituye probar una campaña completa.

## Siguiente paso concreto

El usuario confirmó el funcionamiento general del piloto 0.3 después de las comprobaciones exportadas. Propuesta siguiente: una entrega de rejugabilidad en el Bosque del Sendero, variando encuentros/eventos sobre escenarios fijos y añadiendo secretos/objetivos del pueblo. Concretar alcance con el usuario; todavía no implementado. El balance fino, Q01 (armas tácticas) y la generación de geometría permanecen aplazados. La duración/dificultad sigue sin medición humana detallada.

## Registro de entregas

2026-11-09 — 0.1.0-dev y 0.2.0-dev: prototipo incremental en Godot, historia completada por el usuario y persistencia/comprobaciones registradas en AVANCE-001/002. Se conserva como base y versión histórica; no se presenta como roguelite.

2026-11-09 — nueva dirección aprobada: roguelite por turnos con pueblo y campaña persistentes; F2 reordenada para diseñar y prototipar el ciclo de expedición. Ver D09.

## Actualización de acuerdos — 2026-11-13 (D10)

D10 acordó Guerrero/Asesino/Mago, botín compatible, pérdida de mochila al caer y escenarios explorables. D11 concretó rescates al regresar a salvo y ausencia de huida en combate. Estas reglas están implementadas en el piloto 0.3; la campaña completa y el balance humano siguen pendientes.

F3/F4 incorporan especializaciones desbloqueadas por edificios/personajes/misiones. Catálogo concreto aún provisional. El balance fino de clases sigue aplazado.

F5 contempla el desarrollo procedural gradual: contenido variable en mapas fijos → módulos hechos a mano con conexiones variables → reglas por bioma. Es una ampliación futura, no requisito de la primera expedición; mantener semillas reproducibles y validación de recorridos.


2026-11-13 — 0.3.0-dev: piloto de expediciones implementado; siete escenarios visitados entre dos bifurcaciones, tres especializaciones básicas, botín temporal, Mara, dos proyectos y ranura independiente. Comprobaciones automáticas y estado de exportación/interfaz en AVANCE-003.md.

## Entrega 0.3 — 13 de noviembre de 2026

Implementado el primer ciclo roguelite (X01–X05), con exportaciones Windows/Web. Recorrido web completo con Guardián, rescate, victoria, depósito y edificio comprobados; derrota y retirada revisadas mediante estados preparados. 1842 comprobaciones automáticas aprobadas en el build registrado. X06 sigue parcial por juego humano de ritmo/balance y recorrido visual nativo completo; ver AVANCE-003.md. La siguiente acción es probar esta entrega antes de ampliar subclases o procedural.

## Entrega 0.4 — 14 de noviembre de 2026

Implementada variedad de contenido en escenarios fijos: variantes de encuentros y tres eventos opcionales, persistidos al iniciar la salida. No se genera geometría nueva. Compatibilidad con salidas 0.3 conservada. Evidencia en AVANCE-004.md. Próximo paso vigente: recoger experiencia del usuario con variedad/eventos; secretos y encargos permanecen pendientes.

## Nueva dirección narrativa — Ascendant Odyssey

D15, 14 de noviembre de 2026: unificar mundo e historia con el proyecto anterior del usuario y sus amigos. La próxima preparación de contenido debe partir de INTEGRACION-ASCENSION.md: establecer continuidad del valle con la Gran Montaña, acordar el papel de personajes y preparar una primera misión de facción. La propuesta «El registro perdido de Chaan» conecta los encargos/secretos con Ohr y el Necrovórtice; aún no está implementada ni aprobada en sus detalles. No ampliar primero con encargos genéricos desconectados de este universo.


## Revisión visual actual — 2026-11-14

D25/D26 y X12: muestra independiente de exploración/diálogo preparada, con tipografía «Pixel art legible» escogida por el usuario. Revisar esta versión antes de diseñar la pantalla de combate y convertir la dirección elegida en recursos e interfaz Godot. No amplía la versión 0.4 ni implementa aún el prólogo. Véanse DIRECCION-VISUAL.md y muestras/necrovortice-v1/LEEME.md para imágenes, procedencia y comprobaciones.


Actualización visual D27: V2 de marcos curvos, cintas turquesa y anillos dorados preparada en muestras/necrovortice-v2; Almendra mantenida en diálogo. Revisar esta muestra antes de diseñar combate e integrar recursos en Godot. La V1 queda disponible para comparar. X12 continúa parcial.


Actualización D30 — 2026-11-16: primera HUD nativa implementada en laboratorio Godot independiente (muestras/hud-godot). X12 avanza con recursos/controles nativos y comprobaciones registradas en AVANCE-HUD-001.md; sigue parcial por revisión humana, integración con la campaña, combate y otros tamaños/plataformas. El mundo 2D y el juego principal no cambiaron.


Actualización D31 — 2026-11-16: HUD de exploración integrada en la campaña 0.5.0-dev con datos reales, menú/mapa/mochila y reglas existentes. Ver AVANCE-005.md. La conexión y las pruebas automatizadas están hechas; quedan revisión humana y dirección visual de combate, móvil/mando y arte/narrativa. El laboratorio de HUD se conserva como referencia.
