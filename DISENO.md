# Diseño del juego

Estado: dirección aceptada; muestra 0.2.0-dev implementada, con el primer alcance de estilos y equipo. Las cifras actuales son provisionales y el diseño completo sigue por desarrollar. Fecha: 2026-11-09.

## Visión

RPG incremental 2D de exploración y reconstrucción. El aventurero recupera lugares y ayuda a sus habitantes; estos producen recursos y preparan la siguiente aventura incluso durante las ausencias. El pueblo muestra físicamente el progreso.

Ciclo central: explorar → recuperar un lugar o habitante → desbloquear producción → asignar ayudantes → fabricar y preparar equipo → superar un encuentro → transformar el valle.

Principios:

- Cada sistema debe alimentar la aventura o la reconstrucción.
- Las mejoras importantes introducen opciones o cambian decisiones.
- La actividad del jugador descubre y supera hitos; la automatización resuelve tareas conocidas.
- Ausentarse permite avanzar sin exigir tener la pestaña abierta.
- Los objetivos y las reglas son visibles dentro del juego.
- La dificultad admite preparación y estrategias, además de mejoras estadísticas.
- Una sesión corta debe poder lograr algo reconocible.
- Los reinicios son voluntarios y su efecto se explica antes de aceptarlos.

## Catálogo de propuestas jugables

### J01 — reconstrucción visible del pueblo

Reparar mina, herrería, molino y puente; cada obra cambia el mapa y habilita una función. Rescatar al herrero permite fabricar; recuperar su mina aporta materiales. El orden y los costes deben probarse para evitar un bloqueo circular.

Primera versión: mina y herrería. Más adelante: otros edificios y consecuencias regionales.

### J02 — ayudantes con funciones distintas

El minero obtiene mineral, el cazador ingredientes y el alquimista prepara pociones. Una plantilla limitada permite elegir dónde trabajar. La reasignación debe ser libre y comprensible. Definir si cada ayudante es un personaje único, una profesión o un grupo antes de ampliar el sistema.

### J03 — explorar desbloquea economía

Descubrir vetas, limpiar bosques y abrir caminos habilita materiales y rutas comerciales. La producción automática proporciona equipo y suministros para alcanzar nuevos lugares. No convertir todos los recursos en simples nombres alternativos de monedas.

### J04 — combate por turnos con información útil

Conservar la base por turnos. Anunciar intenciones enemigas y dar utilidad a defender, interrumpir, curar y aplicar estados. Ejemplo: un gólem prepara un golpe pesado y el jugador decide cómo responder. Comenzar con pocas acciones bien diferenciadas.

### J05 — jefes con identidad

Ejemplos propuestos: Rey Slime que se divide, gólem con armadura rompible y dragón que prepara su aliento. No son diseños finales. Cada jefe debe enseñar o poner a prueba una decisión distinta, con señales legibles y posibilidad de preparación.

### J06 — estilos de personaje intercambiables

Tres orientaciones iniciales: guerrero defensivo, mago de estados y explorador de críticos. Permitir redistribuir talentos en el pueblo y guardar configuraciones. Cerrar costes y restricciones mediante pruebas; no castigar la experimentación con decisiones irreversibles inesperadas.

### J07 — equipo que modifica habilidades

Ejemplos: recuperar maná al bloquear, extender quemaduras o mejorar escudos. Pocas ranuras y una colección inicial pequeña. Comparar atributos y efectos antes de equipar. Guardar conjuntos y proteger objetos importantes frente a venta o desmontaje accidental.

### J08 — automatizar lo dominado

Delegar actividades después de conocerlas: patrullas de zonas despejadas, fabricación y tareas repetidas. Los descubrimientos y la primera victoria contra un jefe siguen siendo hitos activos. Hacer visibles las condiciones de desbloqueo y las causas de detención.

### J09 — progreso offline elegido y explicado

Asignar trabajo o expediciones antes de salir; al volver, resumir tiempo, recursos producidos/consumidos, tareas terminadas y límites alcanzados. Comenzar con tareas seguras. La muestra usa 8 horas por ausencia, capacidad de 9999 minerales/lingotes y tareas seguras. Son valores provisionales; el balance final y las condiciones de un posible combate offline siguen pendientes.

