pfUI:RegisterModule("translator", "vanilla", function ()
  -- ============================================================
  -- TRADUCTOR UNIVERSAL v3.1.0 — Omni-Tier Séquito Edition
  -- Motor Híbrido de Alto Rendimiento (Hash + Greedy)
  -- ============================================================

  local C = pfUI_config
  local T = pfUI_translation[GetLocale()] or pfUI_translation["enUS"]

  -- Estructura de Diccionarios V3 (Híbrida)
  pfUI.translator_dicts = pfUI.translator_dicts or {}
  pfUI.translator_dicts.es_en_words = pfUI.translator_dicts.es_en_words or {}
  pfUI.translator_dicts.es_en_phrases = pfUI.translator_dicts.es_en_phrases or {}
  pfUI.translator_dicts.es_en_keys = pfUI.translator_dicts.es_en_keys or {}
  
  pfUI.translator_dicts.en_es_words = pfUI.translator_dicts.en_es_words or {}
  pfUI.translator_dicts.en_es_phrases = pfUI.translator_dicts.en_es_phrases or {}
  pfUI.translator_dicts.en_es_keys = pfUI.translator_dicts.en_es_keys or {}

  pfUI.translator_stats = pfUI.translator_stats or { total_in = 0, total_out = 0, cache_hits = 0 }

  -- Cache LRU optimizado de alta capacidad
  local TR_CACHE = {}
  local TR_CACHE_ORDER = {}
  local TR_CACHE_MAX = 1024

  local function CacheGet(text) return TR_CACHE[text] end
  local function CacheSet(text, result)
    if not text or TR_CACHE[text] then return end
    if table.getn(TR_CACHE_ORDER) >= TR_CACHE_MAX then
      local oldest = table.remove(TR_CACHE_ORDER, 1)
      TR_CACHE[oldest] = nil
    end
    TR_CACHE[text] = result
    table.insert(TR_CACHE_ORDER, text)
  end

  -- Heurística de Reino (Séquito Intelligence)
  pfUI.translator_realm_votes = pfUI.translator_realm_votes or { en = 0, es = 0, detected = nil }

  -- ============================================================
  -- LÓGICA DE BILATERALIDAD (Séquito Intelligence v3.2.0)
  -- ============================================================
  local function GetTranslationMode(isIncoming)
    local locale = GetLocale()
    local server = C.translator.server_type or "0" -- 0:Auto, 1:EN, 2:ES
    local force_dir = C.translator.direction or "0"

    -- Determinar entorno (English o Spanish)
    local env = "en" -- Fallback global
    if server == "1" then 
      env = "en" -- Manual EN
    elseif server == "2" then 
      env = "es" -- Manual ES
    elseif server == "0" then
      -- Inteligencia: Heurística primero, Paradoja después
      if pfUI.translator_realm_votes.detected then
        env = pfUI.translator_realm_votes.detected
      else
        -- Lógica de Paradoja: Si mi cliente es ES, asumo que el reino es EN
        env = (locale == "esES" or locale == "esMX") and "en" or "es"
      end
    end

    -- Si el entorno SOCIAL es igual al de mi CLIENTE, no traduzco nada
    local myLang = (locale == "esES" or locale == "esMX") and "es" or "en"
    if env == myLang and server == "0" then return nil, nil end

    if not isIncoming then
      -- Dirección de Salida
      if force_dir == "1" then return "es", "en" end
      if force_dir == "2" then return "en", "es" end
      return myLang, env
    else
      -- Dirección de Entrada
      return env, myLang
    end
  end

  -- ============================================================
  -- MOTOR HÍBRIDO (El corazón del sistema)
  -- ============================================================
  local function LocalTranslate(text, wordDict, phraseDict, phraseKeys)
    if not text or type(text) ~= "string" or strlen(text) < 2 then return nil end
    
    local cached = CacheGet(text)
    if cached then
      pfUI.translator_stats.cache_hits = pfUI.translator_stats.cache_hits + 1
      return cached
    end

    -- Fase 0: Preservar Enlaces (Items, Spells, Players)
    local links = {}
    local link_count = 0
    local proc_text = text
    proc_text = string.gsub(proc_text, "(|H.-|h.-|h)", function(link)
      link_count = link_count + 1
      links[link_count] = link
      return "\127L" .. link_count .. "\127"
    end)

    proc_text = " " .. strlower(proc_text) .. " "
    local trans_occurred = false

    -- Fase 1: Greedy Matching (Frases Compuestas)
    -- Solo recorremos las llaves de frases largas. Eficiencia O(N_phrases).
    if phraseDict and phraseKeys then
      for _, key in ipairs(phraseKeys) do
        if strfind(proc_text, key, 1, true) then
          local safe_key = string.gsub(key, "(%W)", "%%%1")
          local pattern = "(%A)(" .. safe_key .. ")(%A)"
          local res, count = string.gsub(proc_text, pattern, "%1" .. phraseDict[key] .. "%3")
          if count > 0 then
            proc_text = res
            trans_occurred = true
          end
        end
      end
    end

    -- Fase 2: Hash Lookup (Palabras Simples)
    -- Traduce palabras individuales instantáneamente vía Hash Table. Eficiencia O(1) por palabra.
    if wordDict then
      local hashed_text = string.gsub(proc_text, "([\128-\255%w]+)", function(w)
        if wordDict[w] then
          trans_occurred = true
          return wordDict[w]
        end
        return w
      end)
      proc_text = hashed_text
    end

    if trans_occurred then
      local result = strsub(proc_text, 2, -2)
      -- Restaurar Enlaces Protegidos
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
  local EN_MARKERS = { "the", "and", "you", "are", "for", "have", "with", "not", "this", "that", "but", "they", "from", "will", "what", "your", "know", "how", "well" }
  local ES_MARKERS = { "que", "por", "una", "con", "los", "las", "del", "les", "como", "pero", "para", "este", "esta", "hay", "muy", "mas", "aqui", "todos", "bien" }

  local function DetectLanguage(text)
    if not text then return "unknown" end
    local lower = " " .. strlower(text) .. " "
    local en_hits, es_hits = 0, 0
    for _, w in ipairs(EN_MARKERS) do if strfind(lower, " " .. w .. " ", 1, true) then en_hits = en_hits + 1 end end
    for _, w in ipairs(ES_MARKERS) do if strfind(lower, " " .. w .. " ", 1, true) then es_hits = es_hits + 1 end end
    if en_hits > es_hits and en_hits >= 1 then return "en" end
    if es_hits > en_hits and es_hits >= 1 then return "es" end
    return "unknown"
  end

  -- ============================================================
  -- SEGURIDAD Y CANALES
  -- ============================================================
  local function IsChanEnabled(chatType)
    if not C.translator or C.translator.enable ~= "1" then return false end
    local lower = strlower(chatType or "")
    
    -- Mapeo dinámico de canales basado en configuración
    if strfind(lower, "say")     then return C.translator.chan_say     == "1" end
    if strfind(lower, "party")   then return C.translator.chan_party   == "1" end
    if strfind(lower, "raid")    then return C.translator.chan_raid    == "1" end
    if strfind(lower, "guild")   then return C.translator.chan_guild   == "1" end
    if strfind(lower, "whisper") then return C.translator.chan_whisper == "1" end
    if strfind(lower, "world")   then return C.translator.chan_world   == "1" end
    if strfind(lower, "lfg")     then return C.translator.chan_lfg     == "1" end
    if strfind(lower, "channel") then return C.translator.chan_world   == "1" end -- Fallback para canales personalizados

    -- Bloqueo absoluto de cualquier otro evento (NPCs, Sistema, Emotes)
    return false
  end

  local function GetTRTag()
    if not C.translator or C.translator.silent_mode == "1" then return "" end
    return " |cff33ffcc[TR]|r"
  end

  -- ============================================================
  -- GESTIÓN DE SALIDA (Escritura)
  -- ============================================================
  local function TranslateOutgoing(msg, chatType, channel)
    if not msg or strfind(msg, "^[/%.]") then return nil end
    if not C.translator or C.translator.enable ~= "1" or C.translator.outgoing ~= "1" then return nil end
    if not IsChanEnabled(chatType) then return nil end

    local src, dest = GetTranslationMode(false)
    if not src or not dest then return nil end

    local words = (src == "es") and pfUI.translator_dicts.es_en_words or pfUI.translator_dicts.en_es_words
    local phrases = (src == "es") and pfUI.translator_dicts.es_en_phrases or pfUI.translator_dicts.en_es_phrases
    local keys = (src == "es") and pfUI.translator_dicts.es_en_keys or pfUI.translator_dicts.en_es_keys

    local trans = LocalTranslate(msg, words, phrases, keys)
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
  -- GESTIÓN DE ENTRADA (Lectura)
  -- ============================================================
  local function HookIncomingChat()
    if pfUI.GravityTRHooked then return end
    local function TranslatorAddMessage(frame, text, r, g, b, id)
      if not text or type(text) ~= "string" then return frame:pfOriginalAddMessage(text, r, g, b, id) end
      if not C.translator or C.translator.enable ~= "1" or C.translator.incoming ~= "1" then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      -- SOBERANÍA: Solo chat de jugadores
      if not strfind(text, "|Hplayer:") and not strfind(text, "|Hchannel:") then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      local src, dest = GetTranslationMode(true)
      if not src or not dest then return frame:pfOriginalAddMessage(text, r, g, b, id) end

      local lang = DetectLanguage(text)
      
      -- VOTACIÓN HEURÍSTICA: Escucha canales globales para detectar el idioma del reino
      if C.translator.server_type == "0" and not pfUI.translator_realm_votes.detected then
        local lowerChan = strlower(id or "")
        if strfind(lowerChan, "world") or strfind(lowerChan, "lfg") or strfind(lowerChan, "say") then
          if lang == "en" then 
            pfUI.translator_realm_votes.en = pfUI.translator_realm_votes.en + 1
          elseif lang == "es" then 
            pfUI.translator_realm_votes.es = pfUI.translator_realm_votes.es + 1
          end
          
          -- Umbral de decisión (5 votos)
          if pfUI.translator_realm_votes.en >= 5 then 
            pfUI.translator_realm_votes.detected = "en"
            if C.translator.debug_mode == "1" then DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Entorno detectado: INGLÉS") end
          elseif pfUI.translator_realm_votes.es >= 5 then 
            pfUI.translator_realm_votes.detected = "es"
            if C.translator.debug_mode == "1" then DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Entorno detectado: ESPAÑOL") end
          end
        end
      end

      if lang == src or lang == "unknown" then
        local words = (src == "en") and pfUI.translator_dicts.en_es_words or pfUI.translator_dicts.es_en_words
        local phrases = (src == "en") and pfUI.translator_dicts.en_es_phrases or pfUI.translator_dicts.es_en_phrases
        local keys = (src == "en") and pfUI.translator_dicts.en_es_keys or pfUI.translator_dicts.es_en_keys
        
        local trans = LocalTranslate(text, words, phrases, keys)
        if trans then
          pfUI.translator_stats.total_in = pfUI.translator_stats.total_in + 1
          text = trans .. GetTRTag()
        end
      end
      return frame:pfOriginalAddMessage(text, r, g, b, id)
    end

    for i=1, 10 do
      local frame = _G["ChatFrame"..i]
      if frame and not frame.pfOriginalAddMessage then
        frame.pfOriginalAddMessage = frame.AddMessage
        frame.AddMessage = function(self, text, r, g, b, id) TranslatorAddMessage(self, text, r, g, b, id) end
      end
    end
    pfUI.GravityTRHooked = true
  end

  -- ============================================================
  -- PUENTE WIM (Bilateralizado)
  -- ============================================================
  local function HookWIMBridge()
    if not WIM_PostMessage or pfUI.GravityWIMHooked then return end
    local originalWIMPost = WIM_PostMessage
    WIM_PostMessage = function(user, msg, ttype, from, raw_msg, hotkeyFix)
      if C.translator and C.translator.enable == "1" and C.translator.wim_bridge == "1" and raw_msg then
        local isIncoming = ttype == 1
        local mode_check = isIncoming and C.translator.incoming == "1" or C.translator.outgoing == "1"
        if mode_check then
          local src, dest = GetTranslationMode(isIncoming)
          if src and dest then
            local words = (src == "en") and pfUI.translator_dicts.en_es_words or pfUI.translator_dicts.es_en_words
            local phrases = (src == "en") and pfUI.translator_dicts.en_es_phrases or pfUI.translator_dicts.es_en_phrases
            local keys = (src == "en") and pfUI.translator_dicts.en_es_keys or pfUI.translator_dicts.es_en_keys
            local trans = LocalTranslate(raw_msg, words, phrases, keys)
            if trans then
              msg = string.gsub(msg, string.gsub(raw_msg, "(%W)", "%%%1"), trans .. GetTRTag())
              raw_msg = trans
            end
          end
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
    if event == "PLAYER_ENTERING_WORLD" then
      initFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
      pcall(SecureHookOutgoing)
      pcall(HookIncomingChat)
      if IsAddOnLoaded("WIM") then pcall(HookWIMBridge) end
      if C.translator and C.translator.enable == "1" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator v3.1.0]|r " .. (T["Enable Translator"] or "Traductor Bilateral Activo") .. ".")
      end
    elseif event == "ADDON_LOADED" and arg1 == "WIM" then pcall(HookWIMBridge) end
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
