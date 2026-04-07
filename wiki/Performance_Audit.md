# 📉 Wiki: Auditoría de Rendimiento — pfUI [El Séquito del Terror]

El estándar **Diamond Tier** de **DarckRovert** exige un impacto de FPS nulo en situaciones de combate intenso y alta densidad de entidades (Raid 40 y BG).

---

## ⚡ Optimizaciones de CPU (Throttling)

El motor original de pfUI procesa cientos de eventos por segundo. En la **Sequito Edition**, hemos inyectado reguladores de frecuencia en los módulos más pesados:

### 🌐 Traductor Universal v2.0
- **Caché LRU**: Almacenamiento instantáneo de strings traducidos. Reduce las operaciones Regex de `O(N*M)` a `O(1)` tras el primer encuentro.
- **Throttling de WIM**: Los susurros entrantes se procesan asíncronamente con un retardo de `1ms` para no bloquear el hilo de renderizado.

### 🛡️ Lag-Free Core (v9.4.0)
| Módulo | Frecuencia Standard | Frecuencia Séquito | Impacto en CPU |
| :--- | :---: | :---: | :---: |
| **Buscador de Misiones** | Cada Frame | 0.2s | -75% |
| **Cálculo de Rutas** | 0.1s | 0.25s | -15% |
| **Animaciones Map** | Cada Frame | 0.05s | -90% |

---

## 💾 Gestión de Memoria (Footprint)

Hemos implementado un sistema de "Silent Logging" y limpieza de basura (`collectgarbage`) controlada para evitar picos de stuttering:

1.  **Cache Cap**: El motor de traducción tiene un tope estricto de **64 entradas**. Superar este límite desencadena la expulsión de la entrada más antigua (LRU).
2.  **String Concatenation**: Se ha optimizado el uso de `..` en bucles `pairs`, sustituyéndolos por tablas temporales e `table.concat` para reducir la fragmentación de la memoria.

## 📊 Metas de FPS
Nuestro objetivo es mantener una fluctuación de **menos de 3 FPS** entre estados de reposo y combate masivo, garantizando que el HUD de **El Séquito** sea siempre el más fluido en **Turtle WoW**.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Ingeniería de software para la conquista de Azeroth.*
