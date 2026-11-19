# Backlog y cobertura de ideas

Actualizado: 2026-11-13. Dirección vigente: roguelite por turnos (D09). F0 y F1 describen la base y prototipo incremental histórico; F2 contiene el piloto roguelite 0.3 implementado y sigue en validación de exportaciones/interfaz y pruebas humanas. Evidencia actual: AVANCE-003.md. Mantener identificadores al cambiar título, fase o prioridad.

Prioridad: P0 = base imprescindible; P1 = siguiente profundidad; P2 = ampliación posterior. Fase inicial significa primer alcance parcial, no finalización de toda la idea.

## Jugabilidad

| ID | Idea | Prioridad | Fases | Criterio de aceptación resumido |
|---|---|---|---|---|
| J01 | Pueblo persistente y reconstrucción | P0 | F1, F4 | Reconstruir habilita preparación, servicios o destinos entre intentos. |
| J02 | Habitantes, servicios y ayudantes | P1 | F1, F4 | Personajes desbloquean opciones útiles sin depender de producción idle. |
| J03 | Expedición que avanza la campaña | P0 | F2–F4 | Descubrimientos y rescates persisten y abren nuevos intentos/contenido. |
| J04 | Combate por turnos con intenciones y respuestas | P0 | F1–F3 | Señales dan oportunidad de responder con decisiones tácticas viables. |
| J05 | Jefes con mecánicas propias | P0 | F1, F3–F5 | Jefe exige leer patrón, preparar recursos y tomar decisiones distintas. |
| J06 | Estilos, talentos y configuraciones | P1 | F1, F5 | Alternativas jugables y sinergias; balance aplazado tras prototipo de ciclo. |
| J07 | Equipo y reliquias que crean builds | P0 | F2–F5 | Recompensas temporales alteran estrategia y crean combinaciones legibles. |
| J08 | Preparación y desbloqueos del pueblo | P0 | F3–F4 | Mejoras persistentes amplían opciones y no acumulan poder sin límite. |
| J09 | Resultado y botín al regresar | P0 | F2–F3 | Victoria, retirada y caída resuelven pérdidas/recompensas una vez, con claridad. |
| J10 | Historia y misiones entre intentos | P0 | F3–F4 | Hitos reconocen intentos y cambian campaña persistentemente. |
| J11 | Reinicio de expedición y metaprogresión | P0 | F2–F4 | El intento termina sin borrar campaña; conservación y pérdida se explican. |
| J12 | Rutas, eventos, secretos y destinos | P0 | F2–F5 | Cada ruta ofrece coste/riesgo/recompensa y se puede completar sin bloqueo. |
| J13 | Retos y modificadores opcionales | P2 | F5 | Cambian estrategia, tienen reglas claras y no bloquean campaña principal. |
| J14 | Ritmo de intentos y sesiones cortas | P0 | F2–F6 | La expedición puede avanzar por tramos, guardar/reanudar y cerrar con logro. |
| J15 | Variación reproducible de expediciones | P1 | F2–F5 | Rutas/encuentros/recompensas cambian por semilla y siempre son válidos. |
| J16 | Decidir cuánto arriesgar y cuándo retirarse | P0 | F2–F3 | Retirada ofrece elección comprensible entre asegurar botín y continuar. |
| J17 | Sinergias de reliquias, estados y equipo | P1 | F2–F5 | Combinaciones producen efectos visibles sin estrategia única dominante. |
| J18 | Economía offline secundaria u omitida | P2 | F4–F5 | Si existe, es optativa/acotada y no reemplaza jugar expediciones. |

## Técnica

