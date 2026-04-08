# ⚙️ Guía de API — Global Translator (V1.0.0 [OMNI-TIER])

El traductor expone métodos públicos y estructuras de datos que pueden ser utilizados por otros componentes del ecosistema **pfUI** o addons externos.

## 1. Métodos Públicos

### `pfUI.Translate(text, dictionary, keyArray)`
Procesa una cadena de texto y devuelve su traducción.
- **`text`** (string): El mensaje original.
- **`dictionary`** (table): Mapa de traducción (ej: `pfUI.translator_dicts.esES_enUS`).
- **`keyArray`** (table): Array de llaves ordenado (ej: `pfUI.translator_dicts.esES_keys`).
- **Retorno**: (string o nil) Devuelve el texto traducido o `nil` si no hubo cambios.

### `pfUI.DetectLanguage(text)`
Analiza el texto para determinar si es Inglés o Español.
- **Retorno**: (string) `"en"`, `"es"` o `"unknown"`.

## 2. Estructuras de Datos

### `pfUI.translator_dicts`
Contiene los tesauros bidireccionales cargados en memoria.
- `esES_enUS`: Diccionario Español -> Inglés.
- `enUS_esES`: Diccionario Inglés -> Español.
- `esES_keys`: Llaves ordenadas por el motor Greedy Matcher.

### `pfUI.translator_stats`
Tabla de telemetría en tiempo real:
- `total_in`: Mensajes entrantes traducidos.
- `total_out`: Mensajes salientes traducidos.
- `cache_hits`: Rendimiento de la memoria caché LRU.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería Diamond-Tier.*
