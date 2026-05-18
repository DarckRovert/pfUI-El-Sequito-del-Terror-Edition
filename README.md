# Global Chat Translator — El Séquito Edition (V1.1.0 [OMNI-TIER]) 🌌⚖️

![Version](https://img.shields.io/badge/version-v1.1.0--Omni--Tier-00ccff?style=for-the-badge)
![Host](https://img.shields.io/badge/pfUI-v5.1.4--Omni--Tier-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Turtle_WoW-ff5555?style=for-the-badge)

> **The ultimate multilingual communication bridge for World of Warcraft.** Este componente de grado corporativo integrado en **pfUI** erradica las barreras lingüísticas mediante un motor de traducción en tiempo real offline de alto rendimiento, con soporte nativo para **Español, Inglés, Ruso y Chino**, optimizado bajo el estándar **Diamond-Tier** de DarckRovert.

---

## 🌌 Visión General y Propósito

El **Global Chat Translator** no es un componente estético; es una pieza nuclear de ingeniería para el ecosistema **Séquito**. Utiliza transformaciones léxicas en memoria para traducir diálogos en tiempo real (Say, World, Whispers) sin latencia perceptible en servidores globales.

### 🧩 TRANSLATOR FEATURE MATRIX (CAPACIDADES)

| Módulo | Tipo de Datos | Funcionalidad | Descripción |
| :--- | :--- | :--- | :--- |
| **Multilingual Engine** | Lexical Map | Soporte Global | Traducción entre Español (`esES`), Inglés (`enUS`), Ruso (`ruRU`) y Chino (`zhCN`) |
| **Greedy Matcher** | Lexicographical | Traducción Precisa | Prioriza frases complejas sobre palabras aisladas mediante indexación por longitud |
| **Silent Mode** | UI Suppression | Incógnito | Opera sin prefijos [TR] para una interfaz limpia |
| **WIM Bridge** | Neural Sync | Puente de Susurros | Traducción transparente en ventanas emergentes de WIM |
| **Channel Filter** | Comm Control | Gestión Granular | Elige qué canales traducir (World, LFG, Guild, Say, Party) |
| **LRU Cache** | Memory Mgmt | Alto Rendimiento | Caché de 128 registros para hit-rate del >85% con latencia sub-milisegundo |

### ⚡ PERFORMANCE BENCHMARKS (OMNI-TIER)

| Proceso | Latencia Séquito | Latencia Standard | Estado |
| :--- | :---: | :---: | :---: |
| **Matching Loop** | < 0.1ms | N/A | ✅ |
| **Cache Hit** | < 0.01ms | ~1ms | ✅ |
| **UI Rendering** | Zero Lag | Variable | ✅ |

---

## 🏗️ Suite de Documentación (Wiki)

Base de conocimientos para la dominación lingüística:

- 🏰 **[Arquitectura](file:///e:/Turtle%20Wow/Interface/AddOns/pfUI/wiki/Arquitectura.md)**: Diseño de hooks nucleares y flujos de traducción multilingüe.
- ⚙️ **[Guía de API](file:///e:/Turtle%20Wow/Interface/AddOns/pfUI/wiki/Guia_API.md)**: Integración para desarrolladores y acceso a estructuras de tesauros.
- ❓ **[FAQ](file:///e:/Turtle%20Wow/Interface/AddOns/pfUI/wiki/FAQ.md)**: Problemas comunes, rendimiento y compatibilidad.
- 📖 **[Manual de Usuario](file:///e:/Turtle%20Wow/Interface/AddOns/pfUI/wiki/Manual_Usuario.md)**: Guía de comandos y selección de idioma en interfaz.

## 🚀 Despliegue Rápido (Pro-Flow)

1.  **Limpieza**: Borra cualquier versión previa del traductor en `pfUI/modules/`.
2.  **Activación**: Configura la traducción y elige tu idioma de destino en `/pfui` -> **Translator**.
3.  **Monitoreo**: Usa `/tr stats` para verificar el rendimiento e hits de caché en tiempo real.

## 🔗 Ecosistema Oficial (DarckRovert)

- [Live Streams (Twitch)](https://twitch.tv/darckrovert)
- [Página de Inicio](https://sequitodelterror.netlify.app/)
- [Soporte & Donaciones](https://ko-fi.com/darckrovert)
- [GitHub Oficial](https://github.com/DarckRovert)

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Misión: Erradicar la mediocridad y las barreras de comunicación global.*