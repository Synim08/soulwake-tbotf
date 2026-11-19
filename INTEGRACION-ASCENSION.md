# Unificación con Ascendant Odyssey

Fecha: 14 de noviembre de 2026. Dirección aprobada por el usuario: unificar el mundo y la historia del proyecto anterior con el juego actual y reutilizar elementos concretos. Las adaptaciones detalladas que siguen son propuestas; no están implementadas.

## Conclusión de la revisión

El material aporta una identidad narrativa aprovechable: una montaña nacida del sacrificio de una guerra, una energía que puede sanar o destruir, personajes con motivos personales para ascender y comunidades con intereses distintos. La base Godot 0.4 aporta expediciones, combate por turnos, pueblo persistente, rutas, eventos y guardado. La integración debe conectar ambas cosas mediante misiones y decisiones jugables.

El universo de referencia pasa a ser Ascendant Odyssey. Aventura del Valle sigue identificando la base técnica y los archivos actuales. El título público definitivo queda pendiente; cambiar el nombre de aplicación de Godot puede cambiar la ubicación del guardado y requiere una política de migración, no un simple reemplazo de texto.

## Material revisado y procedencia

Carpeta original: `D:/Synim/Uni cosas/Project Ascension`. Se revisaron 35 archivos: 14 Word, 8 PDF y 13 imágenes externas. Se extrajeron también seis imágenes incrustadas en documentos. Los originales no se editaron. No hay proyecto ejecutable, escenas ni código de juego en los archivos encontrados; la reutilización principal es narrativa, conceptual y visual.

Los PDF de Caelan, Ícaro, armas, Sigrid, reputación, Thaleon y mundo son sustancialmente equivalentes a sus Word, con diferencias de formato/extracción. La excepción importante es `Ascendant Odyssey Personaje 1 (1).pdf`: contiene cuatro páginas de un relato de Ícaro distinto del breve Word de nombre semejante. No se consideró un duplicado descartable.

| Fuente original | Contenido que aporta |
|---|---|
| Worldbuilding.docx / .pdf | Gran Guerra, Gran Montaña, Necrovórtice, Vortiluminos, Desgarraalmas, Zeroth y Renegado del Vórtice |
| Thaleon Darvann.docx / .pdf | Protector del pueblo, pérdida de Arian, relación con Elira, ira, culpa y búsqueda de perdón |
| Icaro Krustifer.docx / .pdf | Ladrón solidario, Dédalo/Dalia, Saltran, Altherion, daga familiar y búsqueda de respuestas |
| Ascendant Odyssey Personaje 1.docx | Borrador de Ícaro, gremio, ascenso y tesoro de Algias |
| Ascendant Odyssey Personaje 1 (1).pdf | Otra versión desarrollada del ataque a la aldea de Ícaro y su huida |
| Caelan Solstar.docx / .pdf | Niño de doce años, nacimiento en el santuario, ojos dorados y conexión singular con el Necrovórtice |
| SIGRID THRYMSDÓTTIR.docx / .pdf | Teleytayos, Thrym, Skjólheim, Vorse, Empatís, Yrsa y conflicto de culpa |
| Sistema de Reputación en Ascendant Odyssey.docx / .pdf | Ohr/Chaan, Pitak/Tseren y Teleytayos/Thrym; confianza, acceso, misiones y alianzas |
| Mecanica de armas.docx / .pdf y Listado de armas.docx | Familias de armas y combate de acción con combos, paradas, movilidad y recursos |
| Armas únicas.docx | Armas vinculadas a personajes y sus historias |
| Grito del hijo.docx | Arma de Thaleon que alterna martillo, espada larga y espada/escudo |
| Arma dual de Ícaro.docx | Céfiro/Ala Esmeralda, vínculo de hojas, desplazamiento y cargas |
| Albor de los Inocentes.docx | Conjuros de energía no elemental, impulsos, sobrecarga y protección |
| temas a tocar en la reunion.docx | Notas de discusión: eliminar estamina y estilo de espada veloz; no son órdenes vigentes de implementación |
| Ilustraciones | Retratos/referencias de Caelan, Thaleon y Sigrid; armas, formas y un dibujo de personaje sin identificación confirmada |

