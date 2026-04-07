pfUI_profiles = pfUI_profiles or {}

local apex_loader = CreateFrame("Frame")
apex_loader:RegisterEvent("VARIABLES_LOADED")
apex_loader:SetScript("OnEvent", function()
  apex_loader:UnregisterAllEvents()
  
  -- Clonamos estructura base para evitar corrupciones numéricas
  local apex = pfUI.api.CopyTable(pfUI_profiles["Modern"])
  if not apex then return end

  -------------------------------------------------------------
  -- 1. LAYOUT POSICIONES (APEX: Centralizado y Agresivo)     --
  -------------------------------------------------------------
  apex["position"] = apex["position"] or {}
  -- HUD del combate agrupado justo debajo de los pies
  apex.position["pfPlayer"] = { anchor = "BOTTOM", parent = "UIParent", xpos = -250, ypos = 280 }
  apex.position["pfTarget"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 250, ypos = 280 }
  apex.position["pfTargetTarget"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 450, ypos = 250 }
  apex.position["pfPet"] = { anchor = "BOTTOM", parent = "UIParent", xpos = -350, ypos = 280 }
  
  -- Rejilla ActionBars minimalista sin arte
  apex.position["pfActionBarMain"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 40 }
  apex.position["pfActionBarBottomLeft"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 80 }
  apex.position["pfActionBarBottomRight"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 120 }
  
  -- Casteos
  apex.position["pfPlayerCastbar"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 200 }
  apex.position["pfTargetCastbar"] = { anchor = "BOTTOM", parent = "UIParent", xpos = 0, ypos = 360 }
  apex.position["pfMinimap"] = { anchor = "TOPRIGHT", parent = "UIParent", xpos = -20, ypos = -20 }

  -------------------------------------------------------------
  -- 2. UNITFRAMES ESTÉTICA AVANZADA (Cinematografía HUD)     --
  -------------------------------------------------------------
  apex["unitframes"] = apex["unitframes"] or {}
  apex.unitframes.disable = "0"
  apex.unitframes.pastel = "1" -- Colores suaves y saturados
  apex.unitframes.animation_speed = "5" -- Smooth Health transitions !!

  -- PLAYER 
  apex.unitframes.player = apex.unitframes.player or {}
  apex.unitframes.player.width = "240"
  apex.unitframes.player.height = "55"
  apex.unitframes.player.pheight = "8"
  apex.unitframes.player.portrait = "bar" -- Modelo 3D INCRUSTADO en la barra de vida
  apex.unitframes.player.portraitalpha = "0.15" -- Holográfico ligero
  apex.unitframes.player.txthpcenter = "none"
  apex.unitframes.player.txthpright = "curmax"
  apex.unitframes.player.showtooltip = "0"
  apex.unitframes.player.invert_healthbar = "0"
  apex.unitframes.player.portraitcolor = "0"
  
  -- TARGET
  apex.unitframes.target = apex.unitframes.target or {}
  apex.unitframes.target.width = "240"
  apex.unitframes.target.height = "55"
  apex.unitframes.target.pheight = "8"
  apex.unitframes.target.portrait = "bar"
  apex.unitframes.target.portraitalpha = "0.15"
  apex.unitframes.target.animation_speed = "5"
  apex.unitframes.target.portraitcolor = "0"
  
  -------------------------------------------------------------
  -- 3. FADER / DARK GLASS (Dinámica fuera de combate)        --
  -------------------------------------------------------------
  -- Convertimos la barra izquierda y las posturas a opacos en combate
  apex["bars"] = apex["bars"] or {}
  apex.bars.icon_size = "34"
  apex.bars.spacing = "2"
  apex.bars.background = "0"
  apex.bars.glowaction = "1" 
  apex.bars.right = apex.bars.right or {}
  apex.bars.right.autohide = "0"
  apex.bars.pet = apex.bars.pet or {}
  apex.bars.pet.autohide = "0"
  apex.bars.shapeshift = apex.bars.shapeshift or {}
  apex.bars.shapeshift.autohide = "0"

  -------------------------------------------------------------
  -- 4. ESTÁNDARES TIPOGRÁFICOS Y GRÁFICOS                    --
  -------------------------------------------------------------
  apex["global"] = apex["global"] or {}
  apex.global.font_unit_size = "13"
  apex.global.pixelperfect = "1" -- Bordes limpios de cristal negro
  apex.global.offcolor = "0.1,0.1,0.1,1" -- Sombras profundas
  apex.global.shadow = "1"
  apex.global.errors_limit = "1" -- Quita el spam de errores rojos ("Fuera de rango")
  
  apex["tooltip"] = apex["tooltip"] or {}
  apex.tooltip.alpha = "0.85" -- Glass tooltip
  
  apex["nameplates"] = apex["nameplates"] or {}
  apex.nameplates.use_target = "1"
  apex.nameplates.overlap = "0"

  pfUI_profiles["Apex"] = apex
  
  pfUI_profiles["Apex"].new_module_positions = {
    pfPlayer = apex.position["pfPlayer"],
    pfTarget = apex.position["pfTarget"],
    pfPlayerCastbar = apex.position["pfPlayerCastbar"],
    pfTargetCastbar = apex.position["pfTargetCastbar"],
    pfActionBarMain = apex.position["pfActionBarMain"]
  }
end)
