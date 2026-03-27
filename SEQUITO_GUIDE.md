# Guía de Configuración del Séquito — pfUI

## Configuración Recomendada para el Séquito del Terror

Esta guía describe la configuración óptima de pfUI para integrarse con los demás addons del ecosistema.

## Paso 1: Instalar en Orden Correcto
1. pfUI (base)
2. pfQuest (mapas de misiones)
3. WCS_Brain (hub central)
4. TerrorMeter (medidor de daño)

## Paso 2: Configuración Visual
Abre /pfui → **Colores**:

| Elemento | Color sugerido |
|---|---|
| Fondo de marcos | #0D0D0D (negro puro) |
| Bordes | #8B0000 (carmesí oscuro) |
| Texto | #FFD700 (dorado del Séquito) |
| Vida del jugador | #00CC44 (verde oscuro) |
| Maná | #0044CC (azul mágico) |

## Paso 3: Posición de Elementos
- **WCS_Brain ButtonBar**: colocar en la esquina inferior derecha.
- **TerrorMeter**: parte superior izquierda.
- **HealBot Panel**: lado derecho de la pantalla.

## Paso 4: Addons a Desactivar
Para evitar conflictos, desactiva:
- CT_MOD
- Discord Unit Frames
- Discord Action Bars
- Bongos (si está instalado)

## Paso 5: Verificación
Escribe /reload y verifica que todos los marcos carguen correctamente. Si hay errores de Lua, consulta el [FAQ de pfUI](https://github.com/shagu/pfUI).