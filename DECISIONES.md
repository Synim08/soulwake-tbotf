# Decisiones y registro de cambios

Última actualización: 2026-11-13.

## Decisiones aceptadas

### D01 — ampliar el juego con Godot y GDScript

Fecha: 2026-11-09. Estado: aceptada como dirección.

El usuario quiere un juego más grande y aceptó la recomendación de Godot. El objetivo es facilitar mapas, contenido, interfaces y reutilización. La elección no corrige por sí sola los errores de lógica del prototipo ni acredita mejoras de rendimiento. No se iniciará una reescritura en C como parte de esta dirección.

### D02 — conservar la posibilidad de navegador

Fecha: 2026-11-09. Estado: dirección técnica.

El navegador es una opción válida para el usuario. Se contempla exportación web con GDScript y se mantiene escritorio como posibilidad. No se ha acordado todavía la plataforma de la primera publicación ni una lista de dispositivos garantizados.

### D03 — exploración, reconstrucción y ayudantes conectados — dirección anterior, reemplazada parcialmente por D09

Fecha: 2026-11-09. Estado: dirección aceptada.

Esta fue la visión del RPG incremental aprobada inicialmente. D09 cambia el ciclo principal: se conservan exploración, reconstrucción y habitantes, pero producción continua/offline deja de ser el motor de la progresión. Las propuestas se mantienen solo cuando apoyan las expediciones roguelite.

### D04 — primera muestra incremental — hito histórico completado

Fecha: 2026-11-09. Estado: alcance del prototipo 0.1, completado como historia previa a D09.

Objetivo inicial: pueblo con herrería reparable, bosque, mina, tres enemigos, jefe y dos ayudantes. Validar el ciclo completo y el guardado antes de construir una campaña extensa. Las cantidades son una referencia inicial que se puede ajustar con motivo documentado.

### D05 — documentación mantenible y evidencia

Fecha: 2026-11-09. Estado: solicitada explícitamente por el usuario.

Mantener roadmap, diseño, técnica, backlog, decisiones e investigación para conservar todas las ideas y actualizar el trabajo. Distinguir aprobado, propuesto, implementado y comprobado. No marcar el motor, las plataformas ni las mecánicas como implementados por aparecer en un plan.

## Reglas todavía por concretar

El prototipo 0.2 usa Godot 4.7.2 y sus estadísticas, costes y límite offline siguen descritos en juego/LEEME.md como reglas de esa versión. D09 reemplaza el ciclo incremental como dirección vigente. Siguen pendientes las decisiones del roguelite O08–O14 en BACKLOG.md, el balance de clases (aplazado), alcance de campaña y plataforma final.

## Plantilla para nuevas decisiones

ID y título:

Fecha y estado:

Problema o necesidad:

Decisión y motivo:

Alternativas consideradas, si resultan relevantes:

Tareas, reglas y guardados afectados:

Evidencia y cuestiones pendientes:

## Registro de cambios

### 2026-11-09 — documentación inicial

- Conservada la dirección acordada en esta conversación.
- Registradas las 14 ideas jugables y 12 líneas de trabajo técnico; las ocho prioridades técnicas iniciales se desarrollan y complementan con herramientas, números grandes y mantenimiento.
- Organizado el trabajo en F0–F6, con dependencias y criterios de aceptación.
- Registrados los fallos reproducidos de derrota/victoria y la observación de tiempo del HTML.
- Conservada la limitación de las pruebas: no hubo partida completa ni validación móvil real.
- Añadidas referencias oficiales y opiniones de usuarios con su alcance.
- Incluida una copia del prototipo original para futuras comparaciones.
- Sin implementación nueva, publicación ni cambios en el HTML original.

## D06 — valores operativos de la primera muestra

Fecha: 2026-11-09. Estado: decisiones de implementación provisionales para probar la dirección aceptada.

Motor 4.7.2, renderizador Compatibility, GDScript, lienzo 1152×768 y movimiento por casillas. Primera cadena: lobo abre mina → reparar herrería → Mara produce mineral e Ivo lingotes → fabricar espada → guardián → restaurar faro. Ayudantes con funciones fijas en esta muestra; su reasignación a profesiones diferentes pertenece a F3.

