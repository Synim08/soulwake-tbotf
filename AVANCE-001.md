# Avance 001 — primera aventura jugable

Fecha: 9 de noviembre de 2026. Versión: **0.1.0-dev**. Motor: **Godot 4.7.2.stable.official.ed1daf0bf**. F0 completada; F1 en curso.

## Qué se entrega

- Proyecto editable: `juego/project.godot`.
- Ejecutable de Windows: `compilaciones/windows/Aventura-del-Valle.exe`.
- Exportación web: `compilaciones/web/index.html` y archivos asociados.
- Reglas, recorrido y controles: `juego/LEEME.md`.
- Script de compilación: `herramientas/compilar.ps1`.
- Código, datos de enemigos, arte provisional original y pruebas.

Las exportaciones son locales; no se ha publicado el juego en un servicio de alojamiento. La exportación web necesita HTTP. Las herramientas portátiles del motor se conservan en `work/godot-tools` y no se incluyen en el paquete del juego.

## Funciones implementadas

1. Pueblo, bosque y mina, movimiento por casillas, colisiones y transiciones mediante carteles.
2. Interacciones con guardiana, minera, herrero, fuego, suministros, veta, herrería y faro.
3. Slime, lobo y murciélago, más el guardián de la veta. Enemigos definidos en recursos reutilizables.
4. Combate por turnos con ataque, Chispa, defensa, poción y retirada. Intención visible y golpe pesado cada tercer turno.
5. Cadena de recuperación: lobo → mina → herrería → ayudantes → espada → guardián → faro.
6. Dos ayudantes: Mara produce mineral e Ivo funde lingotes consumiendo material.
7. Economía por tiempo transcurrido, trabajo al regresar y resumen offline; límite provisional de 8 horas.
8. Guardado de posición, recursos, trabajadores, hitos, enemigos vencidos y resultado pendiente del combate. Respaldo anterior y validación de carga.
9. Copia de partida por texto JSON, importación validada y guardado manual.
10. Diario, objetivo visible, regreso directo al pueblo y botones de movimiento para pasos individuales.
11. Venta de mineral renovable para recuperar monedas después de derrotas y evitar bloqueo de reparación.

## Evidencia de comprobación

| Comprobación | Resultado | Alcance |
|---|---|---|
| Importación de proyecto y ejecución headless en Godot | Correcto | Sin errores de scripts en el recorrido ejecutado. |
| Suite `tests/test_core.gd` | 42 comprobaciones, 0 fallos | Lógica y estados; no sustituye pruebas humanas. |
| Producción online frente a offline | Aprobado | Intervalos fraccionados y un intervalo continuo; consumos y límite offline. |
| Guardado tras derrota y victoria | Aprobado | Preserva resultado y evita repetir penalización/recompensa. |
| Guardado principal dañado | Aprobado | Recupera copia anterior y explica la recuperación. |
| Datos no válidos y esquema desconocido | Aprobado | Rechazo de ejemplos probados; no es una auditoría completa de entradas hostiles. |
| Conectividad del mapa | Aprobado | Acceso a cada punto de interacción de las tres regiones mediante búsqueda de recorrido. |
| Cadena mina → ayudantes → espada → guardián → faro | Aprobado en lógica | Estados preparados para aislar transiciones; no se presenta como una partida humana completa. |
| Combates naturales con estadísticas reales | Aprobado | Los cuatro tipos son vencibles con estrategia simple; sin reducir artificialmente su vida en estas comprobaciones. |
| Recuperación económica por venta de mineral | Aprobado | Permite reparar con monedas iniciales agotadas. |
| Exportación web | Correcto | Godot 4.7.2, sin hilos, renderizador Compatibility. |
| Navegador Chromium automatizado | Recorrido parcial correcto | Pueblo, movimiento, transición al bosque, combate con slime, victoria y recarga. |
| Persistencia web de victoria | Comprobada visualmente | Tras recargar se conserva victoria pendiente, enemigo vencido, 35 PV y saldo de 27 monedas; no se repite el premio. |
| Consola de la versión web | Sin errores o avisos en recorrido probado | No garantiza todos los estados o navegadores. |
| Exportación Windows | Correcto | Ejecutable generado y arranque headless de 60 frames sin errores. No se acredita prueba visual nativa completa. |
| SHA512 de motor y plantillas | Verificado | Coincide con los sumarios oficiales descargados con la versión. |

Durante la revisión visual se ajustó la altura de la interfaz para conservar los controles en pantalla y se sustituyeron glifos de flechas que no aparecían en la fuente exportada.

## Límites y trabajo pendiente

- El usuario confirmó haber vencido al guardián y restaurado el faro, tras indicar que el juego funciona a la perfección. El recorrido principal está validado por su prueba; F1 continúa abierta por comprobaciones de persistencia e interfaz pendientes.
- El recorrido completo mediante la interfaz fue confirmado por el usuario el 9 de noviembre de 2026. No se especificaron plataforma, duración ni estrategia; no se atribuye esta confirmación a un dispositivo o navegador concreto.
- Importación/exportación tiene validación de datos probada, pero su flujo completo de portapapeles y sustitución por interfaz aún requiere revisión manual.
- Falta ampliar comprobaciones de derrota/reanudación en navegador y de ausencia real con cierre completo del navegador.
- No hay validación en móvil real, mando, Safari o Firefox; la orientación vertical requiere adaptación.
- No se han medido exhaustivamente rendimiento, memoria ni equilibrio de sesiones largas.
- La persistencia del navegador depende de sus permisos y almacenamiento. Exportar copias sigue siendo importante.
- El reloj del sistema se limita y normaliza para calcular ausencias; no existe una fuente de tiempo externa.
- No hay experiencia/niveles, talentos, conjuntos de equipo, reasignación a profesiones distintas, renacimiento, campaña larga, mazmorras variables, combate offline, nube ni audio.
- No se importan partidas del HTML original. La primera versión del esquema rechaza versiones desconocidas; migraciones futuras aún deben implementarse cuando exista una nueva versión.
- La estética es provisional. Las escenas de interfaz se construyen por código; la extracción de recetas, misiones y edificios a recursos se hará al ampliar contenido.

## Siguiente paso

El usuario ya completó la aventura. Completar la revisión de importación/exportación, derrota/reanudación y producción tras una ausencia real; recoger comentarios de ritmo cuando estén disponibles. Cerrar F1 antes de comenzar el bloque de estilos y equipo de F2.

## Validación del usuario — 2026-11-09

El usuario indicó primero «funciona a la perfección» y después confirmó: «Vencí al guardián y restauré el faro». Se registra como prueba humana completada del recorrido principal y funcionamiento satisfactorio declarado. No confirma por sí sola todos los casos de guardado, el balance a largo plazo o soporte móvil.
