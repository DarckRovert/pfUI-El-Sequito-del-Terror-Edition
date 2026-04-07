# Contributing to pfUI [El Séquito del Terror Edition] 🧬🧪

¡Gracias por querer contribuir a la excelencia técnica de **El Séquito del Terror**! Para mantener el estándar **Diamond Tier** de **DarckRovert**, todas las contribuciones deben seguir estas directrices estrictas.

---

## 🛡️ Estándares Técnicos (Lua 5.0)

Este AddOn está optimizado para **Turtle WoW** (WoW v1.12.1). Debes respetar las limitaciones del motor:

1.  **Sintaxis Local-First**: Usa siempre `local` para funciones y variables de módulo.
2.  **No Lua 5.1+**: Prohibido el operador `#` para longitud de tablas (usa `table.getn`). Prohibido `math.huge`.
3.  **OnUpdate Performance**: Todo bucle de frame DEBE implementar un mecanismo de throttling (`GetTime()`) con un tick mínimo de `0.05s`.
4.  **Memory Leak Prevention**: Evita crear tablas dinámicas dentro de bucles frecuentes. Usa pools de tablas si es necesario.

## 🎨 Arquitectura de Interfaz (GUI)

Si vas a añadir opciones al panel de configuración:
- Usa el sistema de anclaje basado en la variable global `this.objectCount` para posicionar widgets.
- No uses `SetNormalFontObject` (método inexistente en Vanilla). Usa `SetFontObject(GameFontNormal)`.
- Registra tus módulos mediante `pfUI:RegisterModule`.

## 💎 Proceso de Pull Request

1.  **Fork & Branch**: Trabaja en una rama descriptiva (`fix/memoria`, `feature/traductor`).
2.  **Documentación**: Actualiza `CHANGELOG.md` con tus cambios antes de enviar el PR.
3.  **Branding**: No alteres los enlaces oficiales (`ko-fi.com/darckrovert`, `twitch.tv/darckrovert`).
4.  **Review**: Todo PR será auditado por el equipo técnico del Séquito para asegurar impacto de FPS nulo.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de software para la conquista de Azeroth.*