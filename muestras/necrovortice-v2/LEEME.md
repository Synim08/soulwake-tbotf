# Necrovórtice V2 — marcos de resonancia

Fecha: 14 de noviembre de 2026. Muestra visual independiente de exploración y diálogo.

## Abrir

Abrir index.html en un navegador. Todos los recursos son locales. E alterna exploración/diálogo; Escape cierra; M/J/C/O abren mapa/diario/personaje/ajustes. También hay botones para cambiar vista y plegar el objetivo. El enlace inferior permite comparar la propuesta V1, conservada como carpeta hermana.

En el ZIP, abrir muestras/necrovortice-v2/index.html. La carpeta necrovortice-v1 acompaña a la muestra para que funcione la comparación.

## Cambios de esta versión

- Bordes curvos y asimétricos con filamentos de oro antiguo y cintas turquesa.
- Anillos/orbitas y cristales del Necrovórtice en diálogo, estado de Caelan, objetivo y mochila.
- Cartela curva para el nombre, marcos de retratos y accesos en aros incompletos.
- Barras de vida/maná y aviso de interacción adaptados al mismo lenguaje.
- Centro opaco y despejado; separación extra entre adornos, texto y botones.
- Almendra se conserva en el cuerpo del diálogo, tras la respuesta favorable del usuario.

Capturas: [exploracion.png](exploracion.png), [dialogo.png](dialogo.png) y [dialogo-detalle.png](dialogo-detalle.png).

## Procedencia y archivos editables

La referencia que motivó esta revisión está conservada en ../../referencias/interfaz/06-marcos-curvos-energia.png. Se adaptan curvas, anillos y cintas a la identidad del Necrovórtice. No se incorporaron recortes de la referencia como botones.

Los cinco SVG frame-dialogue, frame-hero, frame-panel, nameplate y orbit-button son dibujos originales editables. ornaments.css contiene la revisión V2; style.css y ui.js conservan la base y los controles de la muestra anterior. Los SVG usan gradientes y curvas; al preparar el arte de producción deberá decidirse su acabado y escala en relación con el pixel art del mundo.

assets/scene.png es la misma ilustración de concepto generada previamente con image_gen integrado. Prompt original en PROMPT-ESCENA.txt. assets/caelan.png es copia sin editar del diseño original de Project Ascension; solo cambia el marco y recorte visual en CSS. Fuentes locales y licencias en assets/fonts/FUENTES.md.

## Comprobación

Revisadas exploración y diálogo en Chromium a 1680 × 1050 y 1280 × 800. Carga de SVG/imágenes/fuentes, E, Continuar, Escape, cuatro paneles, objetivo plegable y bloqueo de fondo comprobados, sin errores de página o carga durante esa revisión por HTTP local. Diario y ajustes revisados después de aumentar márgenes interiores. XML de los SVG validado.

Es una muestra de escritorio. En ventanas pequeñas se reduce la composición completa; la distribución adaptable y la validación dentro de Godot quedan para producción. El escenario es una ilustración única, todavía no un mapa con colisiones o sprites animados. Los textos y valores son demostrativos. Esta muestra no cambia el ejecutable, el guardado, las reglas ni el canon del prólogo. La vista de combate sigue pendiente.
