# 🛠️ Wiki: Guía de API — pfUI [Traductor Universal]

El Traductor Universal v2.0 de **pfUI [El Séquito del Terror Edition]** expone métodos globales para que otros AddOns puedan aprovechar el motor offline.

## 📡 Funciones Globales

### `pfUI.Translate(text, dictionary, keyArray)`
Traduce un string usando el motor léxico in-memory.
- **`text`**: El string original (ej: "Hello").
- **`dictionary`**: Tabla de mapeo (ej: `pfUI.translator_dicts.enUS_esES`).
- **`keyArray`**: Tabla de claves indexadas por longitud.

### `pfUI.DetectLanguage(text)`
Intenta identificar el idioma del texto basándose en marcadores comunes.
- **Retorno**: `"en"`, `"es"`, o `"unknown"`.

## 📎 Integración con Hooking
Si quieres interceptar mensajes en tu propio AddOn antes que el traductor, usa una prioridad menor o hookea el evento `CHAT_MSG_*` después de que `translator.lua` haya inyectado su lógica.

---
© 2026 **DarckRovert** — El Séquito del Terror.
