# Investigación y referencias de diseño

Consulta: 9 de noviembre de 2026. Esta investigación combina descripciones oficiales, documentación técnica y una muestra de discusiones de jugadores. No es una encuesta representativa ni demuestra que una mecánica vaya a funcionar en este proyecto.

Las propuestas de DISENO.md son adaptaciones para Aventura del Valle. No deben atribuirse literalmente a los juegos o a todos los usuarios de una comunidad.

## Juegos de referencia

### R01 — Melvor Idle

Fuente oficial: https://store.steampowered.com/app/1267910/Melvor_Idle/

La descripción presenta oficios con interacciones entre sí, combate, inventario y progreso offline. La relación entre habilidades permite que trabajar en una contribuya a otras.

Aplicación propuesta: minar produce materiales, fabricar mejora equipo y explorar abre fuentes de producción. Aprender de estas conexiones sin reproducir su número de habilidades ni su escala. Relación: J02, J03, J07 y J09.

### R02 — Loop Hero

Fuente oficial: https://store.steampowered.com/app/1282730/Loop_Hero/

La descripción relaciona expediciones, equipo, decisiones sobre el recorrido y recursos para mejorar un campamento que refuerza aventuras posteriores.

Aplicación propuesta: recuperar recursos y habitantes durante la aventura para reconstruir un pueblo persistente. No se propone trasladar su sistema de cartas ni su movimiento automático al combate por turnos actual. Relación: J01, J03, J07 y J12.

### R03 — Magic Research

Fuente oficial: https://store.steampowered.com/app/2311680/Magic_Research/

La descripción destaca investigación, gestión de ayudantes, nuevas funciones ocultas, historias con efectos permanentes y reinicios con bonificaciones de progreso.

Aplicación propuesta: descubrimientos y cadenas de misiones desbloquean herramientas; el renacimiento introduce cambios relevantes. Evitar añadir muchos subsistemas inconexos. Relación: J02, J10 y J11.

## Opiniones de jugadores

### R04 — decisiones y progreso significativo

Discusión: https://www.reddit.com/r/incremental_games/comments/1xcccjk/what_makes_you_stick_with_an_incremental_game_and/

Entre los comentarios consultados aparecen preferencias por decisiones con consecuencias, progreso offline y reinicios que cambien las posibilidades. También aparecen rechazos a bloqueos largos y a demasiados sistemas que exijan microgestión.

Aplicación propuesta: funciones distintas de ayudantes, desbloqueos relevantes, objetivos visibles y pocas tareas manuales repetidas. Relación: J02, J08, J09, J11 y J14.

### R05 — repetición del inicio y automatización

Discusión: https://www.reddit.com/r/incremental_games/comments/1jmq7ra/what_do_you_prefer_on_a_incremental_game/

Algunos participantes expresan rechazo a reiniciar con poca mejora o perder automatizaciones, y valoran elecciones, sistemas que se conectan y funciones que se descubren gradualmente. No hay una preferencia universal sobre cuánto juego activo debe existir.

Aplicación propuesta: conservar automatizaciones básicas y explicar el renacimiento; hacer útil experimentar con configuraciones y talentos. Relación: J06, J08 y J11.

### R06 — objetivos frente a crecimiento numérico y minijuegos

Discusión: https://www.reddit.com/r/incremental_games/comments/1my1ttf/what_actually_makes_idle_games_fun_after_week_2/

Varios comentarios valoran metas comprensibles, descubrimientos y configuraciones que resuelvan obstáculos. Algunos critican añadir minijuegos desconectados o reinicios cuyo objetivo sea repetir el mismo reinicio más rápido. Existen opiniones diferentes dentro del hilo.

Aplicación propuesta: reconstruir lugares reconocibles, conectar recursos y combate, diseñar desafíos opcionales y añadir contenido que cambie decisiones. Relación: J01, J03, J06, J10, J11 y J13.

## Fuentes técnicas primarias

### R07 — recursos de Godot

https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html

Documenta recursos como contenedores de datos y su uso compartido. Motiva separar definiciones de contenido de estado mutable de una partida. Relación: T04.

### R08 — guardado de partidas

https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

Documenta identificación y persistencia de datos de objetos. La propuesta de versionado, copias, validación y recuperación de este proyecto amplía esa base; no es una garantía automática del motor. Relación: T01 y T02.

### R09 — mapas por capas

https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html

Documenta edición mediante TileMapLayer, reutilización de tilesets y funciones de colisión. Relación: T06.

### R10 — exportación web

https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html

La documentación consultada indica requisitos de WebAssembly/WebGL 2.0, limitaciones de exportación C# en Godot 4, persistencia mediante el entorno del navegador y pausa de procesamiento de pestañas inactivas. Estas condiciones pueden cambiar; revisar la documentación correspondiente a la versión elegida al preparar una entrega.

Aplicación propuesta: GDScript, exportación temprana, cálculo por tiempo transcurrido y exportación/importación de guardados. Relación: T01, T03 y T10.

## Límites de la investigación

- No se han jugado exhaustivamente los títulos de referencia durante esta tarea.
- Las mecánicas atribuidas a juegos proceden de sus descripciones oficiales consultadas.
- Las opiniones reflejan comentarios concretos de varios hilos y no porcentajes o consensos de todos los jugadores.
- No se emplean cifras de retención o de rentabilidad como evidencia de diseño.
- Se intentó abrir la página de progreso offline de la wiki de Melvor Idle, pero devolvió 403. No se usa para afirmar límites, porcentajes o simulación interna de ese juego.
- La aceptación del diseño debe comprobarse con un prototipo propio y pruebas de juego.
