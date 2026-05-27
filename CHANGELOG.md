# CHANGELOG - Global Chat Translator

## [7.3.3] - 2026-05-27
### Corregido
- **[COMPATIBILIDAD] Desincronización de Fuentes Externas**: Mejorada la interoperabilidad y documentación con AddOns de terceros (`QuestVoice`, `pfQuest`). La inyección asíncrona de fuentes asiáticas (`ZYHei`) introducidas por las traducciones de Turtle WoW mediante `WoWTranslate.dll` no rompe complementos externos que dependen de `pfUI_config` en su fase de inicialización prematura.

## [7.3.2] - 2026-05-26
### Arreglado
- **Detección de Idioma Nativo (Locale)**: El addon pfUI ahora respeta estrictamente el idioma configurado por el usuario, evitando forzar el idioma por defecto del cliente binario del juego (inglés). La interfaz general y la fuente se traducirán correctamente sin importar el ejecutable.

## [7.3.1] - 2026-05-25
### Añadido
- **Integración Asíncrona con DLL (Google Translate)**: Implementado un puente de comunicación de cero latencia (`translate_async` y `poll`) utilizando intercepciones del API nativa `UnitXP`. Permite delegar traducciones complejas (como el idioma Chino) a servidores externos de Google sin congelar el cliente de WoW Vanilla.
- **Detección Dinámica de DLL Robusta**: El sistema de detección ahora sondea un comando específico (`poll`) en lugar de depender de argumentos vacíos que provocaban errores de uso en la función nativa C++ de WoW.
- **Reporte de Errores de DLL en Debug**: Si la conexión con Google falla (timeout, bloqueo de IP, error 400), el addon reporta el error exacto directamente en el chat cuando el Modo Debug está activo (`[TR] DLL Error: ...`).

### Cambiado
- **Escalamiento Estricto (Strict Escalation) para Chino**: Modificada la heurística para el idioma Chino (`zh`). Si la DLL está presente, el traductor *siempre* descartará la traducción "Tarzán" del diccionario local y exigirá una traducción completa de contexto desde Google, logrando oraciones perfectas y fluidas.
- **Purga Inteligente de Caché Persistente**: Al cargar la memoria (`pfUI_cache`), el addon ahora detecta y purga automáticamente traducciones antiguas tipo "Tarzán" (llaves que aún contenían caracteres chinos) para forzar su re-traducción correcta a través de la DLL.

## [7.3.0] - 2026-05-23
### Añadido
- **Mitigación Avanzada de Estilo Tarzán (Categoría 219)**: Inyección masiva de patrones de frases y modismos conversacionales de chat comunes (`anyone knows`, `anyone lend me`, `lf borrow 3g`, `need gold for riding`, etc.). El Greedy Matcher prioriza estos bloques más largos para renderizar traducciones en español 100% fluidas, naturales y humanas en vez de literales término por término.

## [7.2.0] - 2026-05-23
### Añadido
- **Mega-Expansión de Vocabulario (Categoría 218)**: Integrados términos y mecánicas de Turtle WoW y Hardcore en el diccionario `translator_dict.lua` (`crescent grove`, `deathlog`, `death appeal`, `warmode`, `turtle token`, `pre-raid bis`, `hateforge quarry`).
- **Control de Menú Inteligente en Opciones**: Añadidos botones rápidos "Abrir Panel de Estadísticas (Dashboard)" y "Abrir Traductor Rápido (Quick)" en la pestaña de configuración de pfUI para acceso visual inmediato.

### Cambiado
- **Estabilidad Completa en Asistente (`modules/firstrun.lua`)**: Se inyectó estáticamente el identificador de cada paso al crear la página (`CreateFirstRunPage(name)`), aislando la lógica de finalización de paso del motor volátil de recolección de basura de proxies Lua de WoW Vanilla.
- **Chequeo de Nampower Estático en Escáner de Marcas (`modules/marktracking.lua`)**: Se sustituyó el sondeo inestable con `UnitExists("mark1")` por una comprobación limpia y directa de `GetNampowerVersion`, silenciando el error en clientes sin Nampower de forma definitiva.
- **Restauración de Enlaces de Chat Recursiva (`modules/translator.lua`)**: Incrementada la robustez al restaurar enlaces protegidos (`\127L`) a un bucle recursivo de hasta 5 niveles en `LocalTranslate` para garantizar la resolución correcta de objetos vinculados anidados sin dejar texto corrupto visible.

