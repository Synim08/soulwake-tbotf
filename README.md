# Aventura del Valle — documentación del proyecto

Última actualización: 9 de noviembre de 2026.

## Estado real

Existe el prototipo original en HTML/JavaScript y una primera muestra jugable en Godot 4.7.2, versión 0.1.0-dev. F0 está completada; F1 está en curso. Hay versiones exportadas para Windows y web. El roadmap completo sigue pendiente; consulta AVANCE-001.md para conocer lo implementado y sus pruebas.

Dirección aceptada: ampliar el prototipo como RPG incremental 2D con Godot y GDScript, conectando exploración, reconstrucción del valle, ayudantes y progreso permanente. Mantener la posibilidad de publicar en navegador. El usuario aprobó el conjunto de propuestas del 9 de noviembre; las cifras de equilibrio, el alcance de cada entrega y las reglas señaladas como propuestas siguen sujetos a prueba.

## Jugar y editar

- Windows: [Aventura-del-Valle.exe](compilaciones/windows/Aventura-del-Valle.exe).
- Proyecto editable: [project.godot](juego/project.godot).
- Instrucciones, recorrido y reglas: [LEEME.md](juego/LEEME.md).
- Informe de entrega y límites: [AVANCE-001.md](AVANCE-001.md).

## Documentos

- [ROADMAP.md](ROADMAP.md): fases, prioridades, dependencias y condiciones de finalización.
- [DISENO.md](DISENO.md): visión, ciclo de juego y catálogo completo de las 14 propuestas jugables.
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

Probar la muestra 0.1 con el usuario, verificar el recorrido completo sin ayuda del código y recoger problemas de claridad, controles y ritmo. Completar las comprobaciones de F1 pendientes antes de ampliar estilos, equipo y contenido de F2.

## Procedencia

Archivo original proporcionado por el usuario: `C:/Users/Synim/Downloads/Aventura del Valle_ RPG Incremental.html`.

La copia incluida es una referencia del prototipo, no la aplicación final ni una migración a Godot. Los archivos generados durante las pruebas de navegador no forman parte del producto.
