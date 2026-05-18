# ❓ FAQ — Preguntas Frecuentes

## 1. ¿El traductor causa lag en el juego?
**No.** El motor está optimizado con una caché LRU de alto rendimiento y una indexación Greedy por longitud de string. Las traducciones se procesan en microsegundos (<0.1ms).

## 2. ¿Qué idiomas soporta la versión v1.1.0?
Soporta de manera bidireccional y en tiempo real **Español, Inglés, Ruso y Chino Simplificado**. El motor se encarga del mapeo de fuentes y caracteres (como cirílicos y glifos CJK) automáticamente.

## 3. ¿Por qué algunos mensajes aparecen con [TR]?
El tag `[TR]` es un indicador visual de que el mensaje que estás viendo ha sido procesado por el motor. Puedes desactivarlo activando el **Silent Mode** en la configuración de `/pfui` -> Traductor.

## 4. ¿Funciona con WIM (Whisper IM)?
**Sí.** Esta edición incluye un puente específico (`WIM Bridge`) que traduce los susurros tanto en la ventana de chat normal como en las ventanas emergentes de WIM.

## 5. ¿Por qué algunas palabras no se traducen?
El motor utiliza un filtro de seguridad. Si el mensaje es demasiado corto (<3 caracteres) o si el detector de idioma devuelve `unknown` (mezcla excesiva de caracteres o símbolos incomprensibles), el motor prefiere no traducir para evitar errores de contexto.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soporte Técnico Diamond-Tier.*