| ID | Trabajo | Prioridad | Fases | Criterio de aceptación resumido |
|---|---|---|---|---|
| T01 | Guardado de campaña y expedición, versiones y respaldo | P0 | F1–F6 | Recuperar ambos estados, migrar y resolver resultados sin duplicación. |
| T02 | Estados y transiciones explícitas | P0 | F1–F3 | Inicio, expedición, combate, caída/retirada/victoria y regreso coherentes. |
| T03 | Simulación de economía entre sesiones | P2 | F4–F5 | Solo si se conserva actividad idle; no simular combate offline inicialmente. |
| T04 | Definiciones de contenido mediante recursos | P0 | F0–F2 | Añadir una variante por datos sin duplicar el sistema; no mutar estado compartido. |
| T05 | Escenas y responsabilidades reutilizables | P0 | F0–F2 | Las variantes reutilizan comportamiento sin dependencias circulares. |
| T06 | Rutas, mapas y generación reproducible | P0 | F1–F5 | Nodos conectados, salidas/recompensas accesibles y semilla reproducible. |
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
| O08 | Capas y resultados del piloto implementados y comprobados en lógica/persistencia (§7) | Verificar E4/E5 |
| O09 | Implementado para el piloto: grafo fijo de dos cruces y escenarios recorribles (§3) | Revisión exportada de E6 |
| O10 | Objetivo 15–25 minutos, siete lugares, descanso único; sin validar jugando | Probar E6 |
| O11 | Faro como prólogo, primera región o historia rediseñada | Antes de conectar campaña F3–F4 |
| O12 | Piloto en ranura independiente, sin conversión automática de 0.2 (§10) | Verificar E1/E5 antes de entregar |
| O13 | Piloto usa madera/mineral y dos proyectos de opciones, sin metamoneda adicional (§8) | Verificar E4; ampliar campaña después |
| O14 | Reanudar estado exacto y liquidar una vez implementado; casos de lógica/disco comprobados | Verificar E5 |

Estas cuestiones no requieren detener la documentación ni decidir todo de una vez. Se resuelven en la fase en que afecten al trabajo, registrando la decisión.

## Fuera del primer hito

Combate offline, generación procedural completa, nube/cuentas, multijugador, monetización y eventos periódicos. No forman parte del primer prototipo; varios no han sido acordados como funciones del juego.

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

## Prioridad acordada después de probar 0.2 (histórica)

El usuario declara que la versión está perfecta y pide dejar los arreglos de clases para más adelante. Se aplaza el ajuste de balance y reglas de J06; no se descarta la función existente. Siguiente bloque de F2: patrones enemigos diferenciados (J04/J05) y exploración con secretos y atajos (J12). Más adelante, comparación de equipo e interfaz. Esta priorización no equivale a implementación ni a validación exhaustiva de todas las clases.

## Prioridad vigente tras D09

El plan anterior de ampliar primero enemigos y secretos queda reemplazado. F2 empieza por el modelo de capas de progreso, reglas de caída/retirada y una expedición corta con rutas, recompensas y jefe. Se reutiliza provisionalmente el combate y los estilos de 0.2; balance fino de clases sigue aplazado. No borrar el guardado anterior: O12 requiere política antes de cambiar compatibilidad.

## Acuerdos y nuevas tareas — 2026-11-13

- J06: base futura Guerrero/Asesino/Mago, con especializaciones desbloqueadas mediante el pueblo; adaptar Explorador. Balance fino aplazado.
- J07/J17: catálogo común y catálogo de especialización; recompensas principales compatibles y sinergias dentro de cada especialización.
- J09/J11/J16 y O08: caída pierde todos los materiales transportados; retirada desde lugar despejado conserva materiales; victoria añade premio/hito de jefe. Precisar rescates, nuevos hitos y huida durante combate.
- J12/O09: formato acordado, mapa general de rutas más pequeños escenarios explorables.
- J15/T06: procedural por módulos queda para ampliación futura, con tres pasos: contenido variable, módulos conectados y reglas por bioma. Semilla reproducible y recorridos válidos.
- O10: 15–25 minutos y seis a ocho lugares son objetivos de prototipo aún sin validar.
- Estado histórico de diseño D10; la tabla vigente X01–X06 registra la implementación 0.3 y las comprobaciones pendientes.

## Implementación del Bosque del Sendero — D11

