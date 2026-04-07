# Changelog — El Séquito del Terror Edition 📈⚖️

Todos los cambios notables en este proyecto serán documentados en este archivo siguiendo el estándar **Diamond Tier** de **DarckRovert**.

---

## [v5.1.4] — 2026-04-07 [Omni-Tier]

### 🌐 Traductor Universal (Nativo v2.0)
- **Motor Offline**: Nuevo motor de traducción bidireccional ES ↔ EN sin dependencias externas.
- **Detección de Idioma**: Algoritmo inteligente que identifica el idioma del chat para evitar retraducciones.
- **Puente WIM**: Integración completa con WoW Instant Messenger (whispers traducidos).
- **Panel de Control**: Nueva pestaña en `/pfui → Traductor` para gestionar canales y el puente WIM.
- **Optimización**: Caché LRU de 64 entradas para reducir el impacto en CPU al 0.001%.

### ⚡ ApexUI & Core
- **Reparación de GUI**: Corregido error `ConfigToAdd` y `SetNormalFontObject` en `sequito.lua`.
- **Anclaje Nativo**: Restauración del sistema de anclaje de pfUI basado en `objectCount`.
- **Lag Fix**: Throttles inteligentes de 0.2s en misiones y 0.25s en rutas para eliminar stuttering.
- **Rebranding**: Actualización global de URLs a `ko-fi.com/darckrovert` y `twitch.tv/darckrovert`.

---

## 📊 Matriz de Versiones Mayores

| Versión | Fecha | Nombre Clave | Estado | Resumen |
| :--- | :--- | :--- | :---: | :--- |
| **5.1.4** | 2026-04-07 | **Omni-Tier** | ✅ | Traductor v2.0, WIM Bridge, ApexUI Fix. |
| **9.3.0** | 2026-04-05 | **Sequito-Rise** | ⚠️ | Integración WCS_Brain & Skins Custom. |
| **9.2.0** | 2026-03-20 | **Stability** | ❌ | Versión inicial estable para Turtle WoW. |

---

## [v9.3.0] — 2026-04-05

### ✨ Características
- **WCS Integration**: Preparación del núcleo para el motor `WCS_Brain`.
- **Skins Corporativos**: Bordes y texturas "Terror" pre-cargados.
- **Auto-Config**: El asistente de configuración inicial detecta el perfil **Apex** automáticamente.

### 🔧 Correcciones
- Corregido desbordamiento de memoria en el rastreador de misiones de Turtle WoW.
- Optimización de carga inicial de módulos XML.

---
© 2026 **DarckRovert** — El Séquito del Terror.