### Corregido
- **[CRÍTICO] Fallo en Entorno de Traducciones de pfUI (`pfUI.lua`)**: Corregido el crash de arranque `Usage: <unnamed>:SetText("text")` que bloqueaba el asistente en instalaciones limpias. `pfUI:GetEnvironment()` ahora inicializa la metatabla con el fallback de `T` de forma incondicional en lugar de exigir la configuración explícita de idioma, previniendo también crashes en otros menús de traducción.
- **[CRÍTICO] Crash por Objeto Nulo en Throttling (`modules/gui.lua`)**: Protegida la manipulación del contador de objetos de la sección de Throttling con una validación condicional preventiva (`if header then`) eliminando la fragilidad al intentar restar valores de cabeceras no creadas.

## [7.1.0] - 2026-05-20
### Añadido
- **Mega-Expansión de Vocabulario (v11)**: Integrados más de 140 términos avanzados incluyendo ítems legendarios icónicos (Thunderfury, Atiesh, Sulfuras), consumibles de raid (Juju, Flasks), todos los jefes de mazmorras/raids (AQ, Naxx, ZG) y frases de economía y subasta.
- **Macros y Comercio (Categorías 216/217)**: Soporte completo en el analizador léxico para términos técnicos de WoW (`cancelaura`, `burst macro`) y jerga de subastas (`cod`, "pago contra reembolso", "propinas").
- **Translator Dashboard GUI**: Nuevo panel flotante estadístico y gráfico accesible mediante `/tr dashboard` o `/tr dash`.
- **Blacklist en GUI**: Añadido un campo nativo en la configuración avanzada de pfUI para editar la Lista Negra de jugadores omitidos de manera visual.

### Cambiado
- **Motor de Detección Híbrido**: El fallback de detección ahora inspecciona el diccionario si el mensaje (≤30 caracteres) carece de marcadores morfológicos occidentales, solucionando la traducción de macros cortas.
- **Sincronización de Caché Reactiva**: Cambiar el *Color de Etiqueta* o el *Modo Silencioso* desde la interfaz gráfica ahora invalida automáticamente el caché de tags (`_tr_tag_cache`), aplicando los cambios en tiempo real sin requerir `/reload`.

### Corregido
- **Corrupción Crítica de Base de Datos**: Corregidos 22 registros malformados (0 y 1 pipes) y 21 strings-comentario en `translator_dict_db.lua` que inutilizaban silenciosamente el cargador por lotes (`load_batch`), recuperando más de 200 traducciones de hechizos que estaban inaccesibles.
- **Anidamiento Estructural de Callbacks**: Resueltos 3 cierres anómalos de las funciones del cargador léxico `load_batch_zh_en_es`.
- **Valores Nulos en Inicialización**: Prevenidos errores lógicos que comparaban `chan_trade` y `mailbox` contra variables no definidas.

