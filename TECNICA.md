# Diseño técnico propuesto

Fecha: 2026-11-09. Existe una implementación Godot 0.2.0-dev. Este documento conserva el diseño técnico general; el alcance realmente implementado y probado figura en AVANCE-002.md y juego/LEEME.md.

## Plataforma y motor

Dirección elegida: Godot con GDScript para un RPG 2D. Versión usada en la muestra: Godot 4.7.2.stable.official.ed1daf0bf. Contemplar navegador y mantener la opción de escritorio. Comprobar una exportación web temprano para descubrir restricciones antes de ampliar contenido.

## T01 — guardado completo, versionado y recuperación

Mantener un modelo explícito de partida separado de las escenas y del dibujo. Usar identificadores estables para regiones, misiones, enemigos especiales, objetos y edificios.

Datos previstos:

- Versión del esquema y fecha de guardado.
- Aventurero: ubicación válida, nivel, experiencia, vida, maná, equipo y talentos.
- Inventario, recursos, ayudantes y asignaciones.
- Edificios, regiones descubiertas, cofres y misiones.
- Jefes derrotados, recompensas reclamadas y consecuencias permanentes.
- Colas de fabricación, expediciones, progreso parcial y momento de liquidación de ingresos.
- Ciclo, desbloqueos y reglas de persistencia del renacimiento.
- Resultado pendiente de victoria o derrota y contexto necesario para recuperarlo con coherencia.

No serializar referencias temporales a nodos o callbacks como sustituto de estado de juego. Los ajustes pueden tener almacenamiento separado.

Flujo propuesto: construir una instantánea válida → escribir archivo temporal → validar → conservar copia anterior → sustituir el principal con el mecanismo adecuado para la plataforma. En web se debe verificar también la persistencia efectiva; no asumir garantías idénticas a escritorio.

Ofrecer exportación/importación de un formato de datos validado y migraciones entre versiones. Si falla una carga, mostrar el problema y permitir recuperación; no borrar la partida silenciosamente.

## T02 — estados y transiciones

Estados explícitos: título/carga, exploración, diálogo, tienda, combate, derrota y victoria/renacimiento pendiente. Definir transiciones permitidas, entrada/salida, guardado y controles de cada estado.

Aplicar recompensas una sola vez mediante un identificador de evento o marca persistente. Una pantalla pendiente puede recuperarse o resolverse con una política documentada, sin perder premios ni repetirlos. Cancelar o ignorar acciones temporizadas de combates terminados.

Al cargar una derrota, recuperar un resultado coherente: regreso al pueblo y penalización aplicada una sola vez, o restaurar la pantalla de derrota con todo su contexto. Elegir una política en F0.

## T03 — simulación del tiempo

Separar movimiento y animación, que dependen de actualizaciones frecuentes, de la economía, que depende del tiempo transcurrido.

Usar el mismo cálculo de producción para intervalos online y offline. Considerar consumos, colas finitas, cambios de capacidad y hitos que alteren tasas. Para estos casos, avanzar por eventos o intervalos relevantes; no multiplicar toda la ausencia por la tasa final sin comprobar sus condiciones.

Mientras la aplicación está activa, medir intervalos con un reloj apropiado. Entre sesiones, usar marcas de tiempo persistentes y reglas para fechas futuras, tiempo negativo y límites de ausencia. Registrar el tiempo ya liquidado para evitar dobles cobros al cargar, cambiar de pestaña o guardar.

La muestra aplica un límite provisional de 8 horas por ausencia y producción segura sin combate automático. Es una regla para probar, no el balance definitivo. El reloj entre sesiones usa tiempo del sistema; aún no hay servicio externo de tiempo ni protección contra manipulación del reloj.

## T04 — definiciones de contenido

Usar recursos personalizados de Godot para estadísticas base, habilidades, objetos, recetas, edificios y misiones. Las definiciones son compartidas y no deben mutarse para almacenar vida actual, inventario o progreso de una partida.

Separar definición de enemigo de instancia de combate; definición de misión de objetivos completados. Esto permite añadir contenido sin duplicar sistemas y ajustar balance sin editar el flujo de las pantallas.

## T05 — escenas reutilizables

Separar escenas de mundo, personaje, PNJ, enemigo, edificio, combate e interfaz. Mantener responsabilidades pequeñas. Comunicar acontecimientos relevantes mediante interfaces o señales claras, evitando dependencias circulares y un único script global que contenga todo.

La estructura exacta de carpetas y servicios se fija al iniciar el proyecto. No introducir capas o administradores sin una necesidad concreta.

## T06 — regiones, mapas y apariciones

Mapas mediante TileMapLayer y tilesets reutilizables. Separar terreno, colisión, decoración y primer plano cuando ayude al trabajo. Cargar por regiones y conservar sus cambios mediante identificadores.

Validar entradas, salidas, puntos de regreso, aparición de enemigos y acceso a objetivos. Evitar enemigos dentro de paredes, cofres inaccesibles o habitantes que bloqueen pasos esenciales. La generación variable de F5 requiere semilla reproducible y comprobación de conectividad.

## T07 — interfaz, entradas y accesibilidad

Usar controles de interfaz adaptables en lugar de posicionar todo el texto como píxeles del mundo. Prever textos largos, escalado, diálogos paginados y distintas proporciones de pantalla. Decidir resolución base y escalado pixel art durante F0/F1.

Configurar acciones de entrada para teclado, ratón, mando y revisión táctil. Evitar que la entrada del mundo actúe al mismo tiempo sobre un menú. Soportar reasignación, foco de navegación y señales adicionales al color.

## T08 — herramientas de desarrollo y equilibrio