### J10 — misiones que transforman el mundo

Alternar encargos cortos con cadenas de desbloqueo. Ejemplo: rescatar al boticario → reconstruir tienda → descubrir cura → entrar al pantano. Diario con objetivo, ubicación, progreso y recompensa. Conservar el efecto de los hitos de historia según las reglas de persistencia acordadas.

### J11 — renacimiento con cambios importantes

Replantear el reinicio del HTML. Propuesta aceptada como dirección: conservar pueblo, descubrimientos y automatización básica, reiniciar parte del progreso del aventurero y abrir especializaciones, reliquias o variantes. Cada ciclo debe ofrecer una opción nueva y una recuperación más cómoda del tramo ya dominado.

Antes de implementar: especificar campo por campo qué persiste y qué reinicia; relación con historia, misiones, equipo, ayudantes y edificios; momento de desbloqueo; prevención de duplicación de recompensas. No asumir que las gemas y los multiplicadores del HTML son reglas definitivas.

### J12 — exploración, secretos y regreso cómodo

Regiones principales diseñadas a mano, con identidad, rutas alternativas, habitantes, secretos y recompensas especiales. Atajos y viaje rápido entre lugares descubiertos. Mazmorras variables mediante módulos se evalúan en F5, tras comprobar la exploración básica.

### J13 — desafíos opcionales

Probar estrategias mediante restricciones claras: sin pociones, equipo limitado o resistencia al daño directo. Recompensas alternativas y útiles; no obligar a completar todos para avanzar en la historia principal. Debe existir una salida clara del desafío.

### J14 — ritmo compatible con sesiones cortas

Objetivos inmediatos como fabricar una pieza o resolver un encargo y metas largas como recuperar una región. Evitar rachas obligatorias y obligaciones diarias que penalicen ausencias. Equilibrar juego activo y automático sin convertir uno en irrelevante.

## Interfaz y comodidad

- Diario de misiones y consulta de estadísticas, bonificaciones y producción.
- Identificación de PNJ y servicios, mapa de destinos y avisos de nuevas funciones.
- Comparación de equipo, conjuntos guardados, filtros y protección de objetos.
- Colas de fabricación y compras por lotes cuando reduzcan repetición útilmente.
- Vista clara de costes, requisitos, consumos, capacidad y causas de parada.
- Texto adaptable, diálogos paginados, teclado, ratón, mando y revisión táctil.
- No comunicar información esencial únicamente mediante color; opciones de volumen y movimiento visual cuando proceda.

## Alcance y límites de diseño

Las referencias inspiran relaciones entre sistemas, no una copia de sus contenidos o su escala. No hay decisiones sobre multijugador, monetización, cuentas, servicios en la nube o eventos periódicos. No forman parte de la primera entrega.

Evitar introducir muchos minijuegos inconexos, recursos redundantes o capas de prestigio que solo alarguen el tiempo. Ampliar tras observar que el ciclo central funciona.

## Preguntas que requieren prototipo

- ¿Cuánto disfruta el jugador del combate repetido y cuándo conviene delegarlo?
- ¿Cuántos recursos y tareas puede comprender sin consultar una guía externa?
- ¿La actividad desbloquea opciones útiles mientras la producción conserva su valor?
- ¿El pueblo da una sensación visible de recuperación?
- ¿Las configuraciones de personaje ofrecen alternativas y costes de oportunidad reales?
- ¿El renacimiento aporta suficiente novedad y respeta el progreso que promete conservar?

## Concreción de F2 en la muestra 0.2

Se implementan las orientaciones de J06 mediante pasivas y una elección entre dos talentos, sin puntos ni niveles. J07 incorpora tres armas de herrería y dos reliquias. Configuración gratuita en el pueblo y recordada para cada estilo. Para que un jugador que ya restauró el faro pueda experimentar, se añade entrenamiento sin premios ni cambios de historia, con suministros prestados y restaurados al confirmar el resultado. Las cifras y reglas exactas están en juego/LEEME.md.

Los comportamientos de los enemigos siguen usando la base de golpe pesado cada tercer turno; su diferenciación y la ampliación de exploración permanecen pendientes de F2. No se afirma que toda la fase esté terminada.