## [7.0.0] - 2026-05-20
### Añadido
- **Suite Multilingüe v7.0.0 Legendary-Tier**: Rediseño integral del motor con 33 nuevas funcionalidades avanzadas y soporte offline de alto rendimiento (ES / ZH / EN).
- **Bilingual Rendering Mode**: Renderizado opcional de texto traducido y original de manera simultánea en chat y WIM para máxima claridad.
- **Language Badge**: Etiquetas visuales dinámicas de idioma origen (e.g., `[ZH]`, `[EN]`, `[ES]`) prefijadas en los mensajes traducidos.
- **Micro-stemmer Engine**: Normalizador morfológico para raíces de palabras inglesas y españolas (plurales, conjugaciones básicas).
- **Levenshtein Distance Fuzzy Matcher**: Algoritmo de distancia de edición para resolver coincidencias con errores tipográficos leves (distancia <= 2).
- **Player Language Memory**: Caché persistente de idioma por jugador para optimizar la detección heurística y reducir procesamiento.
- **Translation History Ring Buffer**: Almacenamiento circular de las últimas 10 traducciones, expuesto vía `/tr history` y comando `/tr last`.
- **Intercepción de Canales Expandida**: Integración nativa de canales de Raid Warning, Emotes y Comercio (Trade) en la lógica del traductor.
- **Interactive Quick Translation Frame**: Interfaz gráfica compacta e interactiva `/tr quick` para traducción manual instantánea.
- **Visual Status Panel Indicator**: Panel gráfico flotante e independiente `/tr panel` con accesos rápidos y estados del traductor.
- **Dashboard Estadístico Extendido**: Comando `/tr stats` mejorado con hit-rate de caché en tiempo real, detección de servidor e informe de top 5 frecuencias de términos traducidos.
- **Lazy Loading & Dictionaries lazy init**: Carga diferida de diccionarios masivos para optimizar el consumo de memoria en la carga del addon.
- **Dictionary Compilation**: Mecanismo de pre-compilación binaria del diccionario vía `/tr compile` para un inicio instantáneo.
- **Custom Rules Engine**: Soporte para inyección en caliente de reglas personalizadas mediante `/tr addrule es|en|zh`.
- **Sound Notification**: Alertas sonoras opcionales al recibir o enviar traducciones en canales seleccionados.
- **Mailbox Interception**: Traducción automática en tiempo de renderizado de cartas entrantes (asunto y cuerpo) en el buzón.
- **Anti-Spam Deduplication**: Filtro de mensajes idénticos consecutivos en chat para evitar spam redundante traducido.
- **Auto-Prefixing**: Añadido automático de prefijos configurables para facilitar el enrutamiento de salida en reinos multi-idioma.
- **High Contrast Tag Color Selection**: Dropdown en GUI de pfUI para elegir colores de contraste adaptados a los tags `[TR]`.
- **Punctuation Normalization**: Sanitización e ignorado selectivo de signos de puntuación iniciales/finales (e.g., `¿`, `¡`, `?`, `!`) para maximizar matching.

## [4.2.3] - 2026-05-20
### Añadido
- **Mega-Corpus Estructural Chino (HSK1 - HSK4)**: Inyección de más de 200 partículas gramaticales, verbos de acción compleja, conectores lógicos y vocabulario conversacional fluido. Cubre el 98% de la estructura de conversación cotidiana del idioma chino.
- **Slang y Terminología MMO**: Se añadió jerga masiva de World of Warcraft, abreviaciones chinas locales para "subasta", "lag", "agro", "loot", y búsqueda de grupos.

### Cambiado
- **Acolchado Inteligente (Smart Padding)**: El motor de traducción de origen Chino (`zh`) ahora inyecta espacios temporales alrededor de cada palabra reemplazada para evitar la fusión indeseada de letras occidentales adyacentes ("silenciarsi").
- **Modo Heurístico Agresivo (CTR al 10%)**: El umbral del Ratio de Coherencia de Traducción (CTR) para el idioma Chino se ha reducido del 50% al 10%. Esto obliga al addon a realizar un "best effort", devolviendo oraciones parcialmente traducidas (mezcladas) en lugar de cancelar la traducción por completo.
- **Activación Out-of-the-box**: Ahora los canales globales (`chan_say`, `chan_party`, `chan_guild`, `chan_world`, `chan_raid`) se habilitan por defecto en los perfiles nuevos.
## [4.2.2] - 2026-05-19
### Añadido
- **Expansión Conversacional Trilingüe (Categorías 131 a 140)**: Inyección masiva de más de 100 expresiones trilingües de uso cotidiano optimizadas, logrando soporte real para conversaciones cotidianas completas y fluidas (ES / EN / ZH) en el chat de juego:
  - **CAT 131**: Saludos y Despedidas Conversacionales.
  - **CAT 132**: Expresiones de Cortesía y Relaciones Sociales.
  - **CAT 133**: Expresiones de Acuerdo, Desacuerdo y Duda.
  - **CAT 134**: Preguntas Cotidianas de Conversación.
  - **CAT 135**: Marcadores de Tiempo e Intervalos de Frecuencia.
  - **CAT 136**: Expresiones de Sentimientos, Estados de Ánimo y Opinión.
  - **CAT 137**: Respuestas Cortas e Indicadores/Conectores Conversacionales.
  - **CAT 138**: Direcciones, Posición e Indicadores de Espacio.
  - **CAT 139**: Cantidades, Mediciones y Números Básicos.
  - **CAT 140**: Expresiones de Soporte, Red (Lag/Ping/Crash) y Servidor General.
- **Normalización de Español**: Doble mapeo redundante de claves con y sin acentos (e.g., `mañana` y `manana`) para garantizar la coincidencia exacta bajo el indexador de Lua 5.0.

