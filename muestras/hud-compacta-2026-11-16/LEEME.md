# Ejemplo de HUD compacta

Fecha: 16 de noviembre de 2026. Abrir index.html para alternar Actual, Propuesta y Comparar. No requiere conexión; los controles solo cambian la imagen mostrada.

original.png es una copia sin editar de la última captura aportada por el usuario. propuesta.png es una edición conceptual con la herramienta image_gen integrada, no con CLI/API. El prompt completo está en PROMPT.txt. El archivo generado original permanece en la carpeta generated_images de Codex; se copió la propuesta a esta muestra para conservarla con el proyecto.

La propuesta agrupa estado y pociones, destaca vida baja, reduce el objetivo, mantiene hostilidad y retirada disponible en una línea separada, resume la mochila a capacidad y riesgo, y conserva accesos de mapa/menú. El título de zona y las direcciones no aparecen en esta situación de exploración estable. El aviso E aparecería únicamente dentro del alcance real del objeto; no se simula esa proximidad en esta imagen.

Se conservan los valores de la captura (14/38 PV, 12/22 PM, dos pociones, mochila 6/12 y progreso 1/3). Los elementos son ilustrativos: las barras y botones no se conectan a datos, no hay inventario desplegable ni aviso temporizado real. El material desglose de mochila sigue pendiente de revisar con las reglas de capacidad actuales del juego.

La edición generativa puede reconstruir detalles del mundo y de los retratos. No debe tratarse como una captura del juego modificado ni como una comparación donde se hayan preservado todos los píxeles del escenario. Sirve para revisar distribución, jerarquía y área ocupada por la HUD. No sustituye recursos de producción.

La instrucción de no implementar se mantiene: no se modificaron el proyecto Godot, las compilaciones, las reglas ni los guardados. Esta propuesta queda pendiente de opinión del usuario.

## Revisión del visor

Se comprobaron las tres vistas Actual/Propuesta/Comparar, la carga de ambas imágenes y la ausencia de desborde horizontal a 420 px en Chromium. Se revisó visualmente el visor de escritorio a 1280 px. Estas comprobaciones corresponden al visor de imágenes; no validan una HUD funcional en Godot.
