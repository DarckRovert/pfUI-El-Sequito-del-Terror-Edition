# ⚙️ Guía de API — Global Translator (V1.1.0 [OMNI-TIER])

El traductor expone métodos públicos y estructuras de datos que pueden ser utilizados por otros componentes del ecosistema **pfUI** o addons externos.

## 1. Métodos Públicos

### `pfUI.Translate(text, dictionary, keyArray)`
Procesa una cadena de texto y devuelve su traducción.
- **`text`** (string): El mensaje original.
- **`dictionary`** (table): Mapa de traducción (ej: `pfUI.translator_dicts.ruRU` o `esES`).
- **`keyArray`** (table): Array de llaves ordenado por longitud para Greedy Matching.
- **Retorno**: (string o nil) Devuelve el texto traducido o `nil` si no hubo cambios.

### `pfUI.DetectLanguage(text)`
Analiza el texto para determinar el idioma de origen basado en distribuciones de caracteres (latinos, cirílicos, CJK).
- **Retorno**: (string) `"en"`, `"es"`, `"ru"`, `"zh"` o `"unknown"`.

## 2. Estructuras de Datos

### `pfUI.translator_dicts`
Contiene los tesauros bidireccionales cargados en memoria para cada idioma soportado.
- `esES`: Diccionario de y hacia Español.
- `enUS`: Mapeo estándar en Inglés.
- `ruRU`: Diccionario de y hacia Ruso.
- `zhCN`: Diccionario de y hacia Chino Simplificado.
- `*_keys`: Matrices de claves ordenadas descendentemente por su longitud (`#key`).

### `pfUI.translator_stats`
Tabla de telemetría en tiempo real:
- `total_in`: Mensajes entrantes traducidos.
- `total_out`: Mensajes salientes traducidos.
- `cache_hits`: Rendimiento de la memoria caché LRU.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería Diamond-Tier.*
