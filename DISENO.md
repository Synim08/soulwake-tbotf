# Diseño del juego

Estado: dirección roguelite aceptada (D09/D10), diseño detallado pendiente. Acuerdos ampliados el 13 de noviembre de 2026. Prototipo Godot 0.2.0-dev implementado como etapa anterior; no contiene todavía el ciclo roguelite. Actualizado: 13 de noviembre de 2026. La primera expedición está implementada en el piloto 0.3 (D12), con evidencia y límites en AVANCE-003.md.

## Visión

RPG roguelite 2D por turnos sobre expediciones desde un pueblo que se reconstruye. Cada intento ofrece rutas, encuentros y combinaciones de recompensas distintas. Una expedición puede terminar en victoria, retirada o caída; el aventurero vuelve al pueblo, donde continúan la historia, los desbloqueos y la preparación de futuros intentos.

**Ciclo central propuesto:** preparar en el pueblo → elegir destino/ruta → explorar y combatir → escoger recompensas temporales → arriesgarse, retirarse o vencer al jefe → resolver pérdidas y botín recuperado → mejorar/desbloquear opciones persistentes → volver a salir.

La muerte cierra una expedición y pierde todos sus materiales transportados y mejoras temporales; conserva la campaña y lo ya almacenado en el pueblo (D10). La tensión debe venir de decisiones legibles sobre ruta, recursos, combate y cuándo retirarse. La metaprogresión debería abrir opciones y contenido; las bonificaciones de poder serán limitadas para no convertir cada intento en una victoria automática.

## Principios

- El combate por turnos existente es la base inicial; cada acción enemiga debe poder leerse y provocar una respuesta táctica.
- Las elecciones durante una expedición deben combinarse: armas, reliquias, habilidades, consumibles, eventos y rutas pueden crear sinergias.
- El riesgo y la recompensa se muestran antes de elegir. La derrota puede costar botín temporal, con reglas claras y sin borrar desbloqueos de campaña.
- El pueblo cambia visiblemente y ofrece nuevos servicios, historias, rutas y posibilidades de preparación.
- Cada intento debe tener un cierre satisfactorio incluso si no se derrota al jefe.
- Las sesiones deben poder guardarse y reanudarse; no exigir rachas ni penalizar la ausencia.
- No añadir aleatoriedad que oculte información táctica ni sistemas desconectados solo para aumentar duración.

## Capas de progreso por definir en F2

| Capa | Ejemplos | Regla de intención |
|---|---|---|
| Campaña persistente | pueblo, personajes, misiones, destinos, servicios y relatos | se conserva entre expediciones |
| Expedición temporal | ruta visitada, PV/PM, consumibles, armas/reliquias halladas, monedas de riesgo | puede perderse, gastarse o convertirse al regresar |
| Desbloqueos duraderos | nuevas opciones de inicio, objetos que entran al conjunto posible, rutas/eventos | amplían variedad más que estadísticas infinitas |
| Hitos de región | jefe, rescate, restauración del faro u otro objetivo narrativo | efecto persistente definido por misión |

D10 fija los resultados: retirada desde un lugar despejado conserva materiales y termina el intento; victoria añade el hito/premio del jefe; caída pierde todos los materiales transportados. Los desbloqueos anteriores y el almacén del pueblo permanecen. Para el piloto, rescates/contactos se consolidan al retirarse o vencer; caer los descarta. El jefe termina inmediatamente la salida y su hito se consolida una vez. Ver EXPEDICION-001.md, sección 7.

## Sistemas jugables

### Combate, clases y jefes

Reutilizar provisionalmente las acciones, estilos, talentos y equipo de 0.2. Distinguir enemigos por patrones, señales y respuestas; crear jefes que prueben decisiones diferentes (por ejemplo, romper guardia, interrumpir una carga o aprovechar ventanas). El usuario aplazó el balance fino de clases: no es el primer bloque de trabajo.

### Expediciones y rutas

Prototipar un mapa corto de nodos o habitaciones conectadas con bifurcaciones, eventos, encuentros y recompensas. En cada cruce debe haber una elección informada: ruta segura, tesoro, curación, comerciante, evento o combate de riesgo. Usar contenido modular y semilla reproducible si ayuda a repetir pruebas; no es necesario generar mapas completos de forma procedural desde el inicio.

### Recompensas y sinergias

Durante la salida se obtienen mejoras que terminan al volver, salvo la parte explícitamente rescatada. Ejemplos para explorar: quemadura que da escudo al derrotar; bloqueo que potencia el siguiente hechizo; crítico que extiende una marca; sacrificar curación por una reliquia más potente. Las sinergias deben ser entendibles y ofrecer elecciones entre opciones con ventajas y costes.

### Pueblo y reconstrucción

El pueblo es la base entre intentos. Recuperar edificios y habitantes desbloquea preparación, entrenamiento, objetos, servicios, información y destinos. Se conserva la fantasía de reconstruir el valle; la producción offline de materiales no será la progresión central. Cualquier actividad entre sesiones será secundaria, opcional y limitada.

### Historia y faro