Reglas iniciales: offline hasta 8 horas; vida 38 y maná 12; derrota pierde hasta 5 monedas, conserva materiales y recupera vida/maná al confirmar el regreso; retirada segura. Enemigos vencidos no reaparecen. Venta de mineral a 3 monedas para evitar un bloqueo económico. Sin audio ni migración del HTML; partidas de las versiones HTML, web Godot y Windows son independientes.

No son nuevos compromisos de balance aprobados uno a uno por el usuario. Se adoptan como punto de partida reversible y deben ajustarse según las pruebas. Se mantienen abiertas las decisiones posteriores de campaña, talentos y renacimiento.

### 2026-11-09 — primera implementación

- Creado el proyecto Godot, los datos de enemigos y los servicios de combate, producción y guardado.
- Construidas tres regiones y el primer ciclo de reconstrucción.
- Generadas exportaciones web y Windows; verificadas con el alcance descrito en AVANCE-001.md.
- Registradas 42 comprobaciones de lógica aprobadas; no equivalen a una prueba humana completa ni a validación móvil.
- F0 completada y F1 en curso. El objetivo siguiente es probar y pulir esta muestra antes de ampliar contenido.

### 2026-11-09 — recorrido principal validado por el usuario

El usuario confirmó haber vencido al guardián y restaurado el faro, tras declarar que el juego funciona a la perfección. Se acredita el recorrido humano completo de la muestra. Plataforma, duración y estrategia no especificadas. F1 sigue en curso por las comprobaciones de persistencia y flujo de copias pendientes; esta validación no demuestra soporte móvil o equilibrio de sesiones largas.

## D07 — cerrar F1 y entregar una primera selección de F2

Fecha: 2026-11-09. Estado: implementación de la continuación autorizada por el usuario.

F1 se cierra para escritorio/navegador horizontal tras validar el recorrido humano y completar copias, derrota y ausencia real en Chromium. El alcance no se extiende a móvil/mando sin pruebas.

F2 comienza con tres estilos y dos talentos alternativos por estilo, gratuitos en el pueblo. La herrería ofrece espada, bastón y arco tras el hito de fabricación existente; el guardián desbloquea dos reliquias. Cada estilo recuerda su equipo y talento. Se elige un entrenamiento sin premios y con suministros restaurados para probar esta ampliación después del final actual. Estas son decisiones de prototipo reversibles, no balance definitivo.

La compatibilidad de partidas se amplía mediante esquema 2 y migración desde esquema 1, conservando el progreso narrativo y una copia original separada. Los nuevos estados de combate persisten. Las pruebas y límites se registran en AVANCE-002.md.

## D08 — aplazar los ajustes de clases

Fecha: 2026-11-09. Estado: preferencia explícita del usuario tras probar 0.2.

El usuario considera la versión satisfactoria y pide atender los arreglos de clases más adelante. Se aplazan los ajustes de balance y reglas de clases/talentos; el siguiente bloque propuesto de F2 se centra en enemigos y exploración. La aceptación de la muestra no se interpreta como equilibrio definitivo ni finalización de toda F2.

## D09 — cambiar la dirección a roguelite de expediciones

Fecha: 2026-11-09. Estado: **aceptada por el usuario; diseño por concretar y aún sin implementar**.

El objetivo deja de ser un RPG incremental centrado en producción continua/offline. La nueva dirección es un roguelite 2D por turnos, con expediciones que cambian entre intentos y un pueblo/campaña persistentes. Ciclo propuesto: preparar en el pueblo → elegir una expedición y ruta → explorar, combatir y escoger recompensas → llegar al jefe, retirarse o caer → liquidar lo recuperado y regresar → desbloquear opciones y preparar el siguiente intento.

La muerte termina el intento y puede hacer perder parte del botín temporal; no borra la campaña. El progreso persistente debe priorizar nuevos servicios, rutas, equipo, relatos y opciones tácticas. Las mejoras de poder permanentes serán acotadas para conservar decisiones y desafío. Esta regla general queda aprobada como dirección; las cantidades exactas y qué recursos sobreviven siguen abiertas.

