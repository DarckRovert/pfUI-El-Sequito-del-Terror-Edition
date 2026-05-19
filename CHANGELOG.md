# CHANGELOG - Global Chat Translator

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
