# Avance 004 — variedad de expediciones 0.4.0-dev

Fecha: 14 de noviembre de 2026. Godot 4.7.2, GDScript. Implementación del alcance autorizado: variantes de encuentros y tres eventos. Terrenos y rutas continúan hechos a mano.

## Cambios jugables

Cada salida nueva fija al comenzar una de dos variantes para slime, lobo, murciélago y veterano. Sus estadísticas base permanecen y cambia su secuencia: slime acorazado usa guardia, lobo impetuoso abre con pesado anunciado, murciélago arcano drena PM antes de preparar y veterano agresivo cambia el orden de ataques. El mapa muestra el nombre del encuentro antes de elegir ruta; el combate anuncia la siguiente acción. El jefe mantiene su patrón.

En el campamento aparece uno de tres eventos opcionales, independiente del descanso habitual:

- Mercader: un intercambio de 2 madera o 2 mineral de mochila por un suministro de tu kit; máximo 3 suministros.
- Altar: ofrece una mejora compatible a cambio de 8 PV. Muestra la oferta antes de cobrar; rechazar no cuesta vida. Exige más de 8 PV, nunca mata. El efecto se consume una sola vez.
- Viajero: gastar un suministro para acompañarlo. Regresar por retirada o victoria concede 3 madera y 2 mineral; caer descarta la recompensa. El resumen incluye el premio en el total depositado.

Puedes declinar o abandonar un evento sin resolverlo. No bloquea el avance normal; si abres la oferta del altar debes elegir o rechazarla. Las ofertas muestran hasta dos mejoras de especialización no poseídas y una común disponible.

## Guardado y compatibilidad

Misma ranura y esquema 1, con campos opcionales validados: variaciones por nodo, tipo de evento, resolución y acompañante. Las salidas 0.3 sin esos campos conservan los encuentros originales y no reciben un evento añadido a mitad de recorrido. Al empezar otra salida se generan las novedades. Los resultados, edificios y materiales anteriores se conservan.

Lectura JSON normaliza también los enteros nuevos. Se mantienen respaldo, escritura transaccional y copias. El ZIP de 0.3 se conserva como entrega histórica. El autoload incremental 0.2 sigue sin acceder a su ranura. No se recomienda abrir una salida 0.4 en el ejecutable antiguo: las ofertas nuevas no existen en él.

## Evidencia

Build: ../../work/release-0.4-build.log. 1972 comprobaciones y 0 fallos: 98 históricas, 167 lógica de expedición, 1601 integración de guardado y 106 nuevas de variación/eventos. El número de comprobaciones de integración varía según las ofertas y acciones de las rutas. El caso que dependía del patrón fijo de slime ahora fija explícitamente la variante original; los casos nuevos comprueban variantes y eventos.

Cubierto: diversidad de salidas, lectura JSON exacta, coste del mercader una vez, límite de suministros, oferta/coste del altar, rechazo sin coste, seguridad de PV, compatibilidad con estados 0.3 y premio del viajero por regreso/derrota sin duplicación. La integración recorre las rutas y guarda sus estados reales con variantes.

Chromium 1280×900: los tres menús de evento se revisaron por interfaz mediante copias preparadas importadas. El altar conservó la oferta al recargar; elegir Canalización descontó exactamente 8 PV (38→30), guardó la mejora y retiró el evento del escenario tras otra recarga. Sin errores nuevos de consola en esa revisión. No se presenta como una expedición natural completa 0.4 ni como prueba humana de balance. Captura: capturas/evento-0.4.png.

Windows/Web exportados. Arranque nativo headless durante 60 cuadros con --test-mode, sin errores en ../../work/native04.log. No sustituye un recorrido visual completo de Windows. No hay cambios de armas tácticas (Q01 aplazada), subclases adicionales, geometría procedural, encargos del pueblo nuevos ni audio. Pendiente: prueba del usuario sobre variedad y equilibrio de eventos.