Godot/GDScript, combate por turnos, guardado versionado, definiciones de equipo/enemigos, interfaz y partes del mundo de 0.2 son base potencialmente reutilizable. La economía offline y la cadena de producción dejan de ser el bucle central. La aventura del faro puede adaptarse como prólogo o contenido de campaña; falta decidirlo. No se reinicia ni sobrescribe la partida 0.2 sin copia y política de compatibilidad documentadas.

La primera iteración será una expedición pequeña con caminos ramificados, recompensas que creen sinergias y un jefe; generación procedural completa no es requisito. Se conservará por ahora el combate por turnos. Los ajustes finos de clases siguen aplazados según D08; se reutilizan provisionalmente para probar el ciclo.

Elementos afectados: ROADMAP F2–F6; diseño J01–J14; backlog J/T/O; arquitectura de guardado, tiempo y generación en TECNICA.md. La evidencia externa se resume en R11–R12 de INVESTIGACION.md. No hay nueva implementación en esta actualización documental.

## D10 — clases, pérdida de materiales y exploración acordadas

Fecha: 2026-11-13. Estado: dirección aceptada; pendiente de implementación.

- Clases iniciales: Guerrero, Asesino y Mago. Adaptar el Explorador del prototipo a Asesino. Cada clase tendrá especializaciones elegidas antes de salir, desbloqueadas mediante edificios, personajes o misiones del pueblo.
- El botín incluirá objetos comunes útiles y armas/mejoras del catálogo de la especialización elegida. Evitar recompensas principales incompatibles con el personaje. Mantener varias estrategias dentro de cada especialización.
- Al caer se pierden todos los materiales transportados en esa expedición y su configuración temporal. Permanecen el pueblo, materiales ya almacenados y desbloqueos anteriores. Esta decisión sustituye la propuesta de conservar un 25 % al morir.
- Retirarse desde un lugar despejado conserva los materiales recogidos y termina la expedición sin premio de jefe. Vencer al jefe conserva materiales y concede un desbloqueo/hito adicional.
- Exploración mediante un mapa general de rutas y pequeños escenarios recorribles con caminos, desvíos, secretos, personajes y encuentros.
- Ampliación futura: generación procedural por módulos diseñados a mano, avanzando desde escenarios fijos con contenido variable hacia conexiones variables y reglas por bioma. Semilla reproducible, conectividad entre entrada/salida y premios accesibles; botín sujeto a especialización.

Ejemplos aún provisionales: Guardián/Berserker, Alquimista/Duelista y Piromante/Criomante; sus edificios y nombres no constituyen un catálogo cerrado. Duración de 15–25 minutos y seis a ocho localizaciones son objetivos iniciales para probar, no cifras validadas. El balance fino de clases continúa aplazado. Falta concretar huida durante combate, misiones/rescates pendientes y momento exacto de consolidar nuevos desbloqueos.

## D11 — alcance de diseño de la primera expedición

Fecha: 2026-11-13. Estado: especificación de prototipo dentro de la continuación autorizada; pendiente de implementación y prueba humana. Los detalles numéricos son decisiones operativas reversibles, no aprobaciones individuales del usuario.

Concretado en [EXPEDICION-001.md](EXPEDICION-001.md): Bosque del Sendero con siete escenarios visitados y dos bifurcaciones, enemigo final, mejoras compatibles y regreso. Clases iniciales Guerrero/Guardián, Asesino/Duelista y Mago/Piromante, habilitadas por el Patio de aventureros de la introducción. No se amplía todavía a seis especializaciones.

Para el piloto: retorno desde nodo despejado; sin escape durante combate, aviso previo al compromiso y confirmación de veterano/jefe. Materiales transportados se depositan al retirarse/vencer y se pierden todos al caer. Mara se consolida como rescatada solo al regresar viva la expedición; si se cae, puede reencontrarse. El jefe finaliza la salida al vencer y su hito se concede una sola vez. Costes, efectos y cantidades iniciales están en la especificación y se revisarán jugando.

Usar campaña/ranura piloto independientes del incremental 0.2, sin importar automáticamente economía ni progreso. Conservar la partida antigua; la integración narrativa del faro sigue abierta. Los primeros proyectos, Botica de campaña y Banco de equipo, abren suministros y armas iniciales alternativos. No hay producción offline en este piloto.

