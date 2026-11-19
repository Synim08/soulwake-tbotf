# Aventura del Valle — Expediciones 0.5.0-dev

Proyecto editable para **Godot 4.7.2**, GDScript, renderizador Compatibility. Actualizado: 16 de noviembre de 2026.

## Novedades 0.5

HUD compacta conectada a los datos reales. M abre el mapa, Escape abre el menú y Q utiliza una poción en combate. La mochila se consulta al pulsarla. En el pueblo muestra el almacén protegido. No se añadió un límite de capacidad ni nivel ficticio. Reglas y guardados se conservan; informe en [AVANCE-005.md](../AVANCE-005.md).

## Novedades anteriores 0.4

Inicia una salida nueva: los encuentros pueden cambiar de patrón y el campamento incluye un evento opcional elegido al comenzar. Acércate al personaje junto al campamento y pulsa E. Puedes encontrar un mercader (2 materiales por suministro), altar (8 PV al aceptar mejora) o viajero (un suministro y recompensa si regresas vivo). Cerrar/reabrir conserva encuentros y ofertas. Una salida 0.3 en curso mantiene su contenido hasta terminarla. Detalles y pruebas en [AVANCE-004.md](../AVANCE-004.md).

## Jugar y editar

- Windows, piloto de expediciones: `../compilaciones/expediciones-0.5/windows/Aventura-del-Valle.exe`.
- Web, piloto: `../compilaciones/expediciones-0.5/web/`; servir por HTTP, no abrir como archivo local. Desde esa carpeta, `python -m http.server 8773 --bind 127.0.0.1`, después abrir `http://127.0.0.1:8773`.
- Editor: importar `project.godot`; su escena principal es `scenes/expedition.tscn`.
- La versión incremental 0.2 sigue en `../compilaciones/windows/` y `../compilaciones/web/`. Sus instrucciones históricas aparecen al final.
- Informe vigente: [AVANCE-005.md](../AVANCE-005.md); especificación: [EXPEDICION-001.md](../EXPEDICION-001.md).

La plataforma inicial sigue siendo escritorio/navegador horizontal. Las exportaciones están generadas; se comprobó un recorrido completo en Chromium y un arranque nativo aislado según el informe; no se acredita soporte móvil real, mando, Safari o Firefox por la prueba en Chromium.

## Primer recorrido

1. Abre **Menú > Preparar personaje** o acércate al Patio de aventureros. Habilitarlo es gratis.
2. Elige Guerrero/Guardián, Asesino/Duelista o Mago/Piromante. Comienzas con 38 PV, 12 PM, arma compatible y 2 pociones de 22 PV.
3. Inicia el Bosque del Sendero. Camina hasta el cartel del este y abre el mapa para avanzar.
4. En el Claro de savia, acércate al slime y confirma el combate. Elige tu primera mejora tras vencer; hay un cofre opcional en un desvío.
5. Elige Ribera o Linde. La Ribera ofrece curación o madera; el Linde exige vencer al lobo y concede mineral.
6. En el campamento, elige una sola recuperación de vida/maná o continúa sin descansar.
7. Elige Ruinas o Tala. Las Ruinas permiten contactar a Mara tras el murciélago; la Tala tiene un veterano y arma compatible.
8. En el Umbral, recoge el alijo y elige otra mejora. Puedes volver al pueblo con tu mochila desde aquí o enfrentarte al jefe.
9. Al regresar, consulta el resumen y los proyectos. La Botica exige rescatar a Mara y 4 madera/2 mineral; el Banco de equipo exige vencer al jefe y 8 madera/6 mineral.

Las dos bifurcaciones generan cuatro recorridos posibles; se visitan siete escenarios por salida completa. Los terrenos son fijos y hechos a mano. Las ofertas temporales usan semilla, se guardan y no cambian al recargar.

## Controles y decisiones

