pfUI:RegisterModule("translator", "vanilla", function ()
  -- ============================================================
  -- TRADUCTOR UNIVERSAL v2.0 — Séquito del Terror Edition
  -- Motor Offline Bidireccional ES <-> EN con Puente WIM
  -- ============================================================

  if not pfUI.translator_dicts then return end

  local C = pfUI_config
  local cfg = C.translator or {}

  -- Inicializar config con valores por defecto si no existen
  if not C.translator then C.translator = {} end
  if C.translator.enable      == nil then C.translator.enable      = "1" end
  if C.translator.incoming    == nil then C.translator.incoming    = "1" end
  if C.translator.outgoing    == nil then C.translator.outgoing    = "1" end
  if C.translator.wim_bridge  == nil then C.translator.wim_bridge  = "1" end
  if C.translator.show_tag    == nil then C.translator.show_tag    = "1" end
  if C.translator.tag_color   == nil then C.translator.tag_color   = "33ffcc" end
  if C.translator.silent_mode == nil then C.translator.silent_mode = "0" end
  if C.translator.ch_say      == nil then C.translator.ch_say      = "1" end
  if C.translator.ch_yell     == nil then C.translator.ch_yell     = "1" end
  if C.translator.ch_party    == nil then C.translator.ch_party    = "1" end
  if C.translator.ch_raid     == nil then C.translator.ch_raid     = "1" end
  if C.translator.ch_guild    == nil then C.translator.ch_guild    = "1" end
  if C.translator.ch_whisper  == nil then C.translator.ch_whisper  = "1" end
  if C.translator.ch_channel  == nil then C.translator.ch_channel  = "1" end

  -- Estadísticas
  pfUI.translator_stats = pfUI.translator_stats or {
    total_in = 0,
    total_out = 0,
    cache_hits = 0,
  }

  -- Cache LRU simple (últimas 64 traducciones)
  local TR_CACHE = {}
  local TR_CACHE_ORDER = {}
  local TR_CACHE_MAX = 64

  local function CacheGet(text)
    return TR_CACHE[text]
  end

  local function CacheSet(text, result)
    if TR_CACHE[text] then return end
    if table.getn(TR_CACHE_ORDER) >= TR_CACHE_MAX then
      local oldest = table.remove(TR_CACHE_ORDER, 1)
      TR_CACHE[oldest] = nil
    end
    TR_CACHE[text] = result
    table.insert(TR_CACHE_ORDER, text)
  end

  -- ============================================================
  -- MOTOR DE TRADUCCIÓN IN-MEMORY (Vanilla Lua 5.0 Safe)
  -- ============================================================
  local function LocalTranslate(text, dictionary, keyArray)
    if not text or type(text) ~= "string" or strlen(text) < 2 then return nil end

    -- Consultar cache
    local cached = CacheGet(text)
    if cached then
      pfUI.translator_stats.cache_hits = pfUI.translator_stats.cache_hits + 1
      return cached
    end

    local proc_text = " " .. strlower(text) .. " "
    local translation_occurred = false

    for _, key in ipairs(keyArray) do
      if strfind(proc_text, key, 1, true) then
        local replace_value = dictionary[key]
        local safe_key = string.gsub(key, "(%W)", "%%%1")
        local pattern = "(%A)(" .. safe_key .. ")(%A)"
        local count = 0
        local temp_text = proc_text
        temp_text, count = string.gsub(temp_text, pattern, "%1" .. replace_value .. "%3")
        temp_text = string.gsub(temp_text, pattern, "%1" .. replace_value .. "%3")
        if count > 0 then
          proc_text = temp_text
          translation_occurred = true
        end
      end
    end

    if translation_occurred then
      local result = strsub(proc_text, 2, -2)
      CacheSet(text, result)
      return result
    end
    return nil
  end

  -- ============================================================
  -- DETECTOR DE IDIOMA (Heurístico por vocabulario conocido)
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
    if en_hits > es_hits and en_hits >= 2 then return "en" end
    if es_hits > en_hits and es_hits >= 2 then return "es" end
    return "unknown"
  end

  -- ============================================================
  -- VERIFICAR SI UN CANAL ESTÁ HABILITADO
  -- ============================================================
  local function IsChanEnabled(chatType)
    local lower = strlower(chatType or "")
    if lower == "say"     then return C.translator.ch_say     == "1" end
    if lower == "yell"    then return C.translator.ch_yell    == "1" end
    if lower == "party"   then return C.translator.ch_party   == "1" end
    if lower == "raid"    then return C.translator.ch_raid    == "1" end
    if lower == "guild"   then return C.translator.ch_guild   == "1" end
    if lower == "whisper" then return C.translator.ch_whisper == "1" end
    if lower == "channel" then return C.translator.ch_channel == "1" end
    return false
  end

  -- ============================================================
  -- HELPER: CONSTRUIR TAG [TR]
  -- ============================================================
  local function GetTRTag()
    if C.translator.show_tag ~= "1" then return "" end
    local color = C.translator.tag_color or "33ffcc"
    return " |cff" .. color .. "[TR]|r"
  end

  -- ============================================================
  -- HOOK DE SALIDA: SendChatMessage (ES → EN)
  -- ============================================================
  local originalSendChatMessage = SendChatMessage
  SendChatMessage = function(msg, chatType, language, channel)
    -- Bypass: comandos slash y puntos (macros)
    if not msg or strsub(msg, 1, 1) == "/" or strsub(msg, 1, 1) == "." then
      originalSendChatMessage(msg, chatType, language, channel)
      return
    end

    if C.translator.enable == "1" and C.translator.outgoing == "1" and IsChanEnabled(chatType) then
      local lang = DetectLanguage(msg)
      -- Solo traducir si el texto parece español o es desconocido (no inglés ya)
      if lang ~= "en" then
        local trans = LocalTranslate(msg, pfUI.translator_dicts.esES_enUS, pfUI.translator_dicts.esES_keys)
        if trans then
          pfUI.translator_stats.total_out = pfUI.translator_stats.total_out + 1
          if C.translator.silent_mode ~= "1" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff888888[TR→EN]|r " .. trans)
          end
          originalSendChatMessage(trans, chatType, language, channel)
          return
        end
      end
    end

    originalSendChatMessage(msg, chatType, language, channel)
  end

  -- ============================================================
  -- HOOK DE ENTRADA: ChatFrame_MessageEventHandler (EN → ES)
  -- ============================================================
  local function HookIncomingChat()
    if pfUI.GravityTRHooked then return end
    local originalChatHandler = ChatFrame_MessageEventHandler
    ChatFrame_MessageEventHandler = function(event)
      if C.translator.enable == "1" and C.translator.incoming == "1" then
        if event and strfind(event, "CHAT_MSG_") and arg1 then
          local chatType = strsub(event, 10)  -- "CHAT_MSG_SAY" -> "SAY"
          if IsChanEnabled(strlower(chatType)) then
            local lang = DetectLanguage(arg1)
            if lang == "en" or lang == "unknown" then
              local trans = LocalTranslate(arg1, pfUI.translator_dicts.enUS_esES, pfUI.translator_dicts.enUS_keys)
              if trans then
                pfUI.translator_stats.total_in = pfUI.translator_stats.total_in + 1
                arg1 = trans .. GetTRTag()
              end
            end
          end
        end
      end
      return originalChatHandler(event)
    end
    pfUI.GravityTRHooked = true
  end

  -- ============================================================
  -- PUENTE WIM: Hook sobre WIM_PostMessage (Susurros Entrantes)
  -- ============================================================
  local function HookWIMBridge()
    if not WIM_PostMessage then return end
    if pfUI.GravityWIMHooked then return end

    local originalWIMPost = WIM_PostMessage
    WIM_PostMessage = function(user, msg, ttype, from, raw_msg, hotkeyFix)
      -- ttype 1 = whisper entrante
      if C.translator.enable == "1" and C.translator.wim_bridge == "1" and ttype == 1 and raw_msg then
        local lang = DetectLanguage(raw_msg)
        if lang == "en" or lang == "unknown" then
          local trans = LocalTranslate(raw_msg, pfUI.translator_dicts.enUS_esES, pfUI.translator_dicts.enUS_keys)
          if trans then
            pfUI.translator_stats.total_in = pfUI.translator_stats.total_in + 1
            -- Reemplazar el texto en el mensaje formateado y en raw_msg
            local tag = GetTRTag()
            local escaped = string.gsub(raw_msg, "(%W)", "%%%1")
            msg = string.gsub(msg, escaped, trans .. tag)
            raw_msg = trans
          end
        end
      end
      return originalWIMPost(user, msg, ttype, from, raw_msg, hotkeyFix)
    end

    pfUI.GravityWIMHooked = true
  end

  -- ============================================================
  -- COMANDO SLASH: /tr
  -- ============================================================
  SLASH_PFTR1 = "/tr"
  SLASH_PFTR2 = "/traductor"
  SlashCmdList["PFTR"] = function(msg)
    local cmd = strlower(msg or "")
    if cmd == "stats" then
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r |cffffd700Estadísticas:|r")
      DEFAULT_CHAT_FRAME:AddMessage("  Entrantes traducidos: |cff33ffcc" .. pfUI.translator_stats.total_in .. "|r")
      DEFAULT_CHAT_FRAME:AddMessage("  Salientes traducidos: |cff33ffcc" .. pfUI.translator_stats.total_out .. "|r")
      DEFAULT_CHAT_FRAME:AddMessage("  Cache hits: |cff33ffcc" .. pfUI.translator_stats.cache_hits .. "|r")
    elseif cmd == "on" then
      C.translator.enable = "1"
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r |cff33ffccActivado.|r")
    elseif cmd == "off" then
      C.translator.enable = "0"
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r |cffff5555Desactivado.|r")
    elseif cmd == "reset" then
      TR_CACHE = {}
      TR_CACHE_ORDER = {}
      pfUI.translator_stats = { total_in = 0, total_out = 0, cache_hits = 0 }
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r Cache y estadísticas reseteados.")
    elseif cmd == "test" then
      local test = "hello can you help me find a healer for the dungeon"
      local result = LocalTranslate(test, pfUI.translator_dicts.enUS_esES, pfUI.translator_dicts.enUS_keys)
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator Test]|r")
      DEFAULT_CHAT_FRAME:AddMessage("  IN:  " .. test)
      DEFAULT_CHAT_FRAME:AddMessage("  OUT: " .. (result or "|cffff5555Sin traducción (vocabulario no en diccionario)|r"))
    else
      DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r Comandos: /tr on|off|stats|reset|test")
    end
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
      HookIncomingChat()
      -- Informar estado
      if C.translator.enable == "1" then
        local dicts = pfUI.translator_dicts
        local has_en = dicts and dicts.enUS_esES
        local has_es = dicts and dicts.esES_enUS
        if has_en or has_es then
          DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator v2.0]|r Offline activo. /tr help")
        end
      end
    elseif event == "ADDON_LOADED" and arg1 == "WIM" then
      if C.translator.enable == "1" and C.translator.wim_bridge == "1" then
        HookWIMBridge()
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[Translator]|r Puente WIM activado.")
      end
    end
  end)

  -- Si WIM ya está cargado antes que nosotros, enganchar directamente
  if IsAddOnLoaded("WIM") then
    HookWIMBridge()
  end

  -- Exponer función de traducción a otros módulos
  pfUI.Translate = LocalTranslate
  pfUI.DetectLanguage = DetectLanguage

end)
