# Primera prueba de combate en tiempo real

**Fecha:** 19 de noviembre de 2026. Proyecto independiente para Godot 4.7.2.

En la versión 0.1.1, Caelan se mueve un 20 % más rápido. Los slimes completan el salto un 20 % más rápido, con unos 0,19 s de vuelo en lugar de 0,23 s. El aviso rojo conserva su duración.

La prueba enfrenta a Caelan, como Guardián, con dos slimes en el Claro de savia. Los enemigos detectan al jugador, se alternan para saltar y muestran dónde van a caer. Puedes rodear el tronco central o romperlo con un ataque pesado. El encuentro termina en victoria al vencer a ambos o en derrota al agotar los PV.

## Cómo jugar

- En Windows, abre `export/windows/Prueba-Combate.exe`.
- En Godot, importa `project.godot` y pulsa **F5**.
- Para probar la exportación web incluida, sirve la carpeta `export/web` por HTTP. Por ejemplo, desde esa carpeta ejecuta `python -m http.server 8787 --bind 127.0.0.1` y abre `http://127.0.0.1:8787/`.

| Acción | Teclado y ratón | Mando |
|---|---|---|
| Moverse | WASD o flechas | Stick izquierdo |
| Apuntar | Ratón | Stick derecho |
| Ataque normal | Clic izquierdo | X |
| Ataque pesado | Clic derecho o F | Y |
| Bloquear de frente | Mantener Espacio | LB |
| Beber poción | Q | B |
| Pausa y ajustes | Esc | Start |

La pausa permite activar o desactivar los números de daño y las cifras de recarga de la poción. Desde ahí también puedes reiniciar la prueba tras confirmar.

## Reglas de esta versión

- Desde la versión 0.1.2, el ataque normal gasta 25 de estamina y el pesado 50. El pesado tarda más en conectar y en recuperarse. La estamina se recupera mientras no bloqueas, tras una pausa breve desde el último gasto. Si la agotas puedes seguir moviéndote y beber una poción.
- El bloqueo frontal reduce el daño y consume estamina al recibir el impacto. Bloquear al slime ligero cuesta 35 y al fuerte, 55. Si el golpe cuesta más que tu estamina restante, rompe la guardia y aplica su daño completo. Los impactos provocan un retroceso corto y un intervalo breve de protección.
- Empiezas con una carga de poción que cura al instante. Una vez gastada, cuatro ataques que hagan daño efectivo recuperan una carga. Un ataque que alcance a los dos slimes aporta un solo paso de recarga. Romper el tronco, fallar o esperar no aporta recarga.
- El guardado propio de esta prueba se actualiza al recibir daño, acertar ataques, beber, romper el tronco o terminar el encuentro. En una salida interrumpida, al volver empiezas en la entrada con tus PV y recursos guardados. Los slimes vencidos siguen vencidos y los supervivientes recuperan todos sus PV. También se conserva si ya rompiste el tronco.
- La victoria o derrota se guarda al resolverse. El claro permanece activo hasta vencer o caer.

Las cifras, la duración de las animaciones y los dos ataques enemigos son valores iniciales que se pueden ajustar tras jugar. Esta prueba cubre al Guardián y las cuatro acciones básicas. Las técnicas de clase, los jefes y otras reacciones del terreno quedan para iteraciones posteriores.

## Comprobaciones

Godot ejecutó 48 comprobaciones entre las reglas y la escena. Incluyen estamina, ruptura de guardia, impactos, recarga única por ataque, tronco, victoria, derrota, guardado y recarga. La exportación de Windows pasó el arranque automático. En Chromium se comprobó la detección de los slimes, un impacto, la curación con Q, la reanudación desde la entrada con la poción gastada, el ataque pesado contra el tronco y la pausa. El mando está configurado y queda por comprobar con hardware.