- WASD o flechas: caminar. La marcha se pausa al abrir la mochila o un menú.
- E o Espacio: interactuar cerca de un objetivo; el texto bajo el mapa indica cuál.
- Ratón o navegación de foco/Enter: menús y combate.
- Escape: cerrar menús que se pueden cancelar; no abandona combate, recompensa obligatoria de resolver ni resumen pendiente.
- Para avanzar, estar junto al cartel de salida y abrir el mapa. No se reabren las ramas descartadas ni los nodos anteriores.
- Las hierbas, el descanso y las ofertas deben elegirse u omitirse antes de continuar/regresar. El contacto con Mara y el cofre son opcionales.

## Combate y especializaciones

| Especialización | Regla inicial | Arma básica |
|---|---|---|
| Guardián | Defender devuelve 3 de daño si el enemigo golpea. No devuelve daño durante preparaciones sin ataque. | Espada, ataque total 12 |
| Duelista | Cada tercer ataque básico válido es crítico; contador visible y multiplicador inicial ×2,5 antes de defensa. | Dagas, ataque total 11 |
| Piromante | Chispa aplica quemadura de 2 de daño durante 3 acciones válidas, incluida la actual, por el bastón inicial. | Bastón, ataque 9 y Chispa 17 |

Chispa auxiliar está disponible para las tres especializaciones: cuesta 4 PM y hace 13 de daño para Guardián/Duelista, sin quemadura. El Piromante añade los efectos de su arma. Defender recupera 3 PM de base y reduce el daño del golpe; las mejoras pueden modificarlo. Las acciones inválidas no consumen turno, maná ni poción.

Los enemigos anuncian golpes, preparaciones, guardia y drenaje de PM. El veterano/jefe pueden obtener guardia que reduce en 3 el siguiente golpe directo y se consume; también afecta a Chispa. Las quemaduras atraviesan defensa y guardia. El jefe cambia de patrón al alcanzar la mitad de PV, con una preparación anunciada sin ataque adicional oculto.

Doce mejoras temporales entre catálogos de especialización y común: cada oferta R1/R2 muestra dos compatibles y una común no poseída. La ruta de Tala ofrece arma de potencia o táctica, o conservar la actual. No se acumulan bonificaciones de armas reemplazadas. Los efectos temporales desaparecen al terminar el intento. El balance fino y las especializaciones adicionales siguen pendientes.

## Qué conservas y qué pierdes

- **Retirada:** desde un lugar despejado, sin combate/decisión pendiente; todos los materiales de mochila pasan al almacén. Termina la expedición.
- **Derrota:** se pierden todos los materiales transportados y las mejoras/equipo temporales. El almacén y edificios anteriores quedan intactos. Si ambos combatientes caen, es derrota.
- **Victoria del jefe:** deposita materiales, cierra la salida y consolida un hito único. El jefe puede volver a combatirse en otra expedición.
- **Mara:** queda rescatada solo si contactaste con ella y regresas por retirada o victoria. Si caes, podrás encontrarla de nuevo.
- **Suministros prestados:** no se venden ni depositan. La próxima salida vuelve a ser gratuita y restaura el presupuesto inicial.
- No hay huida dentro del combate. Antes de comprometerte, la interfaz advierte que deberás vencer para despejar el nodo.

La Botica permite cambiar entre el kit normal y 3 tónicos de 12 PV. El Banco habilita armas tácticas iniciales. Son opciones alternativas y se construyen una sola vez; no se añade producción offline ni multiplicador permanente.

## Guardado y copias

El piloto usa `user://valley_roguelite_slot_v1.json`, con respaldo `.bak`, esquema 1 e identificador de modo `roguelite`. La partida incremental `valley_slot_v1.json` sigue separada. El autoload legado no carga ni escribe su ranura durante el piloto. No se convierte automáticamente la economía ni el progreso 0.2 al piloto.