Especificación: [EXPEDICION-001.md](EXPEDICION-001.md). E1–E5 implementados en 0.3 con comprobaciones automáticas; E6 parcial. Evidencia y límites en [AVANCE-003.md](AVANCE-003.md). No equiparar código/pruebas de lógica con aceptación humana del ciclo.

| ID | Paso | Cobertura | Estado / aceptación |
|---|---|---|---|
| X01 | E1: campaña piloto, preparación y tres especializaciones básicas | J06, T01/T02 | Implementado; estado inicial, tres identidades y ranura independiente comprobados en lógica/store |
| X02 | E2: escenarios, rutas, eventos y mochila | J12/J14/J16, T06/T07 | Implementado; cuatro recorridos comprobados en lógica; revisión visual exportada en curso |
| X03 | E3: patrones, mejoras y armas compatibles | J04/J05/J07/J17, T04 | Implementado; patrones/ofertas compatibles y serialización comprobados; balance humano pendiente |
| X04 | E4: resultados, Mara y dos edificios | J01/J03/J08–J11, T02 | Implementado; pérdidas/deposito y costes comprobados en lógica; recorrido por interfaz en revisión |
| X05 | E5: persistencia y copias del piloto | T01/T09 | Implementado; lectura/escritura, respaldo, rechazo y estados comprobados; copias por interfaz en revisión |
| X06 | E6: exportación y prueba de juego | J14, T07/T09/T10/T12 | Parcial; pueblo/preparación vistos en Chromium; recorrido, exportaciones finales y prueba humana en curso |

El siguiente bloque es cerrar X06 y registrar lo comprobado en AVANCE-003.md. La generación procedural, las subclases adicionales y el balance fino permanecen fuera de esta entrega. Las comprobaciones automáticas actuales suman 1842: 167 del motor de expedición, 1577 de persistencia/validación y 98 de regresión histórica; no son 1842 pruebas de interfaz ni partidas humanas.

## Cierre técnico y revisión web de 0.3

X06: exportaciones listas, recorrido web natural de Guardián completado, reanudación/copia y resultados de caída/retirada comprobados con el alcance de AVANCE-003.md. Arranque nativo headless aislado sin errores. Sigue parcial por evaluación humana de claridad/ritmo/dificultad y recorrido visual nativo completo. X01–X05 implementados; no se atribuye a las pruebas automáticas la validación de diversión o soporte móvil.

## Validación humana y propuesta de continuación

El usuario confirma funcionamiento general de 0.3. X06 incorpora esa validación funcional; duración, balance, plataforma y cobertura exacta de rutas no especificados.

| ID | Trabajo | Estado |
|---|---|---|
| Q01 | Investigar armas tácticas que no producen cambios perceptibles según el usuario; comprobar efecto y presentación | Reportado, no reproducido; aplazado por preferencia explícita |
| X07 | Variar encuentros y eventos en los escenarios fijos del Bosque del Sendero | Propuesto para la siguiente entrega; no implementado |
| X08 | Añadir secretos y objetivos del pueblo que incentiven volver a salir por rutas distintas | Propuesto; concretar catálogo y recompensas |

No ampliar todavía la generación geométrica ni hacer una pasada de balance fino de clases. X07/X08 son una propuesta de próximo alcance, no nuevas funciones ya autorizadas individualmente.

## Entrega 0.4 — 2026-11-14

X07 implementado: cuatro arquetipos con dos patrones y un evento de campamento elegido entre mercader, altar y viajero; selección persistente por salida. Pruebas y límites en AVANCE-004.md. X08 (secretos/encargos) sigue propuesto y pendiente. Q01 continúa aplazado por el usuario. Siguiente paso: probar variedad y costes de 0.4 antes de ampliar el catálogo.

## Integración narrativa D15

