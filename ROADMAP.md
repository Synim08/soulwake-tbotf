# Roadmap de Aventura del Valle

Actualizado: 9 de noviembre de 2026. Fase activa: **F2, en curso**. F1 cerrada para escritorio/navegador horizontal; ver [AVANCE-002.md](AVANCE-002.md). F0 completada en la entrega 0.1.0-dev; ver [AVANCE-001.md](AVANCE-001.md).

## Objetivo

Crear un RPG incremental 2D donde explorar y combatir permita recuperar el valle, mientras sus habitantes producen recursos y preparan futuras aventuras. Godot con GDScript es la dirección elegida. La publicación web sigue contemplada; escritorio es una posibilidad adicional.

## Resumen

| Fase | Resultado | Estado | Dependencia |
|---|---|---|---|
| F0 | Alcance mínimo y base de proyecto | Hecho | Ninguna |
| F1 | Primera muestra jugable completa y persistente | Hecho | F0 |
| F2 | Combate, equipo y exploración con más decisiones | En curso | F1 |
| F3 | Economía conectada y automatización gradual | Pendiente | F1; integrar contenido de F2 |
| F4 | Campaña regional y renacimiento significativo | Pendiente | F2 + F3 |
| F5 | Desafíos, variedad y contenido avanzado | Pendiente | F4 |
| F6 | Preparación de publicación | Pendiente | Versión candidata de las fases anteriores |

F1 es el primer hito prioritario. El resto recoge toda la dirección aprobada sin convertirla en una obligación de incluirlo todo en la primera versión.

## F0 — preparar el proyecto y las reglas mínimas

- Crear el proyecto Godot con GDScript y control de versiones; registrar la versión concreta del motor.
- Definir el esquema de escenas, datos y estado persistente descrito en TECNICA.md.
- Concretar para F1: movimiento, acciones de combate, recursos iniciales, derrota y duración deseada de una sesión.
- Elegir recursos visuales y sonoros con procedencia y licencia documentadas. Usar elementos provisionales cuando sea necesario.
- Definir el objetivo de plataforma inicial y comprobar una exportación web mínima.
- Preparar un escenario de desarrollo para probar estados y acelerar el tiempo.

Aceptación: proyecto que abre y ejecuta sin errores bloqueantes, exportación mínima comprobada y reglas de F1 documentadas. Crear archivos vacíos no completa la fase.

Tareas relacionadas: T04–T08, T10, T12; decisiones D01–D05.

## F1 — primera muestra jugable completa

Alcance propuesto: un pueblo con herrería reparable, un bosque, una mina, tres tipos de enemigos, un jefe y dos ayudantes. Son objetivos iniciales, no contenido ya creado.

- Movimiento, colisiones, interacción y transición entre las tres áreas.
- Combate por turnos, victoria, derrota y regreso seguro al pueblo.
- Un enemigo que anuncie una acción y un jefe con una mecánica reconocible.
- Una cadena de misiones: recuperar la mina, asignar producción, reparar la herrería y fabricar una mejora.
- Dos ayudantes con funciones distintas; producir material y fabricar o transformar un recurso. Sus roles exactos se cierran en F0.
- Producción al jugar y al regresar; resumen offline y reglas visibles.
- Guardado completo, copia recuperable y exportación/importación de partida.
- Interfaz mínima de misión, equipo, producción y opciones; controles básicos de teclado y ratón, con revisión del recorrido táctil.

Aceptación:

1. Completar el ciclo explorar → recuperar mina → asignar ayudante → fabricar equipo → derrotar jefe → mejorar pueblo.
2. Cerrar y recuperar la partida en exploración, derrota y victoria pendiente sin perder ni duplicar recompensas.
3. Ausentarse y recibir el resultado esperado según el tiempo y los límites documentados.
4. Probar la versión exportada en un navegador; registrar por separado cualquier prueba de escritorio o móvil.
5. Una persona que no conozca el código puede identificar el objetivo y la siguiente acción. Registrar la prueba cuando se realice.

Validación humana recibida el 2026-11-09: el usuario completó el recorrido hasta vencer al guardián y restaurar el faro y declaró que funciona a la perfección. El ciclo principal queda validado. Las comprobaciones de persistencia e interfaz posteriores se completaron con el alcance registrado en AVANCE-002.md; F1 queda cerrada para el objetivo horizontal de escritorio/navegador.

Tareas relacionadas: J01–J05, J09–J10, J14; T01–T10.

## F2 — profundidad del RPG

Avance 0.2: implementados tres estilos, dos talentos alternativos por estilo, tres armas de herrería, dos reliquias, configuración recordada y entrenamiento repetible sin premios. F2 continúa abierta por comportamientos enemigos, exploración y las mejoras de interfaz/controles restantes. Evidencia en AVANCE-002.md.

