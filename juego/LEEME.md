# Primera aventura — versión 0.1.0-dev

Proyecto editable para **Godot 4.7.2**, GDScript, renderizador Compatibility.

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
- Chispa cuesta 4 PM y causa 13 de daño ignorando defensa.
- Defender recupera 3 PM y reduce el daño recibido al 25%, con mínimo de 1.
- Poción recupera hasta 22 PV. Descansar en el pueblo restaura vida y maná gratuitamente.
- El enemigo usa un golpe pesado cada tercer turno. La intención se muestra antes de actuar.
- La derrota descuenta hasta 5 monedas una sola vez; al confirmar se vuelve al pueblo con vida y maná completos. Retirarse no tiene penalización.
- Enemigos de esta muestra no reaparecen una vez derrotados. No hay todavía experiencia, niveles ni botín aleatorio.
- Mara: 1 mineral cada 5 segundos. Ivo: 2 minerales por 1 lingote tras 8 segundos de trabajo con material disponible.
- Trabajo offline limitado a 8 horas por ausencia. Mineral y lingotes limitados a 9999 unidades cada uno.
- Auto guardado cada 5 segundos y tras acciones importantes. Resultado de combate y recompensas persistentes; copia anterior recuperable.
- Exportar/importar texto JSON desde Partida y copias. La copia importada válida sustituye la actual; exporta antes si quieres conservar ambas.
- Sin audio, talentos, renacimiento, campaña extensa, combate offline ni sincronización en la nube.
- Objetivo inicial de prueba: escritorio/navegador en horizontal. El soporte móvil real y la adaptación a vertical siguen pendientes.

## Estructura

- `scenes/main.tscn`: entrada del juego.
- `scripts/main.gd`: interfaz y presentación.
- `scripts/world.gd`: movimiento, interacción y representación del mapa.
- `scripts/regions.gd`: mapas, objetos y reglas de acceso.
- `scripts/game.gd`: estado de partida, acciones y coordinación.
- `scripts/combat.gd`: reglas de combate por turnos.
- `scripts/economy.gd`: producción por tiempo transcurrido.
- `scripts/save_store.gd`: validación, escritura y recuperación de guardados.
- `data/*.tres`: definiciones de enemigos.
- `tests/test_core.gd`: comprobaciones de lógica, persistencia y conectividad.

Las recetas, misiones y edificios tienen reglas pequeñas en el servicio de juego en esta muestra. Generalizarlos a recursos de contenido sigue pendiente de ampliación; no se ha terminado toda la arquitectura del roadmap.

## Comprobación de lógica

`Godot_v4.7.2-stable_win64_console.exe --headless --path RUTA_DEL_PROYECTO --script res://tests/test_core.gd`

Consulta el informe `../AVANCE-001.md` para distinguir qué se ha comprobado de lo pendiente.
