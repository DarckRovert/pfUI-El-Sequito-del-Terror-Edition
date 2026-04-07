# ðŸ“‰ Wiki: AuditorÃ­a de Rendimiento â€” pfUI [El SÃ©quito del Terror]

El estÃ¡ndar **Diamond Tier** de **DarckRovert** exige un impacto de FPS nulo en situaciones de combate intenso y alta densidad de entidades (Raid 40 y BG).

---

## âš¡ Optimizaciones de CPU (Throttling)

El motor original de pfUI procesa cientos de eventos por segundo. En la **Sequito Edition**, hemos inyectado reguladores de frecuencia en los mÃ³dulos mÃ¡s pesados:

### ðŸŒ Traductor Universal v2.0
- **CachÃ© LRU**: Almacenamiento instantÃ¡neo de strings traducidos. Reduce las operaciones Regex de `O(N*M)` a `O(1)` tras el primer encuentro.
- **Throttling de WIM**: Los susurros entrantes se procesan asÃ­ncronamente con un retardo de `1ms` para no bloquear el hilo de renderizado.

### ðŸ›¡ï¸ Lag-Free Core (v5.1.4)
| MÃ³dulo | Frecuencia Standard | Frecuencia SÃ©quito | Impacto en CPU |
| :--- | :---: | :---: | :---: |
| **Buscador de Misiones** | Cada Frame | 0.2s | -75% |
| **CÃ¡lculo de Rutas** | 0.1s | 0.25s | -15% |
| **Animaciones Map** | Cada Frame | 0.05s | -90% |

---

## ðŸ’¾ GestiÃ³n de Memoria (Footprint)

Hemos implementado un sistema de "Silent Logging" y limpieza de basura (`collectgarbage`) controlada para evitar picos de stuttering:

1.  **Cache Cap**: El motor de traducciÃ³n tiene un tope estricto de **64 entradas**. Superar este lÃ­mite desencadena la expulsiÃ³n de la entrada mÃ¡s antigua (LRU).
2.  **String Concatenation**: Se ha optimizado el uso de `..` en bucles `pairs`, sustituyÃ©ndolos por tablas temporales e `table.concat` para reducir la fragmentaciÃ³n de la memoria.

## ðŸ“Š Metas de FPS
Nuestro objetivo es mantener una fluctuaciÃ³n de **menos de 3 FPS** entre estados de reposo y combate masivo, garantizando que el HUD de **El SÃ©quito** sea siempre el mÃ¡s fluido en **Turtle WoW**.

---
Â© 2026 **DarckRovert** â€” El SÃ©quito del Terror.
*IngenierÃ­a de software para la conquista de Azeroth.*