Las acciones guardan el candidato válido antes de cambiar la sesión. El movimiento se conserva periódicamente (intervalo de hasta 2 segundos) y al perder foco/cerrar. Si una escritura falla, la interfaz explica el problema; importar no sustituye la sesión si no puede guardar la copia validada. Si principal y respaldo están dañados, se conservan los archivos y se bloquea el guardado hasta recuperar una copia.

**Partida y copias** permite guardar, exportar e importar JSON; en web incluye descarga y pegado asíncrono sujeto al permiso del navegador. La copia contiene campaña, expedición activa y resultado pendiente. Exporta antes de importar otra para conservar ambas. Los archivos de navegador y Windows siguen siendo independientes; cambiar de origen/puerto puede cambiar el almacenamiento web disponible.

Cerrar suspende la misma salida, no cuenta como retirada ni permite volver a tirar ofertas. No hay ingresos por ausencia. Reanudar una recompensa o resultado no vuelve a entregar materiales.

## Código y comprobaciones

- `scripts/expedition.gd`: servicio, comandos transaccionales y coordinación del guardado.
- `scripts/expedition_rules.gd`: estado, rutas, combate, ofertas, eventos, proyectos y liquidación.
- `scripts/expedition_store.gd`: validación, lectura/escritura y respaldo de ranura piloto.
- `scripts/expedition_main.gd`: interfaz y copias.
- `scripts/expedition_world.gd`: movimiento y dibujo de escenarios.
- `scripts/expedition_maps.gd`: terreno, objetos y accesibilidad.
- `tests/test_expedition.gd`: lógica del piloto.
- `tests/test_expedition_store.gd`: persistencia, validación y estados tras comandos.
- Los scripts y suites 0.2 se conservan para regresión y referencia.

Ejecutar suites siempre con `-- --test-mode`, que evita cargar/escribir la partida real. Ejemplo: `Godot_v4.7.2-stable_win64_console.exe --headless --path RUTA_DEL_PROYECTO --script res://tests/test_expedition.gd -- --test-mode`.

El build registrado suma **1842 comprobaciones aprobadas** (167 piloto, 1577 store y 98 legado). El número de comprobaciones de store puede variar con las ofertas y acciones de las rutas generadas en esa ejecución. Los resultados automáticos no acreditan legibilidad, duración, diversión ni balance humano. La revisión visual/exportada vigente se detalla en AVANCE-003.md.

Arte provisional dibujado por código; sin audio, procedural de escenarios, subclases adicionales, campaña extensa, nube, multijugador o soporte móvil real validado.

<details>
<summary>Instrucciones históricas de las compilaciones incrementales 0.2</summary>

# Referencia histórica — versión 0.2.0-dev

Proyecto editable para **Godot 4.7.2**, GDScript, renderizador Compatibility.

> Estas instrucciones describen exclusivamente las compilaciones históricas 0.2 conservadas. El proyecto editable abre ahora el piloto 0.3 documentado arriba.

## Jugar

La versión de Windows está en `../compilaciones/windows/Aventura-del-Valle.exe`. No requiere instalar el editor. La versión web está en `../compilaciones/web/`; debe servirse por HTTP, no abrirse directamente como archivo local.

Desde la carpeta `web`, si tienes Python, ejecuta `python -m http.server 8767 --bind 127.0.0.1` y abre `http://127.0.0.1:8767`. La partida de navegador se guarda en su almacenamiento local y es independiente de Windows y del HTML antiguo. Cambiar de origen o puerto puede cambiar el espacio de guardado.

## Editar

Importar `project.godot` en Godot 4.7.2 y ejecutar la escena principal. Herramienta portátil utilizada en este equipo: `C:/Users/Synim/Documents/Codex/2026-11-09/es/work/godot-tools/engine/Godot_v4.7.2-stable_win64.exe`.

