# ⚙️ Guía de API — Global Translator (v4.2.0 [DIAMOND-TIER])

El traductor expone métodos públicos y estructuras de datos que pueden ser utilizados por otros componentes del ecosistema **pfUI** o addons de terceros compatibles con WoW Vanilla.

## 1. Métodos Públicos

### `pfUI.Translate(text, wordDict, phraseDict, phraseKeys, srcLang)`
Procesa una cadena de texto, aplica el algoritmo Greedy Matcher y el validador CTR, y devuelve su traducción.
- **`text`** (string): El mensaje original (cuerpo limpio).
- **`wordDict`** (table): Diccionario hash para palabras simples (idiomas occidentales).
- **`phraseDict`** (table): Diccionario hash para frases complejas y caracteres CJK.
- **`phraseKeys`** (table): Array de llaves de frases ordenado por longitud para Greedy Matching.
- **`srcLang`** (string): Idioma de origen (`"en"`, `"es"`, `"zh"`).
- **Retorno**: (string o nil) Devuelve el texto traducido o `nil` si no hubo traducción o si esta fue descartada por el filtro CTR.

---

## 2. Estructuras de Datos

### `pfUI.translator_dicts`
Contiene los tesauros bidireccionales y trilingües cargados en memoria. Para cada par de idiomas (`es_en`, `en_es`, `zh_en`, `en_zh`, `zh_es`, `es_zh`) existen tres tablas:
- `[pair]_words`: Tabla de mapeo hash directo para palabras alfanuméricas individuales occidentales.
- `[pair]_phrases`: Tabla de mapeo hash para frases complejas compuestas y todos los caracteres chinos.
- `[pair]_keys`: Array plano que contiene todas las claves de `[pair]_phrases`, ordenadas descendentemente por su longitud de caracteres para priorizar el reemplazo greedy más largo posible.

### `pfUI.translator_stats`
Tabla de telemetría y rendimiento en tiempo real:
- `total_in`: Mensajes entrantes que han sido traducidos exitosamente.
- `total_out`: Mensajes salientes traducidos antes de ser transmitidos al servidor de juego.
- `cache_hits`: Cantidad de consultas resueltas directamente por la memoria caché LRU (1024 registros de alta capacidad).

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería Diamond-Tier.*
