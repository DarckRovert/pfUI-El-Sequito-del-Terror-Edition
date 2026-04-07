# â“ Wiki: FAQ [SÃ©quito del Terror]

Preguntas frecuentes y resoluciÃ³n de problemas tÃ©cnicos para v5.1.4+.

## ðŸ› ï¸ Error: `sequito.lua:145: Attempt to call global 'ConfigToAdd' (a nil value)`
**Estado**: âœ… Resuelto en v5.1.4.
- **Causa**: Shagu's pfUI eliminÃ³ el mÃ©todo `ConfigToAdd` en versiones recientes de Vanilla.
- **SoluciÃ³n**: El AddOn ahora usa el sistema de anclaje nativo mediante `objectCount`. AsegÃºrate de haber actualizado `sequito.lua`.

## âš™ï¸ Â¿Por quÃ© no se traduce todo en el chat?
- **Diccionario Offline**: El traductor v2.0 es offline. Solo traduce palabras o frases que existan en `translator_dict.lua`.
- **DetecciÃ³n**: Si el mensaje es una mezcla extraÃ±a de idiomas, el motor puede detectar "unknown" y no procesarlo por seguridad.

## âš¡ El juego da tirones (Lag) al abrir el mapa.
**Estado**: âœ… Optimizado en pfQuest v5.1.4.
- Se han aÃ±adido throttles de 0.05s a las animaciones de los nodos del mapa para evitar saturar el hilo de renderizado de WoW.

---
Â© 2026 **DarckRovert** â€” El SÃ©quito del Terror.

