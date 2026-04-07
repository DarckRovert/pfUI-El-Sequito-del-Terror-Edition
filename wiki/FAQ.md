# ❓ Wiki: FAQ [Séquito del Terror]

Preguntas frecuentes y resolución de problemas técnicos para v9.4.0+.

## 🛠️ Error: `sequito.lua:145: Attempt to call global 'ConfigToAdd' (a nil value)`
**Estado**: ✅ Resuelto en v9.4.0.
- **Causa**: Shagu's pfUI eliminó el método `ConfigToAdd` en versiones recientes de Vanilla.
- **Solución**: El AddOn ahora usa el sistema de anclaje nativo mediante `objectCount`. Asegúrate de haber actualizado `sequito.lua`.

## ⚙️ ¿Por qué no se traduce todo en el chat?
- **Diccionario Offline**: El traductor v2.0 es offline. Solo traduce palabras o frases que existan en `translator_dict.lua`.
- **Detección**: Si el mensaje es una mezcla extraña de idiomas, el motor puede detectar "unknown" y no procesarlo por seguridad.

## ⚡ El juego da tirones (Lag) al abrir el mapa.
**Estado**: ✅ Optimizado en pfQuest v9.4.0.
- Se han añadido throttles de 0.05s a las animaciones de los nodos del mapa para evitar saturar el hilo de renderizado de WoW.

---
© 2026 **DarckRovert** — El Séquito del Terror.
