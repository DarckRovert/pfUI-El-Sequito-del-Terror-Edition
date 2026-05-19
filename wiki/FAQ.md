# ❓ FAQ — Preguntas Frecuentes

## 1. ¿El traductor causa lag o tirones en el juego?
**No.** El motor está optimizado bajo estándares Diamond-Tier. Utiliza una caché LRU extendida de **1024 registros** de alto rendimiento y una indexación Greedy en Lua 5.0. Las traducciones se procesan en microsegundos (<0.1ms) sin afectar los FPS del cliente de WoW Vanilla.

## 2. ¿Qué idiomas soporta la versión v4.2.0?
Soporta de manera bidireccional y en tiempo real **Español, Inglés y Chino**. El motor realiza la normalización y traducción de caracteres y glifos CJK automáticamente gracias a su base léxica offline de 130 categorías.

## 3. ¿Por qué el traductor a veces no traduce frases de chat y muestra el original?
Esto se debe al **Filtro de Ratio de Coherencia (CTR)** implementado en la v4.2.0. Si una frase no se puede traducir en su mayoría (menos del 50% en chino o 40% en inglés), el motor descarta el cambio parcial para evitar que veas una mezcla incomprensible de idiomas ("Spanglish" o "Chinol", como `那tú又sidónde...`). El original siempre se mostrará antes que una traducción híbrida inútil.

## 4. ¿El traductor puede corromper o traducir mi nombre de jugador o el canal?
**No.** La v4.2.0 introduce **Aislamiento Sintáctico**. Antes de enviar el texto al traductor, el motor extrae el canal, los colores de Blizzard y el nombre del jugador, aplicando la base léxica únicamente sobre el cuerpo real del mensaje. Tu nombre, colores e interactividad (hacer click en el nombre del jugador) se mantienen 100% protegidos.

## 5. ¿Por qué algunos mensajes aparecen con [TR]?
El tag `[TR]` es un indicador visual de que el mensaje que estás viendo ha sido traducido localmente. Puedes desactivarlo activando el **Silent Mode** en la configuración de `/pfui` -> **Translator**.

## 6. ¿Funciona con WIM (Whisper IM)?
**Sí.** Esta edición incluye un puente específico (`WIM Bridge`) que intercepta de forma bilateral los susurros tanto en el chat por defecto de WoW como en las ventanas emergentes de WIM.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soporte Técnico Diamond-Tier.*
