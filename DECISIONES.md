# Decisiones y registro de cambios

Última actualización: 2026-11-09.

## Decisiones aceptadas

### D01 — ampliar el juego con Godot y GDScript

Fecha: 2026-11-09. Estado: aceptada como dirección.

El usuario quiere un juego más grande y aceptó la recomendación de Godot. El objetivo es facilitar mapas, contenido, interfaces y reutilización. La elección no corrige por sí sola los errores de lógica del prototipo ni acredita mejoras de rendimiento. No se iniciará una reescritura en C como parte de esta dirección.

### D02 — conservar la posibilidad de navegador

Fecha: 2026-11-09. Estado: dirección técnica.

El navegador es una opción válida para el usuario. Se contempla exportación web con GDScript y se mantiene escritorio como posibilidad. No se ha acordado todavía la plataforma de la primera publicación ni una lista de dispositivos garantizados.

### D03 — exploración, reconstrucción y ayudantes conectados

Fecha: 2026-11-09. Estado: dirección aceptada.

Adoptar las 14 propuestas de DISENO.md y las mejoras técnicas como visión del proyecto. La aventura recupera lugares y habitantes; el pueblo produce recursos para nuevas aventuras. Introducirlas por fases y comprobar su utilidad antes de ampliar su escala.

### D04 — primera muestra pequeña y completa

Fecha: 2026-11-09. Estado: propuesta de alcance dentro de la dirección aceptada.

Objetivo inicial: pueblo con herrería reparable, bosque, mina, tres enemigos, jefe y dos ayudantes. Validar el ciclo completo y el guardado antes de construir una campaña extensa. Las cantidades son una referencia inicial que se puede ajustar con motivo documentado.

### D05 — documentación mantenible y evidencia

Fecha: 2026-11-09. Estado: solicitada explícitamente por el usuario.

Mantener roadmap, diseño, técnica, backlog, decisiones e investigación para conservar todas las ideas y actualizar el trabajo. Distinguir aprobado, propuesto, implementado y comprobado. No marcar el motor, las plataformas ni las mecánicas como implementados por aparecer en un plan.

## Reglas todavía por concretar

El usuario aprobó el conjunto de ideas. La muestra usa Godot 4.7.2 y reglas provisionales de estadísticas, costes y límite offline documentadas en juego/LEEME.md. Siguen pendientes el balance definitivo, las reglas completas de renacimiento, el número final de regiones y la fecha de publicación. Consultar O01–O12 y sus resoluciones en BACKLOG.md.

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
