pfUI:RegisterModule("translator_gui", "vanilla", function ()
  -- ============================================================
  -- PANEL DE CONFIGURACIÓN — Traductor Universal v2.0
  -- Séquito del Terror Edition
  -- ============================================================

  local C = pfUI_config
  if not C.translator then C.translator = {} end

  local function pad(n) return string.rep(" ", n or 2) end

  pfUI.gui.CreateGUIEntry("Traductor", "General", function()
    pfUI.gui.CreateConfig(nil, "|cff00ccffTraductor Universal v2.0|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "Motor offline EN ↔ ES para canales de chat y WIM.", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")

    pfUI.gui.CreateConfig(nil, "|cffffd700Control Global|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "Habilitar Traductor",
      C.translator, "enable", "checkbox",
      function() pfUI_config.translator.enable = pfUI_config.translator.enable end)

    pfUI.gui.CreateConfig(nil, "Traducir mensajes que RECIBES (EN→ES)",
      C.translator, "incoming", "checkbox",
      function() pfUI_config.translator.incoming = pfUI_config.translator.incoming end)

    pfUI.gui.CreateConfig(nil, "Traducir mensajes que ENVÍAS (ES→EN)",
      C.translator, "outgoing", "checkbox",
      function() pfUI_config.translator.outgoing = pfUI_config.translator.outgoing end)

    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "|cffffd700Opciones de Visualización|r", nil, nil, "header")

    pfUI.gui.CreateConfig(nil, "Mostrar marca [TR] en mensajes traducidos",
      C.translator, "show_tag", "checkbox",
      function() pfUI_config.translator.show_tag = pfUI_config.translator.show_tag end)

    pfUI.gui.CreateConfig(nil, "Modo Silencioso (no mostrar eco de salida en tu chat)",
      C.translator, "silent_mode", "checkbox",
      function() pfUI_config.translator.silent_mode = pfUI_config.translator.silent_mode end)

    pfUI.gui.CreateConfig(nil, "Color del tag [TR] (hex sin #)",
      C.translator, "tag_color", "text")

    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "|cffffd700Canales Activos|r", nil, nil, "header")

    pfUI.gui.CreateConfig(nil, "Susurros (Whisper)",
      C.translator, "ch_whisper", "checkbox", nil)
    pfUI.gui.CreateConfig(nil, "Canal General / Mundo (Channel)",
      C.translator, "ch_channel", "checkbox", nil)
    pfUI.gui.CreateConfig(nil, "Decir (Say)",
      C.translator, "ch_say", "checkbox", nil)
    pfUI.gui.CreateConfig(nil, "Gritar (Yell)",
      C.translator, "ch_yell", "checkbox", nil)
    pfUI.gui.CreateConfig(nil, "Grupo (Party)",
      C.translator, "ch_party", "checkbox", nil)
    pfUI.gui.CreateConfig(nil, "Banda (Raid)",
      C.translator, "ch_raid", "checkbox", nil)
    pfUI.gui.CreateConfig(nil, "Hermandad (Guild)",
      C.translator, "ch_guild", "checkbox", nil)
  end)

  pfUI.gui.CreateGUIEntry("Traductor", "Puente WIM", function()
    pfUI.gui.CreateConfig(nil, "|cff00ccffPuente WIM (WoW Instant Messenger)|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "Traduce susurros en ventanas flotantes de WIM.", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")

    pfUI.gui.CreateConfig(nil, "Activar Puente WIM",
      C.translator, "wim_bridge", "checkbox",
      function()
        if pfUI_config.translator.wim_bridge == "1" then
          -- Intentar enganchar WIM si ya está cargado
          if WIM_PostMessage and not pfUI.GravityWIMHooked and pfUI.Translate then
            -- El hook se re-aplica en el siguiente reload
            DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r Puente WIM: Recarga la UI para aplicar.")
          end
        end
      end)

    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")
    if IsAddOnLoaded("WIM") then
      pfUI.gui.CreateConfig(nil, "|cff33ffcc✓ WIM detectado y cargado.|r", nil, nil, "header")
    else
      pfUI.gui.CreateConfig(nil, "|cffff5555✗ WIM no encontrado. Instala WIM para usar este puente.|r", nil, nil, "header")
    end

    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "|cffffd700Cómo Funciona|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "1. Un jugador te susurra en inglés.", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "2. La ventana WIM muestra el texto en español.", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "3. Respondes en español → WIM envía en inglés.", nil, nil, "header")
  end)

  pfUI.gui.CreateGUIEntry("Traductor", "Estadísticas", function()
    local stats = pfUI.translator_stats or { total_in = 0, total_out = 0, cache_hits = 0 }

    pfUI.gui.CreateConfig(nil, "|cff00ccffEstadísticas de Sesión|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")

    pfUI.gui.CreateConfig(nil, "Mensajes entrantes traducidos: |cff33ffcc" .. (stats.total_in or 0) .. "|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "Mensajes salientes traducidos: |cff33ffcc" .. (stats.total_out or 0) .. "|r", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "Cache hits (traducciones rápidas): |cff33ffcc" .. (stats.cache_hits or 0) .. "|r", nil, nil, "header")

    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "|cffffd700Estado del Sistema|r", nil, nil, "header")

    local dicts = pfUI.translator_dicts
    if dicts and dicts.esES_enUS then
      local count = 0
      for _ in pairs(dicts.esES_enUS) do count = count + 1 end
      pfUI.gui.CreateConfig(nil, "Diccionario ES→EN: |cff33ffcc" .. count .. " entradas|r", nil, nil, "header")
    else
      pfUI.gui.CreateConfig(nil, "Diccionario ES→EN: |cffff5555No cargado|r", nil, nil, "header")
    end

    if dicts and dicts.enUS_esES then
      local count = 0
      for _ in pairs(dicts.enUS_esES) do count = count + 1 end
      pfUI.gui.CreateConfig(nil, "Diccionario EN→ES: |cff33ffcc" .. count .. " entradas|r", nil, nil, "header")
    else
      pfUI.gui.CreateConfig(nil, "Diccionario EN→ES: |cffff5555No cargado|r", nil, nil, "header")
    end

    pfUI.gui.CreateConfig(nil, "WIM Bridge: " .. (pfUI.GravityWIMHooked and "|cff33ffccActivo|r" or "|cffaaaaaa Inactivo|r"), nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "Chat Hook: " .. (pfUI.GravityTRHooked and "|cff33ffccActivo|r" or "|cffaaaaaa Inactivo|r"), nil, nil, "header")

    pfUI.gui.CreateConfig(nil, " ", nil, nil, "header")
    pfUI.gui.CreateConfig(nil, "|cff888888Comandos: /tr on | off | stats | reset | test|r", nil, nil, "header")
  end)

end)
