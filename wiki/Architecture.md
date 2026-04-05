# Arquitectura — pfUI Sequito Edition

mermaid
graph TD
    CORE[pfUI Core]
    SEQUITO[Sequito Skin Module]
    WCS_BRIDGE[WCS_Brain Integration]
    SKINS[UI Modules / Skins]

    CORE --> SKINS
    SEQUITO --> SKINS
    WCS_BRIDGE --> CORE
    WCS_BRIDGE --> SEQUITO


## Componentes
- **init/**: Puntos de anclaje para perfiles personalizados.
- **skins/**: Librería de texturas y bordes Sequito Edition.
- **modules/sequito/**: Puente de comunicación con el WCS_Brain.
