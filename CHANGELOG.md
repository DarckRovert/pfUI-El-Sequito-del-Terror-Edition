# CHANGELOG - Global Chat Translator

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
© 2026 **DarckRovert** — Soberanía Técnica Omni-Tier Consolidada.
