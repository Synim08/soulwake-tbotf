# Soulwake: The Bloom of the Fallen

Última actualización: 19 de noviembre de 2026.

**Soulwake: The Bloom of the Fallen** es el título vigente del juego. Aventura del Valle identifica las versiones y los archivos históricos.

## Entrega actual: 0.5.0-dev

HUD de exploración conectada a la expedición real: barras, pociones, mochila, objetivos, mapa, menú y retirada. [Jugar Windows 0.5](compilaciones/expediciones-0.5/windows/Aventura-del-Valle.exe). [Informe y comprobaciones](AVANCE-005.md). La versión 0.4 y sus exportaciones se conservan.

## Prueba de combate en tiempo real

La muestra 0.1.2 permite probar a Caelan contra dos slimes. Abre el proyecto de la muestra en Godot 4.7.2 y pulsa F5. [Proyecto](muestras/combate-tiempo-real/project.godot) · [Controles y reglas](muestras/combate-tiempo-real/LEEME.md).

## Entrega anterior: 0.4.0-dev

Encuentros con patrones variables y tres eventos opcionales: mercader, altar y viajero. Se conserva la partida 0.3; inicia una salida nueva para ver el contenido. Mismas rutas de Windows/Web de Expediciones. [Informe 0.4](AVANCE-004.md). El próximo paso es probar variedad y costes de los eventos.

## Base e historial 0.3

Existe el prototipo original en HTML/JavaScript, la muestra incremental histórica 0.2 y el piloto roguelite 0.3.0-dev en Godot 4.7.2. El Bosque del Sendero ya está implementado: preparación, rutas explorables, combates, mejoras compatibles y regreso. F2 continúa en curso por las pruebas humanas de ritmo y balance; el recorrido web completo y las exportaciones están comprobados con el alcance de AVANCE-003.md. Consulta AVANCE-003.md para la evidencia actual y sus límites.

Dirección vigente (D09): RPG roguelite 2D por turnos con expediciones variables y pueblo/campaña persistentes, desarrollado en Godot y GDScript. La economía incremental/offline deja de ser el ciclo central. La muestra 0.2 se conserva como versión jugable histórica; el nuevo ciclo está implementado en una campaña y ranura independientes. Se mantiene la posibilidad de publicar en navegador.

## Jugar y editar

- Windows, entrega 0.5: [Aventura-del-Valle.exe](compilaciones/expediciones-0.5/windows/Aventura-del-Valle.exe).
- Web, entrega 0.5: carpeta `compilaciones/expediciones-0.5/web/`, servida por HTTP.
- Windows, muestra incremental histórica 0.2: [Aventura-del-Valle.exe](compilaciones/windows/Aventura-del-Valle.exe).
- Proyecto editable: [project.godot](juego/project.godot).
- Instrucciones, recorrido y reglas: [LEEME.md](juego/LEEME.md).
- Informe actual y límites: [AVANCE-003.md](AVANCE-003.md).
- Informe histórico de estilos y persistencia 0.2: [AVANCE-002.md](AVANCE-002.md).
- Informe histórico de la primera muestra: [AVANCE-001.md](AVANCE-001.md).

## Universo narrativo acordado

El usuario aprobó unificar mundo e historia con Ascendant Odyssey, el proyecto anterior conservado en Project Ascension. [Revisión e integración](INTEGRACION-ASCENSION.md) recoge fuentes, personajes, mecánicas y cuestiones de canon. La versión jugable 0.4 todavía no incorpora esa historia. El usuario eligió protagonistas seleccionables, uno por expedición (D16). D17 fija el primer objetivo común: recuperar senderos y restaurar un antiguo faro desde el refugio al pie de la montaña para alcanzar el santuario. D18 atribuye la interrupción a un pulso anómalo del Necrovórtice, de origen aún desconocido. D19 fija la apertura con Caelan; su primera misión y la incorporación del resto del grupo siguen pendientes. D32 registra el título vigente.

- [PROLOGO-CAELAN.md](PROLOGO-CAELAN.md): apertura acordada, descubrimiento y decisiones pendientes.