- X09: revisión de Project Ascension y propuesta de unificación documentadas en INTEGRACION-ASCENSION.md. 14 Word, 8 PDF, 13 imágenes externas y seis imágenes incrustadas revisadas; originales conservados.
- X10: preparar biblia narrativa inicial y resolver variantes de Ícaro, nombres de su daga, parentesco de Yrsa y rol de Caelan. Pendiente.
- X11: diseñar primera misión integrada de facción, secreto y regreso; candidato «El registro perdido de Chaan». Propuesto, sin implementación.
- X08 (encargos/secretos) se desarrollará con la identidad de Ascendant Odyssey. El usuario aprobó la unificación general, no los detalles nuevos de cada misión o subclase. Q01 continúa aplazado.


D16 resuelve la elección del avatar: protagonistas seleccionables, uno por expedición. X10 debe concretar ahora el encuentro del grupo, objetivo común, historias y progresión; la selección todavía no está implementada.

D17 fija la premisa de X10: encuentro en el refugio, camino interrumpido, senderos/faro/santuario como primer objetivo común. Siguiente decisión narrativa: causa del bloqueo y del apagado del faro. Llegadas individuales e implementación siguen pendientes.

D18 resuelve el incidente inicial de X10: pulso anómalo, guardianes alterados y camino/faro afectados. Origen natural o provocado aún desconocido. Pendiente concretar apertura y presentación jugable del grupo.

D19 resuelve la apertura de X10: se comienza con Caelan. Pendientes: primera misión, llegada al refugio y momento en que se habilitan Thaleon e Ícaro. Se conserva la selección de protagonistas de D16 para el desarrollo posterior.

D20 actualiza X10: Caelan vive previamente en el pueblo y desobedece la advertencia de sus cuidadores por curiosidad. Reemplaza el encargo inicial como detonante propuesto. Concretar zona prohibida, señal, primer descubrimiento y regreso; sin implementación todavía.

D21 concreta el descubrimiento del prólogo de X10: fragmento del faro sensible a Caelan y despertar de un guardián que parece reconocerlo. Secuencia en PROLOGO-CAELAN.md. Próxima decisión: resolución jugable/narrativa del encuentro. Implementación pendiente.

D22 fija la resolución del prólogo: combate defensivo, pista «Te llevaron… lejos de aquí…» y descarga del fragmento que permite escapar. Pendientes: reglas exactas del tutorial y escena de regreso con los cuidadores.

D23 limita el conocimiento de los cuidadores: únicamente recibieron a Caelan de un guardián; no conocen el secreto de su origen. Pendiente en X10: si Caelan conoce su acogida desde antes o la descubre en el regreso. Evitar reacciones que impliquen conocimiento oculto no acordado.

D24 resuelve lo que Caelan sabe al comenzar: desconoce su acogida. La escena de regreso no la revela; quienes sepan algo en el pueblo callan por protección. X10 debe diseñar pistas y descubrimientos durante el viaje, distinguiendo acogida de origen verdadero. La secuencia y momento de revelación siguen pendientes.

X12 — dirección visual (parcial): D25–D27. V2 de exploración/diálogo preparada en muestras/necrovortice-v2, con Almendra en diálogo y marcos curvos de oro/turquesa más cercanos a la referencia 06. V1 conservada para comparar. Capturas, controles, fuentes y recursos verificados en Chromium de escritorio; falta revisar V2 y diseñar combate. Acabado de producción, escalas de pixel art, ventanas pequeñas e integración en Godot pendientes.


Actualización D30 — 2026-11-16: primera HUD nativa implementada en laboratorio Godot independiente (muestras/hud-godot). X12 avanza con recursos/controles nativos y comprobaciones registradas en AVANCE-HUD-001.md; sigue parcial por revisión humana, integración con la campaña, combate y otros tamaños/plataformas. El mundo 2D y el juego principal no cambiaron.


Actualización D31 — 2026-11-16: HUD de exploración integrada en la campaña 0.5.0-dev con datos reales, menú/mapa/mochila y reglas existentes. Ver AVANCE-005.md. La conexión y las pruebas automatizadas están hechas; quedan revisión humana y dirección visual de combate, móvil/mando y arte/narrativa. El laboratorio de HUD se conserva como referencia.