La aventura actual de mina, herrería, guardián y faro está terminada y validada en el prototipo. Decidir si se adapta como prólogo/primera expedición o como una región que se rediseña para el nuevo flujo. Mantener la historia y los guardados actuales hasta documentar la transición.

### Sesiones y accesibilidad

Mantener objetivos inmediatos, resumen de regreso, lectura clara de intención/riesgo y controles de teclado/ratón. Revisar mando, táctil, escalado, accesibilidad y duración tras definir la plataforma y probar el prototipo.

## Preguntas para el prototipo F2

- Precisar la resolución de misiones/rescates y la huida durante combate; las pérdidas de materiales ya están acordadas en D10.
- ¿Qué metamoneda existe, en qué se gasta y cómo se evita que solo compre poder acumulativo?
- ¿Cuánto dura un intento y cuántas decisiones relevantes contiene?
- Concretar el mapa de rutas y los pequeños escenarios explorables acordados en D10.
- ¿Se puede guardar en mitad de la expedición y reanudar exactamente?
- ¿Qué papel tienen clases, armas y reliquias durante una tentativa y entre intentos?
- ¿La aventura del faro es prólogo, región inicial o se vuelve a plantear?
- ¿Qué actividad opcional del pueblo ocurre entre sesiones sin volver a un incremental?

## Inspiración y límites

Hades inspira la mezcla de intentos distintos, elecciones de construcción, dificultad configurable e historia que progresa entre intentos; no se busca copiar acción en tiempo real ni su escala narrativa. Loop Hero inspira conectar botín de expedición con mejoras de campamento; se conserva el combate por turnos y se diseñará un ciclo propio. Fuentes y límites en [INVESTIGACION.md](INVESTIGACION.md).

## Alcance no acordado

No están aprobados multijugador, monetización, cuentas, servicios en la nube, eventos periódicos ni publicación concreta. La generación procedural extensa, juego offline de expediciones y sistemas de prestigio quedan fuera del primer prototipo.

## Relación con la muestra 0.2

La versión existente tiene tres estilos, talentos, armas/reliquias, entrenamiento sin recompensas, mapas fijos, guardado persistente y una economía con producción offline. Se conserva como referencia y base técnica. El entrenamiento no equivale a una expedición con progresión y consecuencias. No se debe eliminar o sustituir la ranura de usuario hasta diseñar copia y compatibilidad. Reglas numéricas actuales: [juego/LEEME.md](juego/LEEME.md); pruebas y límites: [AVANCE-002.md](AVANCE-002.md).

## Acuerdos de especialización y escenarios — 2026-11-13

Clases iniciales: Guerrero, Asesino y Mago. Elegir especialización antes de salir; edificios, personajes y misiones desbloquean opciones. El catálogo de botín combina objetos comunes con armas/mejoras de la especialización activa. El Explorador de 0.2 se adaptará a Asesino. Los seis nombres de especialización y edificios mencionados en conversación son ejemplos provisionales, no contenido implementado.

Exploración en dos escalas: elegir rutas en el mapa general y controlar al personaje en pequeños escenarios con desvíos, personajes, encuentros y secretos. Futuro procedural gradual: primero variar contenido de mapas fijos; después conectar módulos hechos a mano; finalmente aplicar reglas por bioma. Reproducir mediante semilla y validar acceso a salida, recompensas y objetivos.

Objetivo provisional de primera prueba: 15–25 minutos, seis a ocho lugares visitados, dos bifurcaciones relevantes, reliquias con sinergias y jefe. Revisar estas cifras al jugar.

## Primera expedición concretada — D11

[EXPEDICION-001.md](EXPEDICION-001.md) fija el alcance del siguiente prototipo: siete lugares visitados, dos bifurcaciones, Guardián/Duelista/Piromante iniciales, doce mejoras temporales, armas compatibles, eventos, jefe y dos proyectos del pueblo. Mantener las cifras como parámetros revisables. Las preguntas generales anteriores se concretan para este piloto mediante sus reglas de persistencia, escenarios y resultados; la campaña completa sigue abierta.

Siguiente trabajo: implementar E1–E6 de esa especificación. No confundir diseño documentado con funciones exportadas o comprobadas.

## Estado jugable 0.3

EXPEDICION-001 ya tiene implementación y exportaciones independientes. AVANCE-003.md registra el recorrido web y los límites. Queda evaluar con el usuario el ritmo, la claridad de rutas y la dificultad antes de avanzar a nuevos contenidos.

## Contenido variable 0.4

El campamento puede incluir mercader, altar o viajero, con costes visibles y resolución única. Variantes de patrones por nodo se eligen al comenzar, sin alterar el terreno. Véase AVANCE-004.md para reglas concretas y limitaciones. Nuevas expediciones reciben el contenido; partidas 0.3 en curso mantienen su recorrido original.

## Universo narrativo Ascendant Odyssey

D15 adopta el mundo y la historia del proyecto anterior como referencia de la unificación. La propuesta de conectar el refugio con la Gran Montaña, el Necrovórtice, personajes y facciones se detalla en INTEGRACION-ASCENSION.md. Sus adaptaciones particulares son propuestas hasta resolver versiones y papel de los protagonistas. El género, tres clases iniciales y guardado del piloto se mantienen como base; no se traslada automáticamente el combate de acción original.
