# Revisión de HUD — 16 de noviembre de 2026

Estado: análisis y propuestas para decidir con el usuario, sin implementación. Fuente local: referencias/interfaz/07-hud-enviada-2026-11-16.png. Se evalúa la captura enviada, no el comportamiento temporal del juego ni código actualizado.

## Diagnóstico

La carga mayor está arriba: identificación del lugar, zona hostil, indicaciones de salida/jefe, objetivo y salida disponible compiten. Se suman un bloque separado para pociones, accesos inferiores y mochila detallada. Los marcos tienen una identidad coherente; conviene revisar permanencia, agrupación y jerarquía antes de cambiar la estética o reducir letras.

La captura muestra vida baja (14/38): la vida y su alerta son prioritarias. Hostilidad, dirección de salida y posibilidad de retirarse son estados distintos; compactarlos no debe volver ambiguas las reglas de retirada. El riesgo de perder materiales merece seguir indicado.

## Propuesta de exploración compacta

- Permanentes: retrato, PV/PM y contador pequeño de pociones agrupados; capacidad de mochila e indicador En riesgo; objetivo breve si el usuario desea seguirlo.
- Al entrar/cambiar: título de zona y anuncio de hostilidad; después conservar una señal compacta del peligro vigente.
- Navegación: direcciones de jefe/salida en el mapa o al consultar orientación, conservando una indicación inequívoca de si retirarse es posible en ese momento.
- Mochila: fila compacta con capacidad y riesgo; desglose al abrirla y breve actualización al recoger materiales. Mantener consulta accesible mediante botón/teclado, no solo hover.
- Objetivo: una línea con acción y progreso; título narrativo y detalle en diario o panel expandido.
- Interacción: aviso asociado al objeto y solo cuando se cumpla el alcance real; verificarlo jugando, porque una captura no acredita esa condición.
- Menús: evitar cuatro grandes casillas permanentes si basta un acceso compacto que mantenga disponibles mapa, diario, personaje y pausa. Probar comprensión de iconos con jugadores.
- Durante diálogo: retirar temporalmente orientación y detalles secundarios de recursos; en combate, priorizar intención enemiga y acciones según las reglas por turnos del proyecto.

Son propuestas, no decisiones confirmadas. No esconder PV bajos, peligros actuales o consecuencias de retirada por perseguir una interfaz minimalista.

## Comparación investigada

### Hyper Light Drifter

La entrevista con Teddy Diefenbach describe la reducción de texto y elementos de interfaz para dar protagonismo al mundo. Es una referencia de jerarquía y contención, no una razón para eliminar objetivos o números útiles de este RPG.

Entrevista: https://www.killscreen.com/building-wordless-world-hyper-light-drifter/

En una conversación de Steam, un jugador pide mantener la HUD visible porque le incomoda recuperar salud, botiquines y munición manualmente. Es un ejemplo individual, no una conclusión general sobre todos sus jugadores. Favorece ofrecer opción Siempre visible/Contextual en vez de imponer ocultación total.

Conversación: https://steamcommunity.com/app/257850/discussions/0/365163686037785986/

### Dead Cells

Las notas oficiales de Breaking Barriers incorporan tamaño y transparencia de HUD ajustables, opciones de fuentes, información redundante mediante símbolos y color, y reducción de partículas. Lo aprovechable es permitir legibilidad y densidad configurables, conservando la información importante. Una HUD con más datos puede funcionar si su distribución y prioridades están claras.

Notas oficiales: https://deadcells.com/patchnotes/29

El equipo del port móvil explica por qué reorganizó controles e interfaz para las condiciones reales de interacción. No conviene trasladar automáticamente el número o tamaño de botones de un juego de acción a un RPG por turnos.

Artículo del equipo: https://www.gamedeveloper.com/design/porting-i-dead-cells-i-to-mobile-an-in-depth-breakdown

### Referencia adicional para consultar

Sea of Stars es un RPG por turnos con pixel art; su material oficial puede servir para comparar presentación de exploración/combate. Esta revisión no atribuye una regla específica de HUD a capturas que no pudieron inspeccionarse de forma fiable.

Press kit oficial: https://sabotagestudio.com/presskits/sea-of-stars/

## Siguiente comprobación propuesta

Comparar dos capturas con el mismo escenario: actual y compacta. Evaluar si se reconocen con rapidez vida, posibilidad de retirada, materiales en riesgo, objetivo e interacción. Después verificar jugando avisos de entrada, cambios de estado, combate y recogida. No se ha hecho esta prueba de usuarios.

Observación pendiente: se muestran 4 maderas, 2 minerales y 1 cristal, junto a 6/12. Confirmar si la capacidad representa unidades, peso u otra regla antes de tratarlo como una inconsistencia.


## Ejemplo visual solicitado después del análisis

El usuario pidió un ejemplo de la simplificación. Se preparó [un visor comparativo](muestras/hud-compacta-2026-11-16/index.html) con la captura original y [una edición conceptual](muestras/hud-compacta-2026-11-16/propuesta.png). Es un ejemplo de exploración estable: estado/pociones agrupados, objetivo breve, hostilidad y retirada visibles por separado del objetivo, mochila resumida y mapa/menú compactos. El aviso E no aparece porque el personaje está lejos del fragmento. La aparición temporal del título de zona y el despliegue del inventario son comportamientos propuestos, no funciones de esta imagen.

La imagen se generó con image_gen integrado. [Prompt y notas](muestras/hud-compacta-2026-11-16/LEEME.md). La edición puede reconstruir píxeles de escenario; no es un cambio instalado ni una comparación de píxeles preservados. No se alteraron juego, recursos de producción o guardados. Pendiente de opinión del usuario.


## Primera reconstrucción editable de la HUD

Tras limitar el trabajo a la HUD, se preparó muestras/hud-compacta-editable con recursos SVG y texto separados del concepto de imagen. Permite revisar estados y ajustar distribución en un entorno aislado. No incorpora todavía controles Godot ni modifica el juego. El acabado queda sujeto a revisión del usuario antes de integrar.