Se mantiene aplazado el balance fino de clases y se reutilizan inicialmente pasivas/acciones de 0.2 donde encajan. Procedural modular y especializaciones adicionales vienen después de validar este ciclo. Esta entrega es documental: no altera el ejecutable ni acredita duración, balance o persistencia nuevos.

## D12 — primer piloto roguelite implementado

Fecha: 2026-11-13. Estado: entrega 0.3.0-dev, con evidencia y límites en AVANCE-003.md.

Se implementa EXPEDICION-001 en módulos de reglas, mapas, mundo, interfaz, servicio y guardado del piloto. Los catálogos iniciales son diccionarios de datos; ampliar a recursos editables cuando lo requiera el contenido. Compilaciones nuevas bajo `compilaciones/expediciones`; las históricas 0.2 y su guardado permanecen separados.

El balance fino sigue aplazado: pasivas/armas base reutilizadas, veterano nuevo y mejoras paramétricas. Escenarios a mano y cuatro rutas; aún sin generación procedural ni subclases adicionales. La partida piloto comienza con su introducción gratuita, sin convertir recursos o historia de 0.2.

Comprobaciones automáticas y recorrido web completo registrados. La próxima prioridad es jugar la versión, recoger claridad/duración/dificultad y corregir problemas observados antes de añadir sistemas.

## D13 — prueba funcional del usuario y equipo aplazado

Estado: confirmación del usuario tras jugar 0.3.

El usuario indica que funciona todo y reporta que las armas tácticas no cambian nada. Pide no priorizar ese detalle por tratarse de una prueba. Registrar Q01 como incidencia pendiente de diagnóstico y corrección, sin asumir que es solo balance o solo presentación. Se mantiene la preferencia de aplazar arreglos de equipo/clases.

Se propone continuar con variedad de contenido y objetivos de repetición en el bosque; el catálogo y alcance concreto de esa siguiente entrega aún deben acordarse.

## D14 — contenido variable 0.4

Fecha: 2026-11-14. Implementado el alcance autorizado: variantes de patrones y tres eventos opcionales. Una variante por nodo y un evento de campamento se fijan al iniciar cada salida. Mantener partidas 0.3 sin alterar sus encuentros en curso; las novedades aparecen en salidas nuevas. Reglas, costes y pruebas en AVANCE-004.md. Q01 y balance fino siguen aplazados.

## D15 — unificar el universo con Ascendant Odyssey

Fecha: 2026-11-14. Estado: dirección expresamente aceptada por el usuario tras revisar Project Ascension.

Respuesta del usuario: «Unificar el mundo y la historia, y también tomar elementos concretos». Ascendant Odyssey pasa a ser el universo narrativo de referencia, conservando la base jugable roguelite actual y adaptando el material por etapas. La revisión, fuentes, diferencias y primera misión propuesta están en INTEGRACION-ASCENSION.md.

No se ha elegido todavía el título público, el papel jugable de cada personaje ni versiones canónicas de los borradores contradictorios. No cambiar nombre de aplicación/ubicación del guardado sin migración. Q01 y el balance fino siguen aplazados. Esta actualización documenta la dirección; todavía no integra personajes ni arte en el ejecutable.


## D16 — protagonistas seleccionables

Fecha: 2026-11-14. Estado: decisión explícita del usuario: «Jugar como esos protagonistas».

El jugador elige un protagonista antes de cada expedición y controla a uno durante la salida. La dirección inicial es Thaleon (Guerrero), Ícaro (Asesino) y Caelan (Mago), cada uno con identidad e historia propias y especializaciones de su clase. Los demás pueden participar desde el refugio y la narrativa; no implica una escuadra de personajes controlados simultáneamente.

Sigrid forma parte del universo; su incorporación jugable y una posible clase de arquera quedan para una ampliación por concretar. No se decide todavía su momento de aparición. Separar identidad, clase y especialización; la magia no elemental de Caelan requiere diseño propio, no un simple cambio de nombre del Piromante.

Siguiente decisión narrativa: qué reúne al grupo y cuál es su primer objetivo común. Aún sin cambios al ejecutable o a las partidas.