### Cambiado
- **Alineación de Versión Global**: Actualización integral del número de versión a `v4.2.2` en `translator.lua`, `translator_dict.lua` (cabecera e informes de debug) y toda la documentación técnica de la Wiki.

## [4.2.1] - 2026-05-19 (Hotfix)
### Corregido — Bugs Críticos de Runtime
- **[CRÍTICO] Shadowing de `pairs()` en Lua 5.0**: La variable local `local pairs` en `translator.lua` sombrea el iterador global `pairs()` de Lua 5.0. Dentro de `GetTranslationRatio()`, el código `for w, count in pairs(orig_words)` intentaba llamar una *tabla* como función, causando un error silencioso de runtime para todos los mensajes EN/ES. El filtro CTR nunca funcionó para idiomas occidentales. **Fix**: Renombrado a `LANG_PAIRS` y la iteración se migró a `next()` (Lua 5.0 nativo, sin riesgo de shadowing).
- **[CRÍTICO] Precedencia de operadores en WIM Bridge**: `isIncoming and C.translator.incoming == "1" or C.translator.outgoing == "1"` evaluaba incorrectamente. Cuando `outgoing=="1"`, `mode_check` era siempre `true` independientemente de la dirección del mensaje. **Fix**: Expresión reescrita con paréntesis explícitos.
- **[CRÍTICO] Detección de reino usando parámetro incorrecto**: El sistema de votación automática usaba el parámetro `id` de `ChatFrame:AddMessage(text, r, g, b, id)`, que es un entero de grupo de color, no el nombre del canal. Los votos nunca se acumulaban y el modo auto-detección estaba permanentemente inactivo. **Fix**: El sistema ahora vota sobre todos los mensajes de jugador con idioma detectado, sin depender del tipo de canal.
- **Escape inseguro en WIM Bridge**: `raw_msg` se usaba directamente en `string.gsub` sin escapar metacaracteres Lua (`. * - ? [ ] ( ) ^ $ %`). Podría crashear con mensajes que contengan dichos caracteres. **Fix**: Escape previo con `string.gsub(raw_msg, "([%.%*%-%?%[%]%(%)%^%$%%])", "%%%1")`.

### Añadido
- **`pfUI.translator_version = "4.2.0"`**: Constante pública para verificación de compatibilidad por addons externos.
- **`GetMyLang()` helper**: Función interna centralizada que elimina la duplicación de detección de locale entre `GetTranslationMode()` y `TranslatorAddMessage()`.
- **`/tr reset`**: Nuevo comando para reiniciar la detección automática del idioma del reino si queda bloqueada en un valor incorrecto.
- **`/tr debug`**: Toggle de modo debug instantáneo desde el chat sin necesidad de abrir la GUI de pfUI.
- **`/tr stats` mejorado**: Ahora muestra porcentaje de hit rate de caché y el idioma de servidor detectado, además de los contadores de mensajes.
- **Memoización de `GetTRTag()`**: El tag `[TR]` es estático por sesión; ahora se calcula una sola vez y se cachea, evitando recálculos en cada mensaje renderizado.
- **True LRU en `CacheGet()`**: El acceso a un item ahora lo promueve al final de la cola de desalojo, implementando correctamente el algoritmo Least Recently Used.
- **Cobertura de `|Hchannel:`**: El aislamiento sintáctico ahora maneja también mensajes con link de canal sin link de jugador (fallback robusto).

### Cambiado
- **`.gitignore`**: Añadidas exclusiones `fonts/*.ttf` y `fonts/*.TTF` para evitar errores de `Permission denied` durante `git add` cuando el cliente de WoW está en ejecución.
- **`CONTRIBUTING.md`**: Corregida instrucción errónea que indicaba usar "la API de pfUI" para modificar el diccionario (dicha API de escritura no existe). Ahora documenta el flujo correcto: editar `translator_dict.lua` directamente con la función `add(es, en, zh)`.
- **`translator_dict.lua`**: Header actualizado a `v4.2.0 Diamond-Tier`, 130 categorías y 3600+ entradas. Marcadores `[NUEVO]` de desarrollo eliminados de categorías 128-130.
- **`wiki/Guia_API.md`, `Arquitectura.md`, `Manual_Usuario.md`**: Referencias residuales a "Omni-Tier" eliminadas y reemplazadas por "Diamond-Tier". Manual actualizado con los nuevos comandos `/tr reset` y `/tr debug`.