La revisión usó contenido extraído de los documentos y comparación entre formatos. Se inspeccionaron visualmente las ilustraciones externas e incrustadas mediante hojas de contacto. No se hizo una corrección editorial o auditoría de maquetación de todos los originales.

## Qué procede de los documentos

1. La Gran Montaña absorbe energía de quienes murieron en una guerra antigua. El Necrovórtice vincula tierra, almas y elementos; también permite reconstrucción, sanación y protección. No es intrínsecamente malvado.
2. Los Vortiluminos canalizan los elementos. Los Desgarraalmas buscan un contacto más directo, peligroso e inestable con almas y energía primordial. Existen usuarios destructivos, pero no debe equipararse automáticamente toda magia con corrupción.
3. El Renegado del Vórtice figura como antagonista de motivos aún inciertos. No se afirma que sea responsable de todas las tragedias de los protagonistas.
4. Thaleon, Ícaro y Caelan tienen motivos diferentes para ascender: reconciliación/perdón, respuestas y solidaridad, e identidad/vínculo con la montaña. Sigrid añade el conflicto entre precisión, obediencia, culpa y empatía.
5. Las tribus tienen personajes y funciones propias. Reputación puede abrir misiones, lugares, equipo y alianzas; el borrador propone empezar hostil con las tres.

Estos son materiales de referencia del proyecto anterior. Los borradores contienen conflictos que deben resolverse al fijar canon; el nombre de un archivo o su fecha no basta para declarar que una versión reemplaza otra.

## Propuesta de integración narrativa

Situar el valle y Refugio del Alba en las rutas bajas de la Gran Montaña. El pueblo recibe habitantes desplazados, exploradores y miembros de las tribus. Las expediciones recuperan suministros y descubren las consecuencias actuales de la guerra y del uso del Necrovórtice. Reconstruir habilita contactos y preparativos para ascender.

Bosque, mina, ruinas y campamento pasan a ser lugares de ese mundo. El faro puede convertirse en un punto de orientación y estabilización de rutas afectadas por el Vórtice; esta función es una adaptación nueva, no una afirmación del material original. Mara e Ivo pueden conservarse como habitantes del refugio, junto a los personajes originales de Ascendant Odyssey.

La montaña ofrece una campaña de largo plazo; cada expedición tiene una meta concreta cercana. Descubrir el pasado mediante objetos, conversaciones, encuentros y consecuencias evita contar todas las biografías antes de jugar. El tono puede combinar pérdida y peligro con solidaridad y reconstrucción, respetando que el Necrovórtice también origina vida.

Los borradores permiten distorsiones de realidad y espacio-tiempo, pero no establecen expresamente un bucle roguelite ni resurrección automática. No añadir ambas cosas como canon supuesto. De momento, caer mantiene el contrato de perder materiales y regresar al refugio; su explicación narrativa se decidirá sin introducir un reinicio completo de historia.

## Personajes y clases

| Personaje | Encaje posible | Adaptación y límite |
|---|---|---|
| Thaleon | Guerrero; protección y furia | Su Forma del Lamento puede inspirar posturas defensiva/ofensiva y especializaciones. Conservar a Elira/Arian y su conflicto, no reducirlo a una mejora de estadísticas |
| Ícaro | Asesino; Duelista y dagas | Céfiro + Ala Esmeralda y las marcas encajan con ritmo/críticos. Su código de no trasladar consecuencias a otros puede crear decisiones en eventos |
| Caelan | Mago del Vórtice | Sus impulsos y energía no elemental inspiran una especialización propia. No identificarlo automáticamente con el Piromante existente; su personalidad optimista debe conservar peso |
| Sigrid | Personaje de misiones y futura vía de arquera | Puede introducir a los Teleytayos y sus conflictos. No forzarla dentro de Asesino ni añadir una cuarta clase sin diseñarla |

D16: el usuario eligió protagonistas seleccionables. Se controla uno por expedición, elegido antes de salir; dirección inicial Thaleon/Guerrero, Ícaro/Asesino y Caelan/Mago. Los demás pueden intervenir desde el refugio y la historia. Diferenciar identidad, clase y especialización. La incorporación jugable de Sigrid y su momento de aparición siguen por concretar. Pendiente implementar; no se reemplazó aún al aventurero del piloto.

## Mecánicas que merecen adaptación