## D17 — premisa inicial compartida

Fecha: 2026-11-14. Estado: aprobada explícitamente por el usuario.

Los protagonistas llegan por motivos distintos a un refugio al pie de la Gran Montaña. El camino de ascenso está interrumpido. Su primer objetivo común es recuperar los senderos y restaurar un antiguo faro para alcanzar el santuario. Reconstruir el pueblo y preparar expediciones permite avanzar a todos, conservando sus motivaciones personales.

Quedan pendientes la causa de la interrupción, por qué dejó de funcionar el faro y las circunstancias concretas de llegada/encuentro de cada protagonista. No atribuir estos hechos al Renegado ni a una propiedad destructiva inherente del Necrovórtice sin una decisión posterior. Esta premisa no está implementada en el piloto 0.4.

## D18 — pulso anómalo y misterio inicial

Fecha: 2026-11-14. Estado: aprobado por el usuario.

Un pulso anómalo del Necrovórtice alteró la zona, interrumpió el camino de ascenso y apagó el antiguo faro. Los guardianes reaccionan de forma extraña y los senderos antes seguros se volvieron peligrosos. Al comienzo se desconoce si el fenómeno fue natural o provocado. Esta incógnita debe descubrirse explorando; no se ha decidido culpable ni causa última.

Se conserva la capacidad creadora y sanadora del Necrovórtice descrita en el material original. Próxima decisión: cómo presentar al grupo y qué protagonista abre la historia. No se ha implementado esta narrativa en 0.4.

## D19 — apertura con Caelan

Fecha: 2026-11-14. Estado: elección explícita del usuario: «Prefiero que iniciemos con Caelan».

Caelan será el protagonista de la apertura, sustituyendo la propuesta de empezar con Ícaro. Mantener su identidad del material original: doce años, curiosidad, optimismo y conexión singular con la montaña; desconoce el origen completo de su nacimiento y su poder. No atribuirle conocimiento del responsable del pulso ni revelar todo su pasado al comenzar.

D16 se mantiene: protagonistas seleccionables durante el juego. Aún debe concretarse cuándo quedan disponibles Thaleon e Ícaro, la primera misión y las circunstancias de llegada al refugio. Esta decisión es narrativa; no cambia todavía el personaje del ejecutable 0.4.

## D20 — Caelan vive en el pueblo y desobedece por curiosidad

Fecha: 2026-11-14. Aporte narrativo del usuario incorporado al borrador: «Podría ser que Caelan ya vivía en ese pueblo de antes, sus cuidadores le advierten que no se acerque, pero él desobedece por pura curiosidad».

Caelan es habitante previo del pueblo/refugio, no un recién llegado. Sus cuidadores le advierten que evite la zona peligrosa y él desobedece por curiosidad. Se conserva la familia que lo cría según su biografía original; no se identifica a los cuidadores como sus padres biológicos. Su inicio ya no depende de aceptar un encargo para llegar al lugar del misterio.

Pendientes de concretar: nombres de cuidadores, lugar exacto prohibido, primera señal que atrae su atención y consecuencias del descubrimiento. Los detalles de escena que proponga el asistente se mantienen como borrador, no como hechos aprobados individualmente. Sin cambios de código.

## D21 — fragmento del faro y guardián que reconoce a Caelan

Fecha: 2026-11-14. Estado: combinación elegida explícitamente por el usuario.

Caelan encuentra un fragmento apagado del faro que responde a su presencia y late al acercarse. Tocarlo despierta a su guardián. Durante el encuentro, este parece reconocerlo y comunica una pista incompleta. La combinación abre la posibilidad de regresar con el fragmento y un misterio personal.

No se fija todavía la frase, identidad del guardián, explicación de su reconocimiento ni forma de resolver el encuentro. No convertir la insinuación en conocimiento explícito del pasado de Caelan. La secuencia acordada del prólogo está reunida en PROLOGO-CAELAN.md. Implementación pendiente.


## D22 — combate defensivo y escape del prólogo

Fecha: 2026-11-14. Estado: propuesta aceptada por el usuario.

