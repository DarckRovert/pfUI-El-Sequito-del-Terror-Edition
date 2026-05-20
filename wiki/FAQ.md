# ❓ FAQ — Preguntas Frecuentes

## 1. ¿El traductor causa lag o tirones en el juego al tener tantos miles de palabras?
**No.** El motor está optimizado bajo estándares **Ultimate-Tier (v6.8.0)**. A diferencia de las versiones anteriores que realizaban búsquedas lineales lentas, la v6.8.0 implementa el **Motor de Búsqueda Token-Bucket**. Este sistema filtra de forma instantánea las claves candidatas basándose únicamente en las palabras iniciales presentes en el mensaje recibido. Combinado con una caché LRU extendida de **1024 registros** y carga estática reutilizable (GC-Friendly), las traducciones toman microsegundos (<0.1ms) sin afectar los FPS ni causar tirones.

## 2. ¿Qué idiomas soporta la versión v6.8.0?
Soporta de manera bidireccional y en tiempo real **Español, Inglés y Chino**. Cuenta con un motor de normalización automática de glifos CJK gracias a su base léxica de 200 categorías generales e inyección comprimida en lote de miles de misiones, ítems custom, talentos, PvP y habilidades de clase clásicos y de Turtle WoW.

## 3. ¿Por qué el traductor a veces no traduce frases de chat y muestra el original?
Esto se debe al **Filtro de Ratio de Coherencia (CTR)**. Para idiomas occidentales, si una frase no se puede traducir en su mayoría (menos del 40%), se descarta. Sin embargo, para Chino, a partir de la v4.2.3, el umbral es del **10%**, lo que significa que el addon hará un esfuerzo heurístico agresivo y **SÍ** mostrará mezclas de idiomas si solo reconoce algunas palabras, priorizando siempre mostrar la mayor cantidad de información traducible posible.

## 4. ¿Soporta la jerga táctica, profesiones y BGs?
**Sí.** La v6.8.0 implementa cobertura absoluta para:
*   **Campos de Batalla (BGs)**: Warsong Gulch (WSG), Arathi Basin (AB), Alterac Valley (AV), cementerios, banderas y objetivos de mapa.
*   **Profesiones e interacciones**: Primarias, secundarias y la profesión custom de *Supervivencia (Survival)*, especialidades y recetas.
*   **Talentos y Atributos**: Fuerza, agilidad, índice de golpe, crítico, poder con hechizos y especializaciones (*Furia, Combate Feral, Restauración, etc.*).

## 5. ¿El traductor puede corromper o traducir mi nombre de jugador o el canal?
La v6.8.0 utiliza **Aislamiento Sintáctico**. Antes de enviar el texto al traductor, el motor extrae el canal, los colores de Blizzard y el nombre del jugador, aplicando la base léxica únicamente sobre el cuerpo real del mensaje. Tu nombre, colores e interactividad (hacer click en el nombre del jugador) se mantienen 100% protegidos.

## 6. ¿Por qué algunos mensajes aparecen con [TR]?
El tag `[TR]` es un indicador visual de que el mensaje que estás viendo ha sido traducido localmente. Puedes desactivarlo activando el **Silent Mode** en la configuración de `/pfui` -> **Translator**.

## 7. ¿Funciona con WIM (Whisper IM)?
**Sí.** Esta edición incluye un puente específico (`WIM Bridge`) que intercepta de forma bilateral los susurros tanto en el chat por defecto de WoW como en las ventanas emergentes de WIM de manera asíncrona y segura.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soporte Técnico Ultimate-Tier.*
