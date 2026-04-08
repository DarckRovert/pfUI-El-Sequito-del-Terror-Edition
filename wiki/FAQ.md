# ❓ FAQ — Preguntas Frecuentes

## 1. ¿El traductor causa lag en el juego?
**No.** El motor está optimizado con una caché LRU de alto rendimiento. Las traducciones se procesan en microsegundos (<0.1ms). El lag que algunos usuarios reportan al abrir el mapa suele estar vinculado al módulo de coordenadas nativo de pfUI, no al traductor.

## 2. ¿Por qué algunos mensajes aparecen con [TR]?
El tag `[TR]` es un indicador visual de que el mensaje que estás viendo ha sido procesado por el motor. Puedes desactivarlo activando el **Silent Mode** en la configuración de `/pfui` -> Traductor.

## 3. ¿Funciona con WIM (Whisper IM)?
**Sí.** Esta edición incluye un puente específico (`WIM Bridge`) que traduce los susurros tanto en la ventana de chat normal como en las ventanas emergentes de WIM.

## 4. ¿Por qué algunas palabras no se traducen?
El motor utiliza un filtro de seguridad. Si el mensaje es demasiado corto (<3 caracteres) o si el detector de idioma devuelve `unknown` (mezcla excesiva de idiomas), el motor prefiere no traducir para evitar errores de contexto.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soporte Técnico Diamond-Tier.*