El encuentro con el guardián es un primer combate defensivo: Caelan intenta protegerse mientras el guardián alterna ataques y palabras entrecortadas. El fragmento acumula energía y provoca una descarga que interrumpe al guardián, permitiendo escapar con el cristal. Introduce lectura de intenciones y defensa.

Pista acordada: «Te llevaron… lejos de aquí…». Identidad del guardián, significado de la frase y origen último de la descarga permanecen como misterio. No se establece que el guardián muera. Pendientes: número de turnos, acciones concretas del tutorial y tratamiento de una derrota/reintento. Siguiente escena por concretar: regreso al pueblo y reacción de los cuidadores.

## D23 — conocimiento limitado de los cuidadores

Fecha: 2026-11-14. Estado: decisión del usuario: «Solo saben que el guardián los dejó a su cuidado».

Los cuidadores únicamente saben que un guardián les confió a Caelan. No conocen su nacimiento, padres biológicos, propósito o explicación de sus poderes. La escena de regreso no debe insinuar que ocultan esos conocimientos ni que comprenden la frase del encuentro. Pueden relacionar el relato con lo que presenciaron al recibirlo, sin dar respuestas que no poseen.

Se habla de un guardián que entregó a Caelan; no se confirma que sea el mismo del fragmento. Pendiente decidir si Caelan ya sabe que fue acogido o si se entera en esta conversación. La reacción detallada de los cuidadores sigue siendo borrador.

## D24 — Caelan descubre su acogida durante el viaje

Fecha: 2026-11-14. Estado: decisión explícita del usuario.

Caelan no sabe que fue acogido. Por ahora, quienes conozcan esa circunstancia en el pueblo no se la cuentan porque quieren protegerlo. La conversación de regreso del prólogo no revela que un guardián lo dejó con sus cuidadores. Se sustituye la recomendación previa de que ya lo supiera y se descarta el diálogo propuesto que lo contaba directamente.

El descubrimiento sucede progresivamente durante el viaje mediante pistas y experiencias. Diferenciar saber que fue acogido de conocer su nacimiento, padres biológicos y conexión con el Necrovórtice. No atribuir a todos los habitantes información sobre su origen: sus cuidadores solo conocen la entrega por un guardián (D23). La frase del primer encuentro puede generar dudas, sin resolverlas ni provocar una confesión inmediata del pueblo.

El silencio se motiva por protección. No implica que sus cuidadores conozcan el secreto completo, formen una conspiración o sean antagonistas. El momento exacto y la secuencia de revelaciones siguen pendientes.

## D25 — estética del Necrovórtice y referencias de interfaz

Fecha: 2026-11-14. Requisito explícito del usuario: mantener la estética del Necrovórtice independientemente del HUD elegido y adaptar las referencias de Pinterest a esa identidad. Se conservaron las tres imágenes como referencias en referencias/interfaz. Lectura y propuesta en DIRECCION-VISUAL.md.

No se aprobó todavía un diseño final de HUD, paleta exacta, iconos o pixel art. La propuesta combina composición compacta/pixelada de la imagen 2 con motivos de energía de la 1 y marcos jerárquicos de la 3. No implica adoptar sus personajes, cráneos, coronas ni temática literal. Sin modificación del ejecutable.


## D26 — muestra visual y tipografía pixelada legible

Fecha: 2026-11-14. El usuario pidió preparar una muestra a partir de D25. Tras verla, indicó que lo único que no le convencía era la fuente y eligió «Pixel art legible».

Muestra independiente en muestras/necrovortice-v1 con exploración y diálogo. Se sustituye la serif clásica por Pixelify Sans en títulos, nombres y números; Atkinson Hyperlegible mantiene legibles los textos largos. Se preservan composición, colores y motivos de la propuesta. Archivos de las fuentes y licencias incluidos localmente. La elección define esta revisión de la muestra; integración en Godot y HUD de combate pendientes. No modifica jugabilidad, versión 0.4 ni guardados.


