# 📖 Manual de Usuario

Guía oficial para dominar el sistema de comunicación multilingüe de **El Séquito Edition**.

## 1. Configuración Inicial
Accede al panel de control escribiendo `/pfui` y navegando a la pestaña **Translator** (Traductor).

### Opciones de Configuración
- **Enable Translator**: Activa o desactiva por completo el motor de traducción.
- **Translate Incoming**: Habilita la traducción en tiempo real de los mensajes que recibes de otros jugadores.
- **Translate Outgoing**: Traduce automáticamente los mensajes que tú escribes al idioma del servidor antes de enviarlos.
- **Silent Mode**: Si está activo, oculta el tag `[TR]` al final de los mensajes traducidos para tener un chat visualmente más limpio.
- **WIM Bridge**: Habilita la traducción transparente en las ventanas de chat de susurros de WIM.

---

## 2. Prevención Activa contra la Mezcla de Idiomas (CTR)
El motor de la v5.0.0 incluye **Séquito Intelligence** para prevenir textos incomprensibles. Si el diccionario offline no logra traducir la mayor parte de un mensaje (ej: menos del 50% de caracteres chinos en una frase, o menos del 40% de palabras en inglés), la traducción parcial se descarta automáticamente.
* **Resultado**: Verás el texto original limpio en lugar de una mezcla molesta ("Spanglish" o "Chinol" rota).

---

## 3. Comandos de Chat
Puedes usar el comando raíz `/tr` en el chat del juego:
- `/tr`: Abre directamente la ventana de configuración del traductor en la interfaz de pfUI.
- `/tr stats`: Muestra estadísticas de telemetría: mensajes procesados, hit rate de caché y servidor detectado.
- `/tr reset`: Reinicia la detección automática del idioma del reino si la heurística ha quedado atascada.
- `/tr debug`: Alterna el modo debug de forma instantánea desde el chat (sin abrir la GUI).

---

## 4. Gestión Granular de Canales
Puedes activar o desactivar selectivamente qué canales de chat deseas traducir:
- **Decir (Say)**: Para interacción local en el mundo de juego.
- **Grupo (Party) / Banda (Raid)**: Ideal para coordinar mazmorras y bandas internacionales.
- **Hermandad (Guild)**: Mantiene la comunicación fluida con tus compañeros de hermandad.
- **Mundo (World) / LFG**: Altamente recomendado para el chat global y comercial de Turtle WoW.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Soberanía del Usuario Colossal-Tier.*