| Idea original | Traducción posible al juego por turnos | Evitar trasladar literalmente |
|---|---|---|
| Reputación tribal | Misiones y decisiones consolidan confianza al regresar; abren servicios, rutas y entrenamiento | Tres barras de farmeo obligatorio o bloqueo inicial de toda ayuda |
| Formas del Grito del Hijo | Elegir postura con ventajas y costes sobre ataque, defensa o preparación | Alcance en metros, porcentajes y curación infinita al bloquear |
| Hojas de Ícaro | Marcar, preparar estocada y consumir una oportunidad de crítico | Teletransporte espacial en un combate que aún no tiene posiciones |
| Impulsos de Caelan | Cargas visibles ganadas al actuar y gastadas en potenciar un hechizo o proteger | Cinco hechizos, segundos de enfriamiento y salvaciones repetidas sin probar el ritmo |
| Ojo del Vórtice de Sigrid | Objetivo marcado, información y tiro preparado | Fallos aleatorios ocultos que castiguen la lectura táctica |
| Secretos del Necrovórtice | Reconstruir una memoria, purificar un lugar o decidir sobre una reliquia | Suponer que todos los fragmentos de alma son moneda consumible sin consecuencias |

Los edificios pueden seguir desbloqueando especializaciones. Las relaciones tribales pueden aportar el instructor o conocimiento que falta: ejemplo propuesto, un edificio de estudio más confianza Pitak permite investigar una rama mágica. No fijar aún costes ni clases nuevas. El arreglo de armas tácticas y balance fino continúa aplazado (Q01).

## Primera incorporación propuesta

Convertir el siguiente bloque de encargos/secretos en una misión con identidad del universo: **El registro perdido de Chaan**.

1. Chaan, ya presente en el documento de reputación, llega al refugio buscando una tablilla con registros de un antiguo sendero Ohr.
2. El jugador acepta el encargo y busca una marca reconocible en las ruinas del bosque. El lugar contiene un fragmento breve sobre la montaña y una decisión exploratoria, no una biografía completa.
3. La tablilla ocupa progreso de misión de la expedición. Se entrega al regresar vivo por retirada o victoria; si se cae, sigue pendiente y se puede volver a buscar.
4. Entregarla consolida el primer hito de confianza Ohr, desbloquea un registro en el pueblo y abre una siguiente tarea o preparación útil, por concretar.
5. Tras el regreso, una conversación breve introduce la relación personal de Ícaro con esas rutas. Su aparición como protagonista seleccionable se decide por separado.

Esto es una misión nueva propuesta a partir de personajes y facciones del material, no una misión hallada en los archivos. Abarca una relación, un secreto, un objeto y una consecuencia persistente. La 0.5 sugerida de herramientas/herbario puede adaptarse después o convivir con ella; no está implementada.

## Diferencias que debemos resolver

- Ícaro: el PDF inicial relata huida del establo por orden de Dédalo y explosión verde a distancia; la biografía posterior describe que conserva la daga entre restos y Saltran lo encuentra allí. Elegir una versión o una síntesis explícita.
- Daga: aparecen Verdicta de Esmeralda, Pluma de Esmeralda y Ala Esmeralda. Definir nombre canónico, alias y relación con Céfiro. El título del arma dual no coincide de forma consistente con su descripción.
- Sigrid: el nombre Yrsa aparece en el recuerdo de la víctima y después como hermana que busca venganza. Aclarar a quién corresponde y nombrar a la otra hermana. Concretar también la cronología hasta los 27 años.
- Caelan: su poder central es no elemental en el arma dedicada. Eso no coincide con renombrar sin más al mago de fuego. Elegir papel jugable y progresión.
- Reputación: el texto establece hostilidad inicial con las tres tribus; niveles Hostil → Desconocido → Tolerado necesitan una regla narrativa clara. Empezar desconocido salvo enemistades concretas sería una adaptación propuesta, no lo escrito originalmente.
- Estamina: unas habilidades usan aguante, pero la nota de reunión plantea eliminar esa barra. Mantener por ahora los recursos actuales; no inferir una decisión antigua definitiva.
- Las imágenes aportan retratos y referencias, no animaciones listas para jugar. Hay versiones diferentes de Sigrid y estilos distintos entre armas detalladas y retratos pixelados. Decidir referencias finales y registrar autoría/procedencia al producir los recursos del juego.

## Próximo paso

