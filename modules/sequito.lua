pfUI:RegisterModule("sequito", "vanilla:tbc:wotlk", function ()
  local T = pfUI.env.T
  local L = pfUI.env.L
  local C = pfUI.env.C

  -- Branding Colors
  local color_sequito = "00ccff"
  local color_pink = "ff00cc"
  -- Séquito Translations (Lua 5.0 Compatible)
  local locale = GetLocale()
  local SL = {
    ["enUS"] = {
      ["WELCOME"] = "pfUI v%s-Terror detected. Elnazzareno welcomes you to the tactical ecosystem.",
      ["BRAIN_MISSING"] = "|cffff4444[ALERT]|r: WCS_Brain not detected. The abyssal core is missing.",
      ["ARSENAL_HEADER"] = "THE ARSENAL OF THE SEQUITO",
      ["LORE_HEADER"] = "LORE OF THE SHIRTLESS",
      ["LORE_TEXT"] = "Born from cheese. Forged in revenge. Written shirtless.",
      ["STATUS_ACTIVE"] = "|cff00ff00[ACTIVE]|r",
      ["STATUS_MISSING"] = "|cffff4444[MISSING]|r",
      ["CLAN_TAB"] = "Séquito del Terror",
    },
    ["esES"] = {
      ["WELCOME"] = "pfUI v%s-Terror detectado. Elnazzareno te da la bienvenida al ecosistema táctico.",
      ["BRAIN_MISSING"] = "|cffff4444[ALERTA]|r: WCS_Brain no detectado. El núcleo abismal está ausente.",
      ["ARSENAL_HEADER"] = "EL ARSENAL DEL SEQUITO",
      ["LORE_HEADER"] = "LORE DEL DESCAMISADO",
      ["LORE_TEXT"] = "Nacido del queso. Forjado en la venganza. Escrito sin camisa.",
      ["STATUS_ACTIVE"] = "|cff00ff00[ACTIVO]|r",
      ["STATUS_MISSING"] = "|cffff4444[AUSENTE]|r",
      ["CLAN_TAB"] = "Séquito del Terror",
    },
  }
  -- Fallback to enUS for everything else
  local ST = SL[locale] or SL["esES"] or SL["enUS"]
  if locale == "esMX" then ST = SL["esES"] end

  -- Welcome Message
  local welcome = CreateFrame("Frame")
  welcome:RegisterEvent("PLAYER_ENTERING_WORLD")
  welcome:SetScript("OnEvent", function()
    this:UnregisterEvent("PLAYER_ENTERING_WORLD")
    local ver = GetAddOnMetadata(pfUI.name, "Version") or "9.3.0-Terror"
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. color_sequito .. "[Séquito del Terror]|r: |cffffffff" .. string.format(ST["WELCOME"], ver) .. "|r")
    
    if not IsAddOnLoaded("WCS_Brain") then
      DEFAULT_CHAT_FRAME:AddMessage(ST["BRAIN_MISSING"])
    end
  end)

  -- Slash Command /sequito
  SLASH_SEQUITO1 = "/sequito"
  SlashCmdList["SEQUITO"] = function(msg)
    if not pfUI.gui:IsShown() then
      pfUI.gui:Show()
    end
    
    if pfUI.gui.frames and pfUI.gui.frames[ST["CLAN_TAB"]] then
      pfUI.gui.frames[ST["CLAN_TAB"]]:Click()
    end
  end

  -- GUI Integration
  pfUI.gui.CreateGUIEntry(ST["CLAN_TAB"], nil, function()
    pfUI.gui.CreateConfig(nil, "|cff" .. color_pink .. ST["ARSENAL_HEADER"] .. "|r", "header")
    
    local arsenal = {
      { name = "WCS_Brain", label = "WCS_Brain" },
      { name = "WCS_BrainIntegrations", label = "WCS_Integrations" },
      { name = "DoTimer", label = "DoTimer" },
      { name = "BigWigs", label = "BigWigs" },
      { name = "TerrorSquadAI", label = "TerrorSquadAI" },
      { name = "TerrorMeter", label = "TerrorMeter" },
      { name = "Atlas-TW", label = "Atlas-TW" },
      { name = "aux-addon", label = "AUX-Trading" },
      { name = "HealBot", label = "HealBot" },
      { name = "pfQuest", label = "pfQuest Séquito" },
      { name = "SuperWoW", label = "SuperWoW (DLL)", check = function() return GetSuperWoWVersion ~= nil end },
    }

    for i, addon in ipairs(arsenal) do
      local loaded = false
      if addon.check then
        loaded = addon.check()
      else
        loaded = IsAddOnLoaded(addon.name)
      end
      
      local status = loaded and ST["STATUS_ACTIVE"] or ST["STATUS_MISSING"]
      pfUI.gui.CreateConfig(nil, addon.label .. " " .. status, "header")
    end

    pfUI.gui.CreateConfig(nil, " ", "header")
    -- Botón Abrir Cerebro
    local openBrain = CreateFrame("Button", nil, pfUI.gui.ScrollChild)
    openBrain:SetWidth(200)
    openBrain:SetHeight(25)
    openBrain:SetText("|cff00ccffABRIR EL CEREBRO (v9.3.0)|r")
    openBrain:SetNormalFontObject(GameFontNormalSmall)
    pfUI.api.CreateBackdrop(openBrain)
    openBrain:SetScript("OnClick", function()
      if WCS_BrainUI and WCS_BrainUI.Toggle then
        WCS_BrainUI:Toggle()
      end
    end)
    pfUI.gui.ConfigToAdd(openBrain)

    pfUI.gui.CreateConfig(nil, " ", "header")
    pfUI.gui.CreateConfig(nil, "|cff" .. color_sequito .. ST["LORE_HEADER"] .. "|r", "header")
    pfUI.gui.CreateConfig(nil, ST["LORE_TEXT"], "header")
    
    pfUI.gui.CreateConfig(nil, " ", "header")
    pfUI.gui.CreateConfig(nil, "|cff00ccffDiscord:|r |cffffffffdiscord.gg/SfY8vfFWTC|r", "header")
  end)
end)
