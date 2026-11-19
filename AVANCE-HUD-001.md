# HUD nativa — primera implementación aislada

Fecha: 16 de noviembre de 2026. Versión de la muestra 0.1.0-hud; el juego principal continúa en 0.4.0-dev.

El usuario autorizó implementar el siguiente paso propuesto: una escena independiente de Godot para revisar únicamente la HUD. Se creó [el laboratorio editable](muestras/hud-godot/project.godot), [ejecutable Windows](muestras/hud-godot/export/windows/HUD-Necrovortice.exe) y exportación web. [Controles, API y límites](muestras/hud-godot/LEEME.md).

Implementados marcos/texturas, fuentes/retrato originales, barras y contadores, objetivo/progreso, hostilidad, retirada, navegación por señales y mochila desplegable. La escena reutilizable recibe datos con set_state y no contiene reglas de campaña ni persistencia.

Comprobación: 21 pruebas de UI aprobadas (incluidos valores inválidos y distribución con texto largo en tres tamaños); Windows iniciado y renderizado mediante OpenGL/NVIDIA; versión exportada Web revisada visualmente y mediante controles. [Captura nativa Windows](muestras/hud-godot/capturas/vida-baja-windows.png) y [captura general Web](muestras/hud-godot/capturas/vista-general-web.png). Evidencia adicional en capturas/validacion.json y pruebas.txt.

La comparación de hashes confirmó los 68 archivos del juego principal y el guardado existente sin cambios. No se sustituyó su HUD ni se tocó el escenario 2D.

Pendientes: opinión del usuario sobre aspecto/legibilidad; conexión posterior a los datos reales de la campaña y pantallas de mapa/menú/poción. El laboratorio usa datos simulados y no valida todavía esa integración, mando o móvil. No se declara coincidencia exacta con cada píxel de la referencia generativa.