Aclaración posterior de D26 (2026-11-14): el usuario se refería específicamente al cuerpo del diálogo y pidió probar una fuente similar a Arcane Fable. La muestra ahora ensaya Almendra Regular para ese texto (32 px, interlineado 1,35); Atkinson sigue en descripciones/etiquetas y Pixelify en nombres/títulos/cifras. Esta es una prueba visual pendiente de opinión del usuario, no una elección definitiva de Arcane Fable ni una nueva integración en Godot. Referencias 04/05 conservadas en referencias/interfaz; captura de detalle en muestras/necrovortice-v1/dialogo-almendra-detalle.png.


## D27 — marcos curvos y ornamentación de energía

Fecha: 2026-11-14. El usuario respondió favorablemente a Almendra para el cuerpo del diálogo y pidió tomar más inspiración de la referencia de marcos de oro/turquesa para los cuadros y la HUD general.

Se conserva la fuente del diálogo. La dirección visual suma cintas turquesa, filamentos curvos de oro antiguo, anillos asimétricos y cartelas curvas, adaptados al Necrovórtice. El centro de los paneles debe seguir despejado y la decoración no debe invadir letras, cifras ni botones. Referencia conservada en referencias/interfaz/06-marcos-curvos-energia.png.

Muestra V2 preparada en muestras/necrovortice-v2: exploración/diálogo, estado, objetivo, mochila, accesos y paneles. V1 se conserva para comparar. Marcos dibujados en SVG original editable; acabado definitivo y conversión a interfaz/recursos Godot pendientes de revisión. Esta petición fija la intención de acercarse a la referencia, no una aprobación anticipada del resultado V2. Sin cambios al juego 0.4 ni sus guardados.


## D28 — escenario 2D pixel art e implementación pendiente

Fecha: 2026-11-14. El usuario confirma que el escenario debe continuar siendo 2D con pixel art, como en el desarrollo actual, y pide explícitamente no implementar aún la propuesta visual.

La muestra V2 orienta el aspecto de la HUD y los cuadros de texto. No supone sustituir el mundo jugable por la ilustración de concepto ni cambiar su dirección 2D/pixel art. La incorporación en Godot queda pendiente de una instrucción posterior del usuario. En esta actualización solo se registra la decisión; no se modifican código, recursos del juego, compilaciones ni guardados.


## D29 — muestra de HUD sobre escenario 2D, sin integración

Fecha: 2026-11-16. Petición del usuario: preparar una muestra de la HUD en estilo 2D. Se mantiene D28: no implementar aún en el juego.

Se crea muestras/necrovortice-v3-2d como maqueta separada, con HUD V2 y fondo cenital de pixel art dibujado en Canvas. Escenario/sprite son provisionales; la nueva muestra no confirma un ángulo final ni reemplaza mapas, sprites o recursos del proyecto Godot. Fuentes y marcos de V2 conservados, incluidas las licencias. V1/V2 permanecen disponibles.


## D30 — autorización de HUD nativa en escena de prueba aislada

Fecha: 2026-11-16. Tras limitar el trabajo a la HUD y proponer trasladarla a una escena independiente de Godot, el usuario indicó «Perfecto, implementala».

Se autoriza ese paso: recursos y controles nativos, adaptación de tamaño y pruebas de estados/teclado en un laboratorio separado. La pausa anterior se levanta para esta implementación de HUD. Escenario, lógica, partida principal y guardados continúan fuera del cambio. Se implementó muestras/hud-godot con escena reutilizable y exportaciones independientes. Detalle y validación en AVANCE-HUD-001.md.

La conexión a los datos y pantallas reales de la campaña queda para un paso posterior a revisar esta entrega. La autorización no cambia el canon ni implica aprobación de todos los detalles visuales nuevos.


## D31 — integrar la HUD en el juego con datos y reglas reales

Fecha: 2026-11-16. El usuario autorizó el paso propuesto de conexión, sustitución de interfaz de exploración y prueba de expedición completa. Se implementa en 0.5.0-dev, con respaldo de la base0.4 y guardados antes del cambio.

No se inventan nivel de personaje ni capacidad12: el piloto carece de ambos. La HUD se adapta a especialización, inventario y reglas de uso/retirada reales. Las pantallas de combate/recompensa/resultados/copias siguen activas; el escenario, balance y formato de guardado permanecen. El laboratorio anterior se conserva. Evidencia, límites y rutas actuales en AVANCE-005.md.