- Añadir estilos de guerrero defensivo, mago de estados y explorador de críticos; permitir experimentar y redistribuir talentos en el pueblo.
- Crear una selección pequeña de equipo con efectos sobre habilidades y comparación clara.
- Ampliar intenciones enemigas, estados, defensa e interrupciones. Evitar que una única acción resuelva todos los combates.
- Añadir secretos, rutas alternativas, atajos y viaje rápido entre destinos descubiertos.
- Incluir diario de misiones, consulta de estadísticas y conjuntos de equipo.
- Ampliar accesibilidad, mando y controles configurables.

Aceptación: los tres estilos ofrecen decisiones distintas y funcionan en encuentros de prueba; los efectos del equipo son comprensibles; los atajos no bloquean misiones. Documentar resultados de pruebas de juego, no solo de código.

Tareas relacionadas: J04–J07, J10, J12; T07–T09.

## F3 — economía y automatización

- Desarrollar la cadena materiales → fabricación → preparación de aventura, con especialización y reasignación de ayudantes.
- Desbloquear nuevos trabajos al recuperar lugares y habitantes.
- Añadir colas de fabricación, límites configurables y compras por lotes cuando tengan utilidad.
- Delegar actividades ya dominadas: producción y patrullas de zonas despejadas.
- Incorporar expediciones offline seguras. Evaluar el combate offline solo después de definir consumo, retirada y derrota.
- Dar visibilidad a producción, consumo y razones de una detención.

Aceptación: las tareas delegadas respetan recursos, capacidad y tiempo; cerrar y abrir no duplica resultados; el jugador puede cambiar prioridades sin quedar atrapado; la economía sostiene la aventura sin volverla irrelevante.

Tareas relacionadas: J02–J03, J08–J09, J14; T01, T03, T08–T09.

## F4 — campaña y renacimiento

- Crear regiones con identidad visual, recursos, habitantes y problemas propios.
- Añadir cadenas narrativas que transformen el mapa y desbloqueen sistemas gradualmente.
- Diseñar el renacimiento voluntario: qué vuelve al inicio, qué persiste y qué cambia de forma importante.
- Mostrar antes de confirmar el reinicio una comparación de pérdidas, conservación y recompensas.
- Conservar como objetivo de diseño el pueblo, los descubrimientos y las automatizaciones básicas. Cerrar las reglas exactas antes de implementarlas.
- Asegurar que las repeticiones no contradigan las consecuencias de la historia; considerar variantes o ecos de jefes como posibilidad.

Aceptación: reiniciar abre una opción jugable nueva, conserva lo anunciado y acelera la recuperación de tareas dominadas; una partida anterior migra sin pérdida; la campaña tiene objetivos y un cierre reconocible.

Tareas relacionadas: J01, J10–J11, J14; T01–T02, T09.

## F5 — variedad y contenido avanzado

- Desafíos opcionales: sin pociones, daño directo limitado o equipo restringido.
- Recompensas alternativas y estrategias nuevas; no exigir todos los desafíos para acabar la historia.
- Evaluar mazmorras variables combinando módulos y reglas de conectividad.
- Ampliar equipo, enemigos, secretos y variantes de expedición según las pruebas de las fases anteriores.

Aceptación: cada añadido aporta una decisión, descubrimiento o estrategia distinguible; las mazmorras generadas tienen recorridos válidos y recompensas accesibles; los desafíos son comprensibles y superables con su equipo previsto.

Tareas relacionadas: J05, J07, J12–J13; T06, T08–T09.

## F6 — publicación

- Comprobar exportación, almacenamiento, suspensión y reanudación en los navegadores elegidos.
- Completar revisión de controles, legibilidad, textos, audio, accesibilidad y rendimiento.
- Probar recuperación de guardados y migraciones entre versiones.
- Revisar tutorial, ritmo, bloqueo de progreso, balance y final de campaña.
- Documentar créditos, licencias, instalación, controles, limitaciones y notas de versión.
- Preparar una versión candidata concreta. Publicar se realiza cuando forme parte del alcance autorizado de esa entrega.

Aceptación: lista de comprobaciones completada con evidencia, limitaciones conocidas registradas y paquete reproducible. Una exportación correcta no sustituye la prueba de juego.

Tareas relacionadas: T01–T12 y revisión de J01–J14.

## Registro de entregas

2026-11-09 — 0.1.0-dev: primera muestra Godot, exportación web y Windows, 42 comprobaciones de lógica aprobadas y recorrido web parcial con persistencia de victoria comprobada. F0 completada; Recorrido completo confirmado por el usuario; F1 pendiente de comprobaciones adicionales de interfaz, importación/exportación y persistencia. Ver AVANCE-001.md.

2026-11-09 — 0.2.0-dev: cierre de F1; primera selección de estilos, talentos y equipo de F2, práctica sin recompensas y migración de partidas. Tres suites suman 98 comprobaciones aprobadas; interfaz y combate comprobados parcialmente en Chromium.