Las plantillas verificadas se conservan en `work/godot-tools/templates` dentro del espacio de trabajo. El archivo `export_presets.cfg` utiliza rutas relativas hacia esa ubicación. Si mueves el proyecto, instala las plantillas de exportación oficiales de la misma versión y deja vacíos los campos de plantilla personalizada en ambos presets, o ejecuta `herramientas/compilar.ps1` con las nuevas rutas.

## Controles

- WASD o flechas: mover una casilla. Los botones inferiores también permiten pasos individuales.
- E o Espacio: interactuar con un objetivo cercano; el aviso bajo el mapa indica cuál.
- Ratón o navegación de foco/Enter: acciones de combate y menús.
- Escape: cerrar diálogos y menús; en combate se usa Retirarse.
- Volver al pueblo: regreso directo cuando no estás en combate.

## Recorrido inicial

1. Cruza el pueblo hacia el cartel del bosque, al este, y pulsa E cerca de él.
2. Acércate a los enemigos y pulsa E para combatir. El lobo del sendero desbloquea la mina.
3. Vuelve al pueblo y repara la herrería: 6 de madera y 10 monedas.
4. Habla con Mara e Ivo para asignarlos. Mara obtiene mineral; Ivo transforma dos minerales en un lingote cuando puede.
5. Al reunir 3 lingotes, interactúa con la herrería para fabricar la espada.
6. Descansa en el fuego y entra en la mina para desafiar al guardián. Defender protege del golpe pesado y recupera maná.
7. Regresa al faro y restáuralo con el cristal del guardián y 2 lingotes.

Puedes recoger mineral manualmente en la mina. El puesto de suministros vende pociones y compra mineral para evitar que perder monedas bloquee la reconstrucción.

## Reglas de esta versión

- 38 PV, 12 PM, ataque inicial 7, defensa 2; espada con ataque total 12.
- Chispa base cuesta 4 PM y causa 13 de daño ignorando defensa; talentos y equipo pueden modificar estos valores.
- Defender recupera 3 PM de base y reduce el daño recibido al 25%, con mínimo de 1. El sello de savia añade 1 PM; el estilo Guerrero devuelve daño.
- Poción recupera hasta 22 PV. Descansar en el pueblo restaura vida y maná gratuitamente.
- El enemigo usa un golpe pesado cada tercer turno. La intención se muestra antes de actuar.
- La derrota descuenta hasta 5 monedas una sola vez; al confirmar se vuelve al pueblo con vida y maná completos. Retirarse no tiene penalización.
- Enemigos de esta muestra no reaparecen una vez derrotados. No hay todavía experiencia, niveles ni botín aleatorio.
- Mara: 1 mineral cada 5 segundos. Ivo: 2 minerales por 1 lingote tras 8 segundos de trabajo con material disponible.
- Trabajo offline limitado a 8 horas por ausencia. Mineral y lingotes limitados a 9999 unidades cada uno.
- Auto guardado cada 5 segundos y tras acciones importantes. Resultado de combate y recompensas persistentes; copia anterior recuperable.
- Exportar/importar texto JSON desde Partida y copias. En web hay un botón de pegado asíncrono y descarga del archivo .json. La copia importada válida sustituye la actual solo si se consigue guardar; exporta antes si quieres conservar ambas.
- Sin audio, renacimiento, campaña extensa, combate offline ni sincronización en la nube. Hay una selección inicial de talentos, sin puntos ni árbol de niveles todavía.
- Objetivo inicial de prueba: escritorio/navegador en horizontal. El soporte móvil real y la adaptación a vertical siguen pendientes.

## Estilos, talentos y equipo

Abre **Personaje y estilos** en el pueblo. Cambiar es gratis y cada estilo recuerda su talento, arma y reliquia. Solo puedes reconfigurar fuera del combate y dentro del pueblo.

