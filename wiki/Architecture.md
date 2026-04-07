# 📐 Wiki: Arquitectura 'Diamond Tier' — pfUI [v9.4.0]

Estructura modular del ecosistema **El Séquito del Terror** mantenido por **DarckRovert**.

## 🏗️ Jerarquía de Carga (Boot Sequence)

El AddOn inicia mediante `modules.xml` con los siguientes puntos críticos de inyección:

1.  **Lexical Engine (`translator_dict.lua`)**: Carga los diccionarios indexados por longitud (ES-EN / EN-ES) para optimización de búsqueda.
2.  **Core Translator (`translator.lua`)**: Inyecciones en `SendChatMessage` y `ChatFrame_MessageEventHandler`.
3.  **WIM Bridge**: Hook asíncrono sobre `WIM_PostMessage` para susurros.
4.  **GUI Integration (`translator_gui.lua`)**: Registro de pestañas de configuración nativas de pfUI.

---

## 🌐 Diagrama de Flujo: Traductor Universal v2.0

```mermaid
graph TD
    A[Mensaje de Chat Event] --> B{Filtro de Canal}
    B -- Habilitado --> C[Detección de Idioma]
    B -- Deshabilitado --> Z[Render Estándar]
    C -- Inglés/Desc. --> D{Consulta Caché LRU}
    C -- Español --> Z
    D -- Cache Hit --> E[Aplicar Traducción Instantánea]
    D -- Cache Miss --> F[Motor Regex ES-EN/EN-ES]
    F --> G[Reemplazo de Word Boundary %A]
    G --> H[Almacenar en Caché 64 entradas]
    H --> E
    E --> I[Añadir Tag [TR] opcional]
    I --> J[Render en Chat Frame / WIM]
```

## ⚡ Ingeniería de Rendimiento (Performance Engineering)

Para el estándar **Diamond Tier**, hemos implementado:

- **Word Boundary Regex**: Usa `%A` para delimitar palabras y evitar colisiones de sub-strings.
- **LRU Cache (Least Recently Used)**: Sistema de desalojo automático para mantener el footprint de memoria bajo.
- **objectCount Positioning**: Garantiza que los elementos dinámicos de la interfaz no causen desbordamientos visuales ni dependencias circulares.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de software para la conquista de Azeroth.*