Preparar una pequeña biblia narrativa y el diseño de la primera misión integrada. Fijar conexión valle–montaña, papel de los personajes y versiones de sus historias antes de reescribir escenas. No renombrar todavía la aplicación/ranura ni convertir el combate a acción. Las fuentes se mantienen como referencia; las adaptaciones aprobadas se registrarán en DECISIONES.md.

## Premisa inicial aprobada — D17

Los protagonistas coinciden en un refugio al pie de la Gran Montaña, cada uno con motivos propios para ascender. El camino está interrumpido: recuperar senderos y restaurar un antiguo faro permite continuar hasta el santuario. La reconstrucción y las expediciones alimentan este primer objetivo compartido. La causa del bloqueo y del apagado del faro, las llegadas individuales y el misterio inicial siguen por decidir; no son hechos escritos todavía. Protagonistas seleccionables acordados en D16. Implementación narrativa pendiente.

## Incidente inicial aprobado — D18

El camino y el faro fueron afectados por un pulso anómalo del Necrovórtice. Guardianes alterados y senderos peligrosos dan contexto a las primeras expediciones. El origen natural o provocado del pulso permanece como misterio; ningún responsable está confirmado. La siguiente decisión de introducción es elegir entre apertura con un protagonista o selección de los tres desde la primera escena.

## Protagonista de apertura acordado — D19

El usuario elige comenzar con Caelan. La propuesta de abrir con Ícaro queda descartada. Su perspectiva permite descubrir el Necrovórtice a través de sensaciones, curiosidad y vínculos personales antes de comprender su origen. Conservar su edad y personalidad de las fuentes. El momento de selección libre del resto del grupo sigue pendiente.

Borrador de escena, aún propuesto: Caelan percibe una resonancia extraña de la montaña en las cercanías del refugio después del pulso; ayudar en una tarea local lo lleva a investigar un sendero y encontrar una pista relacionada con el faro. Regresar conecta ese descubrimiento con el objetivo común. No muestra el nacimiento de Caelan ni identifica al responsable del fenómeno.

## Revisión de la apertura con el aporte del usuario — D20

Caelan ya vive en el pueblo antes de comenzar la historia. Sus cuidadores le advierten que no se acerque a la zona afectada; él desobedece por curiosidad. Esta motivación sustituye la propuesta de iniciar mediante un encargo. Encaja con su biografía, en la que una familia de una aldea lo cría después de ser llevado allí por los guardianes.

Borrador de prólogo: vida cotidiana breve con los cuidadores, advertencia sobre el sendero tras el pulso, exploración a escondidas y un descubrimiento inesperado relacionado con el faro. El primer encuentro peligroso podría hacer aflorar su magia de forma instintiva. Lugar exacto, señal, combate y regreso siguen por diseñar; tampoco se han elegido los nombres o la relación concreta de los cuidadores.

## Descubrimiento elegido — D21

El usuario elige combinar el fragmento que responde a Caelan con un guardián que parece reconocerlo. El prólogo consolidado y sus cuestiones abiertas están en [PROLOGO-CAELAN.md](PROLOGO-CAELAN.md). Pendiente resolver el encuentro y concretar la pista; no está establecida aún la identidad del guardián.

D22 concreta el primer encuentro: defensa, palabras entrecortadas del guardián y descarga del fragmento para escapar. Pista acordada: «Te llevaron… lejos de aquí…». La siguiente escena narrativa pendiente es el regreso al pueblo. Ver PROLOGO-CAELAN.md.

## Conocimiento de los cuidadores — D23

Solo saben que un guardián dejó a Caelan a su cuidado. No conocen su origen real ni el significado de su vínculo con la montaña. El misterio también es nuevo para ellos. No está confirmado que el guardián de la entrega sea el del encuentro del prólogo. Falta decidir qué sabía Caelan antes de salir y cómo se habla de su acogida al regresar.

## Descubrimiento gradual del origen — D24

Caelan desconoce su acogida. Quienes conozcan esa circunstancia en el pueblo callan por protegerlo; no se la revelan durante el regreso del prólogo. El viaje le permitirá reunir pistas. Se conserva el límite D23: sus cuidadores solo saben que un guardián lo dejó a su cuidado, no el origen real. No confundir el silencio sobre la acogida con conocimiento colectivo de su nacimiento o poder.