| Estilo | Pasiva | Talentos alternativos |
|---|---|---|
| Guerrero | Defender devuelve 3 de daño después del golpe enemigo. | Represalia: devuelve 6. Segundo aliento: recupera hasta 3 PV al defender. |
| Mago | Chispa aplica quemadura de 2 de daño por acción durante 2 acciones, incluida la actual. | Ascua persistente: 1 acción adicional de quemadura. Canalización: Chispa cuesta 3 PM. |
| Explorador | Cada tercer ataque es crítico; el contador es visible. | Puntería: crítico cada segundo ataque. Movilidad: recibes 2 de daño menos al atacar. |

Las acciones inválidas no hacen avanzar el contador ni la quemadura. Chispa renueva la duración hasta el mayor valor vigente, sin acumular daño por múltiples aplicaciones. Un golpe letal de devolución no concede victoria si el aventurero también cae.

Al fabricar la espada se habilitan tres armas: espada del valle (+5 ataque), bastón de brasas (+2 ataque, +4 daño de Chispa, +1 acción de quemadura) y arco del sendero (+4 ataque, críticos ×2,5 antes de defensa). Al vencer al guardián se habilitan el sello de savia (+1 PM al defender) y el amuleto de brasas (+1 acción de quemadura). Las bonificaciones de quemadura requieren Mago. Son desbloqueos gratuitos para probar el sistema; no representan todavía una economía de fabricación avanzada.

En **Entrenamiento** puedes repetir encuentros sin alterar enemigos vencidos, misiones ni monedas. Empiezas con 38 PV, 12 PM y 3 pociones prestadas. Al confirmar victoria, derrota o retirada se restauran los PV, PM y pociones anteriores. Se puede guardar y recuperar un entrenamiento. El guardián solo aparece como práctica después de vencerlo en la historia.

## Compatibilidad de partidas

La versión 0.2 usa esquema JSON 2 y acepta partidas 0.1 de esquema 1. Conserva el faro, los edificios, recursos, ayudantes, enemigos vencidos y resultados de combate pendientes. Al leer una partida antigua del disco conserva una copia separada con sufijo `.before-schema2.json` antes de actualizarla; si no puede conservar esa copia, detiene el guardado automático y permite exportar.

La ranura local mantiene su nombre para reconocer el progreso anterior. La copia importada original no se modifica. El HTML antiguo continúa siendo un juego separado y no se importa.

## Estructura

- `scenes/main.tscn`: entrada del juego.
- `scripts/main.gd`: interfaz y presentación.
- `scripts/world.gd`: movimiento, interacción y representación del mapa.
- `scripts/regions.gd`: mapas, objetos y reglas de acceso.
- `scripts/game.gd`: estado de partida, acciones y coordinación.
- `scripts/combat.gd`: reglas de combate por turnos.
- `scripts/build_rules.gd`: estilos, talentos y estadísticas de equipo.
- `scripts/character_panel.gd`: selección de personaje, equipo y entrenamiento.
- `data/gear/*.tres`: definiciones de armas y reliquias.
- `scripts/economy.gd`: producción por tiempo transcurrido.
- `scripts/save_store.gd`: validación, escritura y recuperación de guardados.
- `data/*.tres`: definiciones de enemigos.
- `tests/test_core.gd`: lógica y conectividad (42 comprobaciones).
- `tests/test_persistence.gd`: persistencia y fallos de escritura (11).
- `tests/test_builds.gd`: estilos, equipo, práctica y migración (45).

Las recetas, misiones y edificios tienen reglas pequeñas en el servicio de juego en esta muestra. Generalizarlos a recursos de contenido sigue pendiente de ampliación; no se ha terminado toda la arquitectura del roadmap.

## Comprobación de lógica

`Godot_v4.7.2-stable_win64_console.exe --headless --path RUTA_DEL_PROYECTO --script res://tests/test_core.gd -- --test-mode`

Usa también `test_persistence.gd` y `test_builds.gd`, siempre con `-- --test-mode`, o ejecuta el script de compilación que reúne las tres suites.

Consulta el informe `../AVANCE-002.md` para distinguir qué se ha comprobado de lo pendiente.

</details>