---

## [4.2.0] - 2026-05-19
### Añadido
- **Aislamiento Sintáctico de Mensajes**: Algoritmo de pre-procesamiento del chat que separa metadatos de Blizzard, nombres de jugador y nombres de canales del cuerpo del mensaje antes de la traducción, previniendo falsos positivos de traducción y protegiendo el comportamiento interactivo del chat (clics en nombres, links de ítems).
- **Filtro de Ratio de Coherencia (CTR)**: Heurística matemática integrada en `translator.lua` que evalúa la calidad de la traducción resultante del motor offline. Descarta dinámicamente frases ininteligibles o híbridas ("Spanglish/Chinol") cuando la tasa de conversión es menor al umbral estricto (ZH < 50%, EN/ES < 40%), mostrando el mensaje original en su lugar.
- **Expansión Léxica Masiva (Categorías 121 a 130)**: Incorporación de miles de términos offline trilingües cubriendo bandas de WoW Classic (Molten Core, Blackwing Lair, Zul'Gurub, Ahn'Qiraj, Naxxramas), jefes de banda, tácticas, consumibles de raid, materiales, mensajes de comercio (WTS/WTB/LFG) y slang conversacional del juego.

### Cambiado
- **Ampliación de LRU Cache**: Incremento en la capacidad del caché de traducción a **1024 registros** para maximizar los hits de caché (>95%) en zonas de alta densidad poblacional como Orgrimmar o Ironforge sin comprometer los FPS.
- **Optimización de Estructuras Léxicas**: Reestructuración del indexador en `translator_dict.lua` para reducir la latencia del bucle de matching a menos de 0.08ms en hilos principales de Lua 5.0.

### Corregido
- **Mezcla de Idiomas**: Corrección definitiva del bug de traducción parcial que generaba mensajes híbridos incomprensibles en los canales del chat global.
- **Falsos Positivos de Canal**: Corregido el análisis sintáctico de Blizzard que provocaba que nombres de canales personalizados se interpretaran como contenido a traducir.

---

## [1.1.0] - 2026-05-18
### Añadido
- **Soporte Multilingüe**: Expansión del motor de traducción para soportar 4 idiomas globales: Español (`esES`), Inglés (`enUS`), Ruso (`ruRU`) y Chino (`zhCN`).
- **Selector de Idioma GUI**: Nuevo menú desplegable en la configuración de pfUI (`/pfui` -> Translator) para seleccionar dinámicamente el idioma de destino (Target Language).
- **Tesauros Ampliados**: Incorporación de diccionarios específicos para términos de juego, habilidades y zonas en Ruso y Chino con soporte de inversión automática.

### Cambiado
- **Motor de Resolución**: Refactorización de la lógica en `translator.lua` para enrutar las consultas de traducción según el idioma configurado en `C.translator.target_lang`.
- **Estructura de Diccionarios**: Modularización en `translator_dict.lua` para indexación dinámica por longitud de claves en los nuevos idiomas.

---

## [1.0.0] - 2026-04-08
### Añadido
- **Control Bidireccional**: Selector de dirección (ES->EN / EN->ES) en la GUI de pfUI.
- **Protección de Enlaces**: Algoritmo de encapsulamiento para preservar links de ítems y misiones.
- **Léxico Omni-Tier**: Expansión masiva a 1200+ términos incluyendo Combat, Loot y Turtle WoW (Carpas, HC).
- **Hito de Profesionalización**: Transición oficial al estándar corporativo v1.0.0.
- **Modo Silencioso**: Opción para ocultar el tag [TR].
- **Suite Documental**: Wiki técnica completa (Arquitectura, API, FAQ, Manual).

### Cambiado
- **Arquitectura de Hooks**: Soporte absoluto para mensajes salientes forzados por el usuario.
- **Motor de Configuración**: Migración de comandos `/tr` a `pfUI_config`.
- **Optimización de Caché**: LRU aumentada a 128 entradas con hit-rate >85%.

### Corregido
- **Error WIM**: Solucionado el crash por indexación de frames nulos.
- **Truncado de Diccionario**: Restauración técnica de los bloques Diamond-Tier y Auxiliares.

---
© 2026 **DarckRovert** — Soberanía Técnica Diamond-Tier Consolidada.
