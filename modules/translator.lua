pfUI:RegisterModule("translator", "vanilla", function ()
  -- ============================================================
  -- TRADUCTOR UNIVERSAL v1.0.0 — Omni-Tier Séquito Edition
  -- Motor Offline Bidireccional ES <-> EN con Puente WIM
  -- ============================================================

  local C = pfUI_config
  local T = pfUI_translation[GetLocale()] or pfUI_translation["enUS"]

  -- Asegurar estructura de diccionarios (Lazy Init para evitar race conditions)
  pfUI.translator_dicts = pfUI.translator_dicts or {}
  pfUI.translator_dicts.esES_enUS = pfUI.translator_dicts.esES_enUS or {}
  pfUI.translator_dicts.enUS_esES = pfUI.translator_dicts.enUS_esES or {}
  pfUI.translator_dicts.esES_keys = pfUI.translator_dicts.esES_keys or {}
  pfUI.translator_dicts.enUS_keys = pfUI.translator_dicts.enUS_keys or {}

  -- Asegurar estructura de estadísticas
  pfUI.translator_stats = pfUI.translator_stats or {
    total_in = 0,
    total_out = 0,
    cache_hits = 0,
  }

  -- Cache LRU (128 registros)
  local TR_CACHE = {}
  local TR_CACHE_ORDER = {}
  local TR_CACHE_MAX = 128

  local function CacheGet(text)
    return TR_CACHE[text]
  end

  local function CacheSet(text, result)
    if not text or TR_CACHE[text] then return end
    if table.getn(TR_CACHE_ORDER) >= TR_CACHE_MAX then
      local oldest = table.remove(TR_CACHE_ORDER, 1)
      TR_CACHE[oldest] = nil
    end
    TR_CACHE[text] = result
    table.insert(TR_CACHE_ORDER, text)
  end

  -- ============================================================
  -- MOTOR DE TRADUCCIÓN (Vanilla Lua 5.0)
  -- ============================================================
  local function LocalTranslate(text, dictionary, keyArray)
    if not text or type(text) ~= "string" or strlen(text) < 2 then return nil end
    if not dictionary or not keyArray then return nil end

    local cached = CacheGet(text)
    if cached then
      pfUI.translator_stats.cache_hits = pfUI.translator_stats.cache_hits + 1
      return cached
    end

    local links = {}
    local link_count = 0
    local proc_text = text
    proc_text = string.gsub(proc_text, "(|H.-|h.-|h)", function(link)
      link_count = link_count + 1
      links[link_count] = link
      return "\127L" .. link_count .. "\127"
    end)

    proc_text = " " .. strlower(proc_text) .. " "
    local translation_occurred = false

    for _, key in ipairs(keyArray) do
      if strfind(proc_text, key, 1, true) then
        local replace_value = dictionary[key]
        local safe_key = string.gsub(key, "(%W)", "%%%1")
        local pattern = "(%A)(" .. safe_key .. ")(%A)"
        local res_text, count = string.gsub(proc_text, pattern, "%1" .. replace_value .. "%3")
        if count > 0 then
          proc_text = res_text
          translation_occurred = true
        end
      end
    end

    if translation_occurred then
      local result = strsub(proc_text, 2, -2)
      result = string.gsub(result, "\127L(%d+)\127", function(id)
        return links[tonumber(id)]
      end)
      CacheSet(text, result)
      return result
    end
    return nil
  end

  -- ============================================================
  -- DETECTOR DE IDIOMA
  -- ============================================================
  local EN_MARKERS = { "the", "and", "you", "are", "for", "have", "with", "not", "this", "that", "but", "they", "from", "will", "what", "your" }
  local ES_MARKERS = { "que", "por", "una", "con", "los", "las", "del", "les", "como", "pero", "para", "este", "esta", "hay", "muy", "mas" }

  local function DetectLanguage(text)
    if not text then return "unknown" end
    local lower = strlower(text)
    local en_hits, es_hits = 0, 0
    for _, w in ipairs(EN_MARKERS) do
      if strfind(" " .. lower .. " ", " " .. w .. " ", 1, true) then en_hits = en_hits + 1 end
    end
    for _, w in ipairs(ES_MARKERS) do
      if strfind(" " .. lower .. " ", " " .. w .. " ", 1, true) then es_hits = es_hits + 1 end
    end
    if en_hits > es_hits and en_hits >= 1 then return "en" end
    if es_hits > en_hits and es_hits >= 1 then return "es" end
    return "unknown"
  end

  -- ============================================================
  -- SEGURIDAD DE CONFIGURACIÓN
  -- ============================================================
  local function IsChanEnabled(chatType)
    if not C.translator or C.translator.enable ~= "1" then return false end
    local lower = strlower(chatType or "")
    if lower == "say"     then return C.translator.chan_say     == "1" end
    if lower == "party"   then return C.translator.chan_raid    == "1" end
    if lower == "raid"    then return C.translator.chan_raid    == "1" end
    if lower == "guild"   then return C.translator.chan_guild   == "1" end
    if lower == "whisper" then return C.translator.chan_whisper == "1" end
    if lower == "world" or lower == "channel" then 
       return C.translator.chan_world == "1" or C.translator.chan_lfg == "1" 
    end
    return true
  end

  local function GetTRTag()
    if not C.translator or C.translator.silent_mode == "1" then return "" end
    return " |cff33ffcc[TR]|r"
  end

  -- ============================================================
  -- HOOKS DE SALIDA
  -- ============================================================
  local function TranslateOutgoing(msg, chatType, channel)
    if not msg or strsub(msg, 1, 1) == "/" or strsub(msg, 1, 1) == "." then return nil end
    if not C.translator or C.translator.enable ~= "1" or C.translator.outgoing ~= "1" then return nil end
    if not IsChanEnabled(chatType) then return nil end

    local dir = C.translator.direction or "0"
    local trans = nil

    if dir == "1" then -- ES -> EN
      trans = LocalTranslate(msg, pfUI.translator_dicts.esES_enUS, pfUI.translator_dicts.esES_keys)
    elseif dir == "2" then -- EN -> ES
      trans = LocalTranslate(msg, pfUI.translator_dicts.enUS_esES, pfUI.translator_dicts.enUS_keys)
    else -- Auto-Detect
      local lang = DetectLanguage(msg)
      if lang ~= "en" then
        trans = LocalTranslate(msg, pfUI.translator_dicts.esES_enUS, pfUI.translator_dicts.esES_keys)
      end
    end

    if trans then
      pfUI.translator_stats.total_out = pfUI.translator_stats.total_out + 1
      return trans
    end
    return nil
  end

  local function SecureHookOutgoing()
    if pfUI.GravityTROutHooked then return end
    
    local originalChatEditSend = ChatEdit_SendText
    ChatEdit_SendText = function(editBox, addHistory)
      local msg = editBox:GetText()
      if msg and msg ~= "" then
        local trans = TranslateOutgoing(msg, editBox.chatType, editBox.channelTarget)
        if trans then editBox:SetText(trans) end
      end
      return originalChatEditSend(editBox, addHistory)
    end

    local originalSendChatMessage = SendChatMessage
    SendChatMessage = function(msg, chatType, language, channel)
      local trans = TranslateOutgoing(msg, chatType, channel)
      return originalSendChatMessage(trans or msg, chatType, language, channel)
    end

    if ChatThrottleLib then
      local originalCTLSend = ChatThrottleLib.SendChatMessage
      ChatThrottleLib.SendChatMessage = function(self, prio, msg, chatType, language, channel, queue)
        local trans = TranslateOutgoing(msg, chatType, channel)
        return originalCTLSend(self, prio, trans or msg, chatType, language, channel, queue)
      end
    end

    pfUI.GravityTROutHooked = true
  end

  -- ============================================================
  -- HOOKS DE ENTRADA
  -- ============================================================
  local function HookIncomingChat()
    if pfUI.GravityTRHooked then return end
    
    local function TranslatorAddMessage(frame, text, r, g, b, id)
      if not text or type(text) ~= "string" then return frame:pfOriginalAddMessage(text, r, g, b, id) end
      
      -- SOBERANÍA HUMANA: Solo traducir si detectamos un enlace de jugador o canal
      -- Esto evita traducir NPCs, nombres de mobs y mensajes de sistema.
      if not strfind(text, "|Hplayer:") and not strfind(text, "|Hchannel:") then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      local low = strlower(text)
      if strfind(low, "error:") or strfind(low, "lua:") or strfind(low, "attempt to") then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      if C.translator and C.translator.enable == "1" then
        local lang = DetectLanguage(text)
        if lang == "en" or lang == "unknown" then
          local trans = LocalTranslate(text, pfUI.translator_dicts.enUS_esES, pfUI.translator_dicts.enUS_keys)
          if trans then
            pfUI.translator_stats.total_in = pfUI.translator_stats.total_in + 1
            text = trans .. GetTRTag()
          end
        end
      end
      return frame:pfOriginalAddMessage(text, r, g, b, id)
    end

    for i=1, 10 do
      local frame = _G["ChatFrame"..i]
      if frame and not frame.pfOriginalAddMessage then
        frame.pfOriginalAddMessage = frame.AddMessage
        frame.AddMessage = function(self, text, r, g, b, id)
          TranslatorAddMessage(self, text, r, g, b, id)
        end
      end
    end
    pfUI.GravityTRHooked = true
  end

  -- ============================================================
  -- PUENTE WIM
  -- ============================================================
  local function HookWIMBridge()
    if not WIM_PostMessage or pfUI.GravityWIMHooked then return end

    local originalWIMPost = WIM_PostMessage
    WIM_PostMessage = function(user, msg, ttype, from, raw_msg, hotkeyFix)
      if C.translator and C.translator.enable == "1" and C.translator.wim_bridge == "1" and raw_msg then
        local isEn = ttype == 1
        local dict = isEn and pfUI.translator_dicts.enUS_esES or pfUI.translator_dicts.esES_enUS
        local keys = isEn and pfUI.translator_dicts.enUS_keys or pfUI.translator_dicts.esES_keys
        
        local trans = LocalTranslate(raw_msg, dict, keys)
        if trans then
          if isEn then pfUI.translator_stats.total_in = pfUI.translator_stats.total_in + 1
          else pfUI.translator_stats.total_out = pfUI.translator_stats.total_out + 1 end
          
          local tag = GetTRTag()
          local escaped = string.gsub(raw_msg, "(%W)", "%%%1")
          msg = string.gsub(msg, escaped, trans .. tag)
          raw_msg = trans
        end
      end
      return originalWIMPost(user, msg, ttype, from, raw_msg, hotkeyFix)
    end
    pfUI.GravityWIMHooked = true
  end

  -- ============================================================
  -- INICIALIZACIÓN
  -- ============================================================
  local initFrame = CreateFrame("Frame")
  initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  initFrame:RegisterEvent("ADDON_LOADED")
  initFrame:SetScript("OnEvent", function()
    local event = event or ""
    local arg1 = arg1 or ""
    if event == "PLAYER_ENTERING_WORLD" then
      initFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
      pcall(SecureHookOutgoing)
      pcall(HookIncomingChat)
      if IsAddOnLoaded("WIM") then pcall(HookWIMBridge) end
      
      if C.translator and C.translator.enable == "1" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator v1.0.0]|r " .. (T["Enable Translator"] or "Traductor Activo") .. ". Protocolo Séquito.")
      end
    elseif event == "ADDON_LOADED" and arg1 == "WIM" then
      pcall(HookWIMBridge)
    end
  end)

  -- Slash Commands
  SLASH_PFTR1 = "/tr"
  SlashCmdList["PFTR"] = function(msg)
    if msg == "stats" then
      DEFAULT_CHAT_FRAME:AddMessage("In: " .. pfUI.translator_stats.total_in .. " | Out: " .. pfUI.translator_stats.total_out)
    else
      pfUI.gui.ShowConfig(T["Translator"])
    end
  end

  pfUI.Translate = LocalTranslate
end)
