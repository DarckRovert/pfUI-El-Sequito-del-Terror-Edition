# ðŸ“ Wiki: Arquitectura 'Diamond Tier' â€” pfUI [v5.1.4]

Estructura modular del ecosistema **El SÃ©quito del Terror** mantenido por **DarckRovert**.

## ðŸ—ï¸ JerarquÃ­a de Carga (Boot Sequence)

El AddOn inicia mediante `modules.xml` con los siguientes puntos crÃ­ticos de inyecciÃ³n:

1.  **Lexical Engine (`translator_dict.lua`)**: Carga los diccionarios indexados por longitud (ES-EN / EN-ES) para optimizaciÃ³n de bÃºsqueda.
2.  **Core Translator (`translator.lua`)**: Inyecciones en `SendChatMessage` y `ChatFrame_MessageEventHandler`.
3.  **WIM Bridge**: Hook asÃ­ncrono sobre `WIM_PostMessage` para susurros.
4.  **GUI Integration (`translator_gui.lua`)**: Registro de pestaÃ±as de configuraciÃ³n nativas de pfUI.

---

## ðŸŒ Diagrama de Flujo: Traductor Universal v2.0

```mermaid
graph TD
    A[Mensaje de Chat Event] --> B{Filtro de Canal}
    B -- Habilitado --> C[DetecciÃ³n de Idioma]
    B -- Deshabilitado --> Z[Render EstÃ¡ndar]
    C -- InglÃ©s/Desc. --> D{Consulta CachÃ© LRU}
    C -- EspaÃ±ol --> Z
    D -- Cache Hit --> E[Aplicar TraducciÃ³n InstantÃ¡nea]
    D -- Cache Miss --> F[Motor Regex ES-EN/EN-ES]
    F --> G[Reemplazo de Word Boundary %A]
    G --> H[Almacenar en CachÃ© 64 entradas]
    H --> E
    E --> I[AÃ±adir Tag [TR] opcional]
    I --> J[Render en Chat Frame / WIM]
```

## âš¡ IngenierÃ­a de Rendimiento (Performance Engineering)

Para el estÃ¡ndar **Diamond Tier**, hemos implementado:

- **Word Boundary Regex**: Usa `%A` para delimitar palabras y evitar colisiones de sub-strings.
- **LRU Cache (Least Recently Used)**: Sistema de desalojo automÃ¡tico para mantener el footprint de memoria bajo.
- **objectCount Positioning**: Garantiza que los elementos dinÃ¡micos de la interfaz no causen desbordamientos visuales ni dependencias circulares.

---
Â© 2026 **DarckRovert** â€” El SÃ©quito del Terror.
*IngenierÃ­a de software para la conquista de Azeroth.*

