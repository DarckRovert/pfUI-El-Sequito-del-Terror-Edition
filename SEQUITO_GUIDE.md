# pfUI — Guía Séquito del Terror Edition

## Descripción

Esta es la versión **"El Séquito del Terror Edition"** de pfUI, un reemplazo completo de la UI de World of Warcraft 1.12. Mantiene toda la funcionalidad original de pfUI y añade integración exclusiva con el ecosistema de addons del Séquito.

## Paleta de Colores

| Elemento | Color | Hex |
|---|---|---|
| Bordes / Tabs Activas | Warlock Purple | `#9482C9` |
| Títulos / Acciones | Fel Green | `#00FF80` |
| Fondo Principal | Deep Void | `#0A050F` |

## Botón "ABRIR EL CEREBRO"

El módulo `modules/sequito.lua` añade un botón en el menú principal de pfUI:

```
/sequito brain   — Abre el panel WCS_Brain
/sequito meter   — Abre TerrorMeter
/sequito squad   — Abre TerrorSquadAI
```

El botón azul "ABRIR EL CEREBRO" en el menú de pfUI abre directamente el panel principal de WCS_Brain (14 tabs).

## Módulos Integrados

- **WCS_Brain** → Cerebro del clan (14 tabs: DQN, Perfiles, Banco, etc.)
- **TerrorMeter** → Medidor de daño/sanación con tema Séquito
- **TerrorSquadAI** → IA táctica de escuadrón
- **Atlas-TW** → Mapas de mazmorra con skin pfUI
- **HealBot** → Panel de sanación con localización española

## Personalización

El archivo `modules/sequito.lua` contiene:
- `SEQUITO_ARSENAL` — lista de todos los addons del clan
- Función `OpenBrainPanel()` — hook al WCS_Brain
- Integración con `pfUI_config` para tema visual

## Changelog
Ver [CHANGELOG.md](./CHANGELOG.md)