Escenario o panel exclusivo de desarrollo para cargar regiones, crear recursos, iniciar combates, avanzar tiempo y preparar guardados. Mantenerlo fuera del flujo normal del producto.

Definir curvas de costes, recompensas y duración fuera de la interfaz. Registrar cuánto tarda el jugador en obtener equipo, reparar edificios y recuperar su progreso tras renacer. Probar configuraciones y detectar estrategias dominantes.

## T09 — comprobaciones significativas

Pruebas automatizables prioritarias:

- Guardar/cargar conserva la información y permite migrar el esquema.
- Repetir una carga o reanudar no duplica monedas ni recompensas.
- Cargar tras morir o vencer al jefe produce el resultado acordado.
- Producir un intervalo continuo o varios consecutivos da resultados equivalentes, salvo redondeo especificado.
- Consumos, límites de almacén y colas terminan correctamente.
- Renacer conserva y reinicia exactamente los campos anunciados.
- Validación de datos detecta referencias y requisitos inválidos.

Pruebas manuales necesarias: navegación, lectura, sonido, accesibilidad, controles, exportaciones, claridad del tutorial y diversión. No marcar estas últimas como comprobadas por pasar una prueba automatizada.

## T10 — plataforma y rendimiento

Medir carga, memoria, fluidez y consumo en los dispositivos objetivo antes de optimizar. Comprobar pausa/reanudación en web y no depender de ejecutar lógica en una pestaña oculta.

Probar guardado real, exportación/importación, audio después de interacción, tamaños de pantalla y navegación por controles. Registrar navegador, sistema y versión comprobados. No añadir backend ni cuentas sin una necesidad acordada.

## T11 — números grandes

Definir rangos esperados y redondeo. Mostrar cantidades abreviadas sin perder claridad sobre costes y requisitos. Si la progresión requiere superar la precisión numérica elegida, introducir una representación adecuada antes de alcanzarla. Evitar producción infinita, valores no numéricos y saldo negativo por errores de comparación.

## T12 — mantenimiento y entregas

Control de versiones, cambios pequeños, créditos y licencias de recursos. Mantener este paquete sincronizado con cada hito. Registrar versión/commit y evidencia de prueba al entregar; añadir notas de versión cuando exista una aplicación exportable.

## Hallazgos del prototipo HTML

1. **Derrota y recarga, reproducido:** el guardado puede conservar 0 PV mientras el resultado de derrota no persiste. La recarga coloca al personaje en el pueblo sin resolver correctamente ese resultado. Referencias originales: líneas 112–120, 210–225.
2. **Victoria del dragón y recarga, reproducido:** se conserva el contador de eliminaciones, pero no la pantalla de victoria pendiente ni el estado del dragón. Tras recargar, el dragón está vivo y no se han recibido las gemas del renacimiento. Referencias: líneas 112–126, 216–226 y 230–235.
3. **Tiempo de ingresos, observado en código:** se concede producción offline al cargar solo si la ausencia supera 30 segundos. El bucle limita dt a 0,05 y compensa pausas superiores a 5 segundos; pausas intermedias pueden remunerarse por debajo del tiempo real. Referencias: líneas 117–118, 253–254 y 413–414.
4. **No confirmado como fallo general:** se sospechó desbordamiento de textos durante la revisión, pero los ejemplos examinados de diálogo, tienda y victoria ordinaria cabían. Revisar textos extremos en el diseño de interfaz; no registrarlo como defecto reproducido.

Las reproducciones de derrota y victoria prepararon estados en una copia servida localmente. Se revisó la apariencia de varias pantallas y no se observaron errores de ejecución del juego en el recorrido comprobado; hubo un 404 de favicon del servidor de prueba. No se completó una partida normal, no se midió rendimiento exhaustivamente ni se comprobó el control en un móvil real. El original no fue editado.

## Fuentes técnicas

- Guardado: https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
- Recursos: https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- Mapas: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html
- Exportación web y limitaciones: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html

Las recomendaciones de arquitectura y pruebas son propuestas del proyecto. Las fuentes explican capacidades y limitaciones del motor; no garantizan por sí mismas la implementación.

## Implementación 0.1 y trabajo pendiente

Guardado JSON con esquema 1, respaldo y validación; servicios separados de combate, economía y persistencia; definiciones de enemigos en recursos; TileMapLayer generado a partir de datos de región; escenas de interfaz construidas por código. Recetas, misiones y edificios aún usan reglas pequeñas en game.gd, pendientes de generalizar al ampliar contenido. No se ha implementado migración desde el HTML ni desde esquemas anteriores; versiones desconocidas se rechazan conservando la partida existente. No hay renacimiento que probar todavía. Ver informe de avance para evidencia y límites.

## Actualización técnica 0.2

- Esquema 2 con estilo activo y equipo/talento por estilo. Lectura de esquema 1 con migración y copia original separada antes del primer guardado actualizado.
- Definiciones de equipo en recursos; pasivas, talentos y cálculo de estadísticas separados del flujo de interfaz.
- Combate guarda duración de quemadura, contador de críticos y contexto de entrenamiento, incluidos suministros que deben restaurarse.
- La importación no cambia la sesión si falla la escritura de la copia validada. La validación rechaza equipo desconocido, coordenadas fraccionadas o posiciones dentro de obstáculos en los casos probados.
- Lectura asíncrona del portapapeles web mediante JavaScriptBridge y descarga JSON. Referencia técnica consultada: https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html.
- Tests aislados con `-- --test-mode`; el autoload no carga ni escribe la ranura real. Tres suites, 98 comprobaciones. El esquema se mantiene compatible con las partidas 0.1; no existe migración del HTML.