- [DIRECCION-VISUAL.md](DIRECCION-VISUAL.md): dirección Necrovórtice, referencias y muestra.
- [Muestra visual V2](muestras/necrovortice-v2/index.html): exploración y diálogo con Caelan, Almendra y marcos curvos de resonancia. [Alcance, procedencia y controles](muestras/necrovortice-v2/LEEME.md). V1 conservada para comparar.

- [Muestra V3 sobre pixel art 2D](muestras/necrovortice-v3-2d/index.html): prueba cenital independiente; integración en Godot pendiente (D28/D29).

## Documentos

- [ROADMAP.md](ROADMAP.md): fases, prioridades, dependencias y condiciones de finalización.
- [DISENO.md](DISENO.md): visión roguelite, ciclo y sistemas jugables.
- [EXPEDICION-001.md](EXPEDICION-001.md): diseño implementable del Bosque del Sendero, con mapa, tres especializaciones iniciales, enemigos, botín, edificios y resultados.
- [TECNICA.md](TECNICA.md): arquitectura propuesta, guardado, tiempo, plataformas y comprobaciones.
- [BACKLOG.md](BACKLOG.md): registro con identificadores estables de las ideas, mejoras y tareas.
- [DECISIONES.md](DECISIONES.md): acuerdos, cuestiones abiertas y registro de cambios.
- [INVESTIGACION.md](INVESTIGACION.md): fuentes consultadas y relación con las propuestas.
- [referencias/prototipo-original.html](referencias/prototipo-original.html): copia sin cambios del HTML revisado.

## Cómo mantener esta documentación

1. Antes de implementar, consultar el roadmap, las decisiones y las tareas de la fase activa.
2. Añadir las ideas nuevas al backlog con un identificador; no introducirlas silenciosamente en la entrega actual.
3. Registrar cambios de criterio en DECISIONES.md, indicando motivo, fecha y elementos afectados.
4. Actualizar el backlog y el roadmap cuando una tarea cambie de estado. Documentar qué se comprobó realmente.
5. Al terminar una entrega, registrar versión o commit, plataforma, pruebas realizadas, limitaciones y siguiente paso.
6. Actualizar los documentos de diseño y técnica para reflejar el comportamiento final. Conservar el motivo de los cambios relevantes en el registro de decisiones.

Estados: **pendiente**, **en curso**, **bloqueado**, **hecho** y **aplazado**. Una tarea solo pasa a hecho cuando cumple su condición de aceptación y existe evidencia.

Las fases no tienen fechas prometidas. Se ejecutan por dependencias y resultados, con alcance revisable.

## Próximo paso

Probar humanamente la integración de HUD 0.5 con la partida habitual. La conexión de datos y el recorrido automatizado están comprobados según AVANCE-005.md; se mantienen pendientes balance fino, arte de producción y narrativa.

## Procedencia

Archivo original proporcionado por el usuario: `C:/Users/Synim/Downloads/Aventura del Valle_ RPG Incremental.html`.

La copia incluida es una referencia del prototipo, no la aplicación final ni una migración a Godot. Los archivos generados durante las pruebas de navegador no forman parte del producto.

## Últimos acuerdos — 13 de noviembre de 2026

Registrados en D10: Guerrero, Asesino y Mago con especializaciones desbloqueadas por el pueblo y botín compatible; caída pierde todos los materiales transportados; retirada permite conservarlos; mapa de rutas con pequeños escenarios explorables. Generación procedural modular prevista para más adelante. La entrega 0.3 concreta Guardián, Duelista y Piromante como especializaciones iniciales; Patio de aventureros, Botica de campaña y Banco de equipo como edificios del piloto. Las especializaciones adicionales y la generación procedural permanecen para después. Las cifras de duración y equilibrio siguen sin validar jugando.


## Laboratorio nativo de HUD

Primera prueba independiente en Godot: [abrir proyecto](muestras/hud-godot/project.godot), [ejecutable Windows](muestras/hud-godot/export/windows/HUD-Necrovortice.exe), [informe](AVANCE-HUD-001.md) y [controles](muestras/hud-godot/LEEME.md). Usa datos de ejemplo y mantiene intacta la campaña 0.4.
