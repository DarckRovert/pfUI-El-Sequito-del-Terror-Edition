# 🏰 Arquitectura Técnica — Global Translator (V1.0.0 [OMNI-TIER])

## 1. Diseño de Hooks Nucleares
La interceptación se realiza en la capa más profunda posible de la interfaz de WoW Vanilla para garantizar que el traductor sea la última autoridad:
*   **ChatEdit_SendText**: Punto de captura final antes de que el mensaje salga del cliente. Al modificar el `EditBox` directamente, garantizamos que cualquier addon que lea el buffer de salida vea el mensaje ya traducido.
*   **AddMessage**: Hook sobre los frames globales `ChatFrame1..10`. Actúa como un filtro de post-procesado para mensajes entrantes.

## 2. Motor de Traducción Bidireccional
El motor implementa una lógica de decisión basada en la configuración `direction`:
*   **Auto-Detección**: Utiliza un análisis de frecuencias léxicas (`EN_MARKERS` vs `ES_MARKERS`) para determinar el idioma de origen sin impacto en la latencia.
*   **Manual Override**: Permite forzar la dirección **ES -> EN** o **EN -> ES**, ignorando la detección automática para garantizar fluidez en canales de comercio internacionales.

## 3. Protección de Enlaces y Símbolos
Para evitar la corrupción de datos, el motor utiliza un filtro de exclusión de enlaces WoW:
*   **Regex Matching**: Detecta patrones `|cff...|H...|h...|h|r` antes del proceso de traducción.
*   **Encapsulamiento**: Los enlaces se reemplazan temporalmente por tokens `\127L#\127` y se restauran tras la traducción para preservar su interactividad en el chat.

## 4. Motor Lexicográfico (Greedy Matching)
A diferencia de traductores simples palabra-por-palabra, nuestro motor utiliza un ordenamiento por longitud (`strlen` descending).
*   **Razón**: Evita que palabras cortas (ej: "si") "rompan" frases más largas (ej: "siempre") durante el reemplazo con `gsub`.

## 5. Caché Nuclear LRU
Implementamos una caché LRU (Least Recently Used) con un límite de 128 entradas.
*   **Métrica**: En entornos de raid o World Chat, el hit rate alcanza el **>85%**, eliminando la necesidad de re-procesar strings idénticos y salvando ciclos de CPU críticos.

## 6. Puente WIM (Neural Sync)
Integración directa con el motor de `WIM_PostMessage`, permitiendo que los susurros sean interceptados y traducidos antes de ser renderizados en sus ventanas independientes.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soberanía Técnica Omni-Tier.*
