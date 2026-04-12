pfUI_profiles = pfUI_profiles or {}

local apex_loader = CreateFrame("Frame")
apex_loader:RegisterEvent("VARIABLES_LOADED")
apex_loader:SetScript("OnEvent", function()
  apex_loader:UnregisterAllEvents()
  
  -- Base Modern as foundation
  local apex = pfUI.api.CopyTable(pfUI_profiles["Modern"])
  if not apex then return end

  -------------------------------------------------------------
  -- 1. LAYOUT POSICIONES (APEX v2.0: Dragonflight HUD)      --
  -------------------------------------------------------------
  apex["position"] = apex["position"] or {}
  
  -- UnitFrames Centralizados (±180x para enfoque táctico)
  apex.position["pfPlayer"] = { anchor = "BOTTOM", parent = "UIParent", xpos = -180, ypos = 260 }
  apex.position["pfTarget"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 180, ypos = 260 }
  apex.position["pfTargetTarget"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 360, ypos = 240 }
  apex.position["pfPet"] = { anchor = "BOTTOM", parent = "UIParent", xpos = -320, ypos = 240 }
  
  -- ActionBars: Agrupación en el fondo (Look Minimalista Flotante)
  apex.position["pfActionBarMain"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 45 }
  apex.position["pfActionBarBottomLeft"] = { anchor = "BOTTOM", parent = "pfActionBarMain", xpos = 0, ypos = 42 }
  apex.position["pfActionBarBottomRight"] = { anchor = "BOTTOM", parent = "pfActionBarBottomLeft", xpos = 0, ypos = 42 }
  
  -- Micro Bar & Bags (Esquina inferior derecha, horizontal)
  apex.position["pfMicroBar"] = { anchor = "BOTTOMRIGHT", parent = "UIParent", xpos = -10, ypos = 45 }
  apex.position["pfBagBar"] = { anchor = "BOTTOMRIGHT", parent = "pfMicroBar", xpos = 0, ypos = 30 }

  -- Castbars Modernas
  apex.position["pfPlayerCastbar"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 210 }
  apex.position["pfTargetCastbar"] = { anchor = "TOP", parent = "pfTarget", xpos = 0, ypos = 15 } -- Bajo el objetivo (Retail feel)
  
  -- Minimap circular
  apex.position["pfMinimap"] = { anchor = "TOPRIGHT", parent = "UIParent", xpos = -25, ypos = -25 }

  -------------------------------------------------------------
  -- 2. UNITFRAMES: ESTÉTICA RETAIL (Dragonflight Style)      --
  -------------------------------------------------------------
  apex["unitframes"] = apex["unitframes"] or {}
  apex.unitframes.disable = "0"
  apex.unitframes.pastel = "1"
  apex.unitframes.animation_speed = "5"
  apex.unitframes.all = apex.unitframes.all or {}
  apex.unitframes.all.statusbar = "img:custom\\health_df" -- Inyección de textura HD
  
  -- Player Settings
  apex.unitframes.player = apex.unitframes.player or {}
  apex.unitframes.player.width = "235"
  apex.unitframes.player.height = "56"
  apex.unitframes.player.pheight = "10" -- Poder más visible
  apex.unitframes.player.portrait = "bar"
  apex.unitframes.player.portraitalpha = "0.20"
  apex.unitframes.player.txthpright = "curmax"
  apex.unitframes.player.txthpcenter = "none"
  
  -- Target Settings
  apex.unitframes.target = apex.unitframes.target or {}
  apex.unitframes.target.width = "235"
  apex.unitframes.target.height = "56"
  apex.unitframes.target.pheight = "10"
  apex.unitframes.target.portrait = "bar"
  apex.unitframes.target.portraitalpha = "0.20"
  apex.unitframes.target.txthpleft = "curmax"
  apex.unitframes.target.txthpcenter = "none"

  -------------------------------------------------------------
  -- 3. MINIMAP: RECREACIÓN GEOMÉTRICA                        --
  -------------------------------------------------------------
  apex["appearance"] = apex["appearance"] or {}
  apex.appearance.minimap = apex.appearance.minimap or {}
  apex.appearance.minimap.size = "165"
  apex.appearance.minimap.square = "0" -- Forzamos modo circular de Dragonflight
  
  -------------------------------------------------------------
  -- 4. BARS: CONFIGURACIÓN FLOTANTE                          --
  -------------------------------------------------------------
  apex["bars"] = apex["bars"] or {}
  apex.bars.icon_size = "34"
  apex.bars.spacing = "3"
  apex.bars.background = "0" -- Quita el arte de fondo de las barras
  apex.bars.glowaction = "1"
  
  -- Microbar Horizontal
  apex.bars.micro = apex.bars.micro or {}
  apex.bars.micro.enable = "1"
  apex.bars.micro.horizontal = "1"
  
  -------------------------------------------------------------
  -- 5. GLOBALES & TIPOGRAFÍA                                 --
  -------------------------------------------------------------
  apex["global"] = apex["global"] or {}
  apex.global.font_size = "12"
  apex.global.font_unit_size = "13"
  apex.global.pixelperfect = "1"
  apex.global.offcolor = "0.05,0.05,0.05,1" -- Color de fondo más profundo
  
  pfUI_profiles["Apex"] = apex
  
  -- Registro de posiciones corregido para el Wizard
  pfUI_profiles["Apex"].new_module_positions = {
    pfPlayer = apex.position["pfPlayer"],
    pfTarget = apex.position["pfTarget"],
    pfPlayerCastbar = apex.position["pfPlayerCastbar"],
    pfTargetCastbar = apex.position["pfTargetCastbar"],
    pfActionBarMain = apex.position["pfActionBarMain"],
    pfMinimap = apex.position["pfMinimap"]
  }
end)
