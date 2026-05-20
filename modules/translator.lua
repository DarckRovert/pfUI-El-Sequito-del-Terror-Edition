pfUI:RegisterModule("translator", "vanilla", function ()
  -- ============================================================
  -- TRADUCTOR UNIVERSAL v6.0.0 — Ultimate-Tier Sequito Edition
  -- Motor Hibrido Trilingue de Alto Rendimiento (ES / ZH / EN)
  -- Soporte Nativo UTF-8 y Resolucion de Coincidencias Dinamicas
  -- ============================================================

  pfUI.translator_version = "6.0.0"

  local C = pfUI_config
  local T = pfUI_translation[GetLocale()] or pfUI_translation["enUS"]
  if T ~= pfUI_translation["enUS"] then
    T = setmetatable(T, { __index = pfUI_translation["enUS"] })
  end

  -- ============================================================
  -- ESTRUCTURA DE DICCIONARIOS V4 (Hibrida Trilingue)
  -- NOTA: Renombrado a LANG_PAIRS para NO sombrar el iterador
  --       global pairs() de Lua 5.0 (bug critico anterior).
  -- ============================================================
  pfUI.translator_dicts = pfUI.translator_dicts or {}
  local LANG_PAIRS = { "es_en", "en_es", "zh_en", "en_zh", "zh_es", "es_zh" }
  for _, p in ipairs(LANG_PAIRS) do
    pfUI.translator_dicts[p .. "_words"]   = pfUI.translator_dicts[p .. "_words"]   or {}
    pfUI.translator_dicts[p .. "_phrases"] = pfUI.translator_dicts[p .. "_phrases"] or {}
    pfUI.translator_dicts[p .. "_keys"]    = pfUI.translator_dicts[p .. "_keys"]    or {}
  end

  pfUI.translator_stats = pfUI.translator_stats or { total_in = 0, total_out = 0, cache_hits = 0 }

  -- ============================================================
  -- CACHE LRU (1024 registros — alta capacidad)
  -- ============================================================
  local TR_CACHE       = {}
  local TR_CACHE_ORDER = {}
  local TR_CACHE_MAX   = 1024

  local function CacheGet(text)
    local val = TR_CACHE[text]
    if val then
      -- Promueve el item al final de la cola (verdadero LRU: el mas usado permanece mas tiempo)
      for i = 1, table.getn(TR_CACHE_ORDER) do
        if TR_CACHE_ORDER[i] == text then
          table.remove(TR_CACHE_ORDER, i)
          table.insert(TR_CACHE_ORDER, text)
          break
        end
      end
      pfUI.translator_stats.cache_hits = pfUI.translator_stats.cache_hits + 1
      return val
    end
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
  -- HELPER: Idioma del cliente local (centralizado, sin duplicacion)
  -- ============================================================
  local function GetMyLang()
    local locale = GetLocale()
    if locale == "esES" or locale == "esMX" then return "es" end
    if locale == "zhCN" or locale == "zhTW" then return "zh" end
    return "en"
  end

  -- Heuristica de Reino (Sequito Intelligence)
  pfUI.translator_realm_votes = pfUI.translator_realm_votes or { en = 0, es = 0, zh = 0, detected = nil }

  -- ============================================================
  -- LOGICA TRILINGUE (Sequito Intelligence v4.2.1)
  -- ============================================================
  local function GetTranslationMode(isIncoming)
    local server    = C.translator.server_type or "0" -- 0:Auto, 1:EN, 2:ES, 3:ZH
    local force_dir = C.translator.direction   or "0"
    local myLang    = GetMyLang()

    -- Determinar entorno del servidor
    local env = "en" -- Fallback global
    if server == "1" then
      env = "en"
    elseif server == "2" then
      env = "es"
    elseif server == "3" then
      env = "zh"
    elseif server == "0" then
      if pfUI.translator_realm_votes.detected then
        env = pfUI.translator_realm_votes.detected
      else
        -- Si el cliente es ES o ZH, asume servidor EN y viceversa
        env = (myLang == "es" or myLang == "zh") and "en" or "es"
      end
    end

    -- Si el entorno del servidor es igual al del cliente (modo auto), no traducir
    if env == myLang and server == "0" and force_dir == "0" then return nil, nil end

    if not isIncoming then
      -- Direccion de Salida
      if force_dir == "1" then return "es", "en" end
      if force_dir == "2" then return "en", "es" end
      if force_dir == "3" then return "zh", "en" end
      if force_dir == "4" then return "en", "zh" end
      if force_dir == "5" then return "es", "zh" end
      if force_dir == "6" then return "zh", "es" end
      return myLang, env
    else
      -- Direccion de Entrada
      if force_dir == "1" then return "es", "en" end
      if force_dir == "2" then return "en", "es" end
      if force_dir == "3" then return "zh", "en" end
      if force_dir == "4" then return "en", "zh" end
      if force_dir == "5" then return "es", "zh" end
      if force_dir == "6" then return "zh", "es" end
      return env, myLang
    end
  end

  -- ============================================================
  -- MOTOR HIBRIDO (El corazon del sistema)
  -- ============================================================
  local function CountChineseChars(text)
    if not text or type(text) ~= "string" then return 0 end
    local count = 0
    local i     = 1
    local len   = strlen(text)
    while i <= len do
      local byte = strbyte(text, i)
      if byte >= 224 and byte <= 239 then
        count = count + 1
        i = i + 3
      elseif byte >= 192 and byte <= 223 then
        i = i + 2
      elseif byte >= 240 then
        i = i + 4
      else
        i = i + 1
      end
    end
    return count
  end

  -- Calcula el ratio de coherencia de la traduccion (CTR)
  -- FIX: Usa next() en lugar de pairs() para iteracion segura en Lua 5.0
  --      (la variable local LANG_PAIRS sombrabria pairs() si se usara aqui)
  local function GetTranslationRatio(orig_text, dest_text, srcLang)
    if srcLang == "zh" then
      local orig_zh = CountChineseChars(orig_text)
      if orig_zh == 0 then return 1.0 end
      local dest_zh = CountChineseChars(dest_text)
      return (orig_zh - dest_zh) / orig_zh
    else
      -- Occidental: mide proporcion de palabras cambiadas
      local orig_words = {}
      local total = 0
      for w in string.gfind(orig_text, "([%a%d\128-\255]+)") do
        local lw = strlower(w)
        orig_words[lw] = (orig_words[lw] or 0) + 1
        total = total + 1
      end
      if total == 0 then return 1.0 end

      local dest_words = {}
      for w in string.gfind(dest_text, "([%a%d\128-\255]+)") do
        local lw = strlower(w)
        dest_words[lw] = (dest_words[lw] or 0) + 1
      end

      -- Iteracion con next() — Lua 5.0 compatible y sin riesgo de shadowing
      local unchanged = 0
      local w = next(orig_words)
      while w ~= nil do
        local count = orig_words[w]
        if dest_words[w] then
          local d = dest_words[w]
          unchanged = unchanged + (count < d and count or d)
        end
        w = next(orig_words, w)
      end

      return (total - unchanged) / total
    end
  end

  local function LocalTranslate(text, wordDict, phraseDict, phraseKeys, srcLang, buckets)
    if not text or type(text) ~= "string" or strlen(text) < 2 then return nil end

    -- Consultar cache LRU primero
    local cached = CacheGet(text)
    if cached then return cached end

    -- Fase 0: Preservar y encapsular enlaces (Items, Spells, Players)
    local links      = {}
    local link_count = 0
    local proc_text  = text
    proc_text = string.gsub(proc_text, "(|H.-|h.-|h)", function(link)
      link_count = link_count + 1
      links[link_count] = link
      return "\127L" .. link_count .. "\127"
    end)
    if srcLang ~= "zh" then
      proc_text = strlower(proc_text)
    end
    proc_text = " " .. proc_text .. " "
    local trans_occurred = false

    -- Fase 1: Greedy Matching (Frases Compuestas / Soporte UTF-8 Multibyte)
    if phraseDict and phraseKeys then
      local candidateKeys
      if buckets then
        candidateKeys = {}
        local unique_candidates = {}
        if srcLang == "zh" then
          local len = strlen(proc_text)
          local i = 1
          while i <= len do
            local b = string.byte(proc_text, i)
            local char_len = 1
            if b and b >= 224 and b <= 239 then char_len = 3
            elseif b and b >= 192 and b <= 223 then char_len = 2 end
            local ch = strsub(proc_text, i, i + char_len - 1)
            i = i + char_len
            if ch and ch ~= "" and ch ~= " " then
              local bucket = buckets[ch]
              if bucket then
                for _, k in ipairs(bucket) do
                  if not unique_candidates[k] then
                    unique_candidates[k] = true
                    table.insert(candidateKeys, k)
                  end
                end
              end
            end
          end
        else
          local wStart = 1
          local len = strlen(proc_text)
          while wStart <= len do
            local s, e = strfind(proc_text, "[%w_'-]+", wStart)
            if not s then break end
            local word = strsub(proc_text, s, e)
            if word and word ~= "" then
              local ch = strsub(word, 1, 1)
              local bucket = buckets[ch]
              if bucket then
                for _, k in ipairs(bucket) do
                  if not unique_candidates[k] then
                    unique_candidates[k] = true
                    table.insert(candidateKeys, k)
                  end
                end
              end
            end
            wStart = e + 1
          end
        end
        table.sort(candidateKeys, function(a, b) return strlen(a) > strlen(b) end)
      else
        -- FIX: Ordenar keys obligatoriamente si no hay buckets para asegurar Greedy Match en Chino
        candidateKeys = {}
        for _, k in ipairs(phraseKeys) do table.insert(candidateKeys, k) end
        table.sort(candidateKeys, function(a, b) return strlen(a) > strlen(b) end)
      end

      for _, key in ipairs(candidateKeys) do
        if strfind(proc_text, key, 1, true) then
          -- Escapa solo metacaracteres Lua, sin alterar bytes multibyte UTF-8
          local safe_key = string.gsub(key, "([%.%*%-%?%[%]%(%)%^%$%%])", "%%%1")
          local res, count
          if srcLang == "zh" then
            -- Chino: reemplazo con acolchado inteligente para evitar fusiones de palabras occidentales
            res, count = string.gsub(proc_text, safe_key, " " .. phraseDict[key] .. " ")
          else
            -- Occidental: requiere delimitadores de no-letra para evitar falsos positivos
            local pattern = "(%A)(" .. safe_key .. ")(%A)"
            res, count = string.gsub(proc_text, pattern, "%1" .. phraseDict[key] .. "%3")
          end
          if count and count > 0 then
            proc_text      = res
            trans_occurred = true
            if C.translator.debug_mode == "1" then
              DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Key Hit: " .. key)
            end
          end
        end
      end
    end


    -- Fase 2: Hash Lookup (Palabras Simples — solo idiomas occidentales)
    if wordDict and srcLang ~= "zh" then
      local hashed_text = string.gsub(proc_text, "([%a%d\128-\255]+)", function(w)
        local lower_w = strlower(w)
        if wordDict[lower_w] then
          trans_occurred = true
          return wordDict[lower_w]
        end
        return w
      end)
      proc_text = hashed_text
    end

    if trans_occurred then
      local result = strsub(proc_text, 2, -2)

      -- Colapsar espacios múltiples y limpiar extremos en traducciones de origen Chino
      if srcLang == "zh" then
        result = string.gsub(result, "%s+", " ")
        result = string.gsub(result, "^%s*(.-)%s*$", "%1")
      end

      -- Restaurar enlaces protegidos
      -- Patron [lL] cubre ambos casos: \127L original y \127l tras strlower()
      result = string.gsub(result, "\127[lL](%d+)\127", function(lid)
        return links[tonumber(lid)]
      end)

      -- Validar coherencia (CTR — Coherence Threshold Ratio)
      local ratio     = GetTranslationRatio(text, result, srcLang)
      local min_ratio = (srcLang == "zh") and 0.10 or 0.40
      if ratio < min_ratio then
        return nil -- Descartar: previene Spanglish/Chinol
      end

      CacheSet(text, result)
      return result
    end
    return nil
  end

  -- ============================================================
  -- DETECTOR DE IDIOMA ULTRA-SENSIBLE
  -- ============================================================
  local EN_MARKERS = {
    "the", "and", "you", "are", "for", "have", "with", "not", "this",
    "that", "but", "they", "from", "will", "what", "your", "know", "how", "well",
  }
  local ES_MARKERS = {
    "que", "por", "una", "con", "los", "las", "del", "les", "como",
    "pero", "para", "este", "esta", "hay", "muy", "mas", "aqui", "todos", "bien",
  }
  local ZH_MARKERS = {
    "\231\154\132", "\228\186\134", "\230\152\175", "\230\136\145", "\228\189\160",
    "\228\187\150", "\229\156\168", "\230\156\137", "\229\146\140", "\229\176\177",
    "\228\184\141", "\230\178\161", "\233\131\189", "\228\184\128", "\230\178\161\230\156\137",
    "\230\136\145\228\187\172", "\228\189\160\228\187\172", "\228\184\170",
    -- Fallback visual: caracteres Unicode comunes si el encoding string literal falla
    "的", "是", "了", "我", "你", "有", "不", "一", "个", "来", "打", "组", "去", "要", "和",
    "\229\175\187\230\137\190", "\233\152\159\228\188\141", "\229\216\187", "\230\137\147",
    "\230\177\130\230\173\204", "\233\155\200\230\246\201", "\230\157\245",
    "\230\137\223\230\134\254", "\230\137\276\230\173\204", "\230\175\246", "\230\155\242",
    "\230\174\232", "\230\137\211", "\233\151\250", "\233\135\221", "\229\164\247", "\229\185\224",
    "\229\144\247", "\229\144\227", "\229\145\242", "\229\165\275", "\229\173\271", "\233\140\231",
    "\229\144\203", "\229\146\235", "\230\155\273", "\230\180\273", "\229\164\215\230\180\273",
    "\230\134\254", "\230\180\133", "\230\180\172", "\230\180\173", "\229\164\154", "\229\185\226",
    "\230\150\160",
  }

  local function DetectLanguage(text)
    if not text then return "unknown" end
    local lower = " " .. strlower(text) .. " "
    local en_hits, es_hits, zh_hits = 0, 0, 0
    for _, w in ipairs(EN_MARKERS) do
      if strfind(lower, " " .. w .. " ", 1, true) then en_hits = en_hits + 1 end
    end
    for _, w in ipairs(ES_MARKERS) do
      if strfind(lower, " " .. w .. " ", 1, true) then es_hits = es_hits + 1 end
    end
    for _, w in ipairs(ZH_MARKERS) do
      if strfind(text, w, 1, true) then zh_hits = zh_hits + 1 end
    end
    if zh_hits > en_hits and zh_hits > es_hits and zh_hits >= 1 then return "zh" end
    if en_hits > es_hits and en_hits > zh_hits and en_hits >= 1 then return "en" end
    if es_hits > en_hits and es_hits > zh_hits and es_hits >= 1 then return "es" end
    return "unknown"
  end

  -- ============================================================
  -- SEGURIDAD Y CANALES
  -- ============================================================
  local function IsChanEnabled(chatType)
    if not C.translator or C.translator.enable ~= "1" then return false end
    local lower = strlower(chatType or "")
    if strfind(lower, "say")     then return C.translator.chan_say     == "1" end
    if strfind(lower, "party")   then return C.translator.chan_party   == "1" end
    if strfind(lower, "raid")    then return C.translator.chan_raid    == "1" end
    if strfind(lower, "guild")   then return C.translator.chan_guild   == "1" end
    if strfind(lower, "whisper") then return C.translator.chan_whisper == "1" end
    if strfind(lower, "world")   then return C.translator.chan_world   == "1" end
    if strfind(lower, "lfg")     then return C.translator.chan_lfg     == "1" end
    if strfind(lower, "channel") then return C.translator.chan_world   == "1" end
    -- Bloqueo absoluto: NPCs, Sistema, Emotes y eventos de combate
    return false
  end

  -- Memoized TR tag (estatico por sesion — evita recalculos en cada mensaje)
  local _tr_tag_cache = nil
  local function GetTRTag()
    if _tr_tag_cache ~= nil then return _tr_tag_cache end
    _tr_tag_cache = (not C.translator or C.translator.silent_mode == "1") and "" or " |cff33ffcc[TR]|r"
    return _tr_tag_cache
  end

  -- ============================================================
  -- GESTION DE SALIDA (Escritura)
  -- ============================================================
  local function TranslateOutgoing(msg, chatType, channel)
    if not msg or strfind(msg, "^[/%.]") then return nil end
    if not C.translator or C.translator.enable ~= "1" or C.translator.outgoing ~= "1" then return nil end
    if not IsChanEnabled(chatType) then return nil end

    local src, dest = GetTranslationMode(false)
    if not src or not dest then return nil end

    local prefix  = src .. "_" .. dest
    local words   = pfUI.translator_dicts[prefix .. "_words"]
    local phrases = pfUI.translator_dicts[prefix .. "_phrases"]
    local keys    = pfUI.translator_dicts[prefix .. "_keys"]
    local buckets = pfUI.translator_dicts[prefix .. "_buckets"]

    local trans = LocalTranslate(msg, words, phrases, keys, src, buckets)
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
  -- GESTION DE ENTRADA DINAMICA (Lectura Multilingue)
  -- ============================================================
  local function HookIncomingChat()
    if pfUI.GravityTRHooked then return end

    local function TranslatorAddMessage(frame, text, r, g, b, id)
      if not text or type(text) ~= "string" then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end
      if not C.translator or C.translator.enable ~= "1" or C.translator.incoming ~= "1" then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      -- SOBERANIA: Solo mensajes de jugadores (player link o channel link de Blizzard)
      local hasPlayer  = strfind(text, "|Hplayer:",  1, true)
      local hasChannel = strfind(text, "|Hchannel:", 1, true)
      if not hasPlayer and not hasChannel then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      -- Aislamiento Sintactico: extrae prefijo (canal/nombre) y cuerpo del mensaje
      local prefix, body
      local p_end

      if hasPlayer then
        -- Mensaje de jugador: |Hplayer:NAME|h[NAME]|h
        local _, pe = strfind(text, "|Hplayer:.-|h.-|h", 1)
        p_end = pe
      end

      -- Si es mensaje de canal sin link de jugador, busca el nombre del canal
      if not p_end and hasChannel then
        -- Formato: |Hchannel:N|h[CANAL]|h |Hplayer:NAME|h[NAME]|h: MENSAJE
        -- El link del canal va antes que el del jugador; buscamos el jugador secundario
        local _, pe = strfind(text, "|Hplayer:.-|h.-|h", hasChannel)
        p_end = pe
      end

      if p_end then
        local col_start, col_end = strfind(text, "[:：]%s*", p_end)
        if col_start then
          prefix = strsub(text, 1, col_end)
          body   = strsub(text, col_end + 1)
        else
          -- Fallback drástico si el addon de chat muta los "dos puntos" a otra cosa
          local space_start, space_end = strfind(text, "]%s*", p_end)
          if space_start then
            prefix = strsub(text, 1, space_end)
            body   = strsub(text, space_end + 1)
          else
            prefix = strsub(text, 1, p_end)
            body   = strsub(text, p_end + 1)
          end
        end
      end

      -- Fallback: si el aislamiento falla, renderizar original sin modificar
      if not prefix or not body or strlen(body) < 2 then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      -- Detectar idioma del cuerpo real del mensaje
      local lang = DetectLanguage(body)

      -- VOTACION HEURISTICA: Deteccion automatica del idioma del reino
      -- FIX: Ya no usa el parametro 'id' (era un entero de grupo de color, no el canal).
      --      Ahora vota sobre todos los mensajes de jugador con idioma detectado.
      if C.translator.server_type == "0" and not pfUI.translator_realm_votes.detected then
        if lang == "en" then
          pfUI.translator_realm_votes.en = pfUI.translator_realm_votes.en + 1
        elseif lang == "es" then
          pfUI.translator_realm_votes.es = pfUI.translator_realm_votes.es + 1
        elseif lang == "zh" then
          pfUI.translator_realm_votes.zh = pfUI.translator_realm_votes.zh + 1
        end

        -- Umbral de decision: 8 votos para mayor estabilidad vs ruido de chat
        local v = pfUI.translator_realm_votes
        if v.en >= 8 then
          v.detected = "en"
          if C.translator.debug_mode == "1" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Entorno detectado automaticamente: INGLES")
          end
        elseif v.es >= 8 then
          v.detected = "es"
          if C.translator.debug_mode == "1" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Entorno detectado automaticamente: ESPANOL")
          end
        elseif v.zh >= 8 then
          v.detected = "zh"
          if C.translator.debug_mode == "1" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Entorno detectado automaticamente: CHINO")
          end
        end
      end

      -- Seleccion de modo de traduccion para este mensaje
      local src_env, dest_env = GetTranslationMode(true)
      if not src_env or not dest_env then
        return frame:pfOriginalAddMessage(text, r, g, b, id)
      end

      -- Idioma real del mensaje: priorizar deteccion sobre config de servidor
      local final_src = (lang ~= "unknown") and lang or src_env

      -- Debug Output
      if C.translator.debug_mode == "1" then
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR DEBUG]|r Msg: " .. body)
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR DEBUG]|r Deteccion: " .. lang .. " -> final_src: " .. final_src .. " dest_env: " .. (dest_env or "nil"))
      end

      -- Traducir solo si el mensaje no esta ya en el idioma de destino
      if final_src ~= dest_env then
        local prefix_dict = final_src .. "_" .. dest_env
        local words   = pfUI.translator_dicts[prefix_dict .. "_words"]
        local phrases = pfUI.translator_dicts[prefix_dict .. "_phrases"]
        local keys    = pfUI.translator_dicts[prefix_dict .. "_keys"]
        local buckets = pfUI.translator_dicts[prefix_dict .. "_buckets"]

        if C.translator.debug_mode == "1" then
           local countKeys = keys and table.getn(keys) or 0
           DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR DEBUG]|r Dict: " .. prefix_dict .. " Keys: " .. countKeys)
        end

        -- Solo intentar si el par de idiomas tiene datos cargados
        if words and phrases and keys then
          local trans = LocalTranslate(body, words, phrases, keys, final_src, buckets)
          
          if C.translator.debug_mode == "1" then
             DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR DEBUG]|r Translation Result: " .. (trans or "nil"))
          end

          if trans then
            pfUI.translator_stats.total_in = pfUI.translator_stats.total_in + 1
            text = prefix .. trans .. GetTRTag()
          end
        end
      end

      return frame:pfOriginalAddMessage(text, r, g, b, id)
    end

    for i = 1, 10 do
      local frame = _G["ChatFrame" .. i]
      if frame and not frame.pfOriginalAddMessage then
        frame.pfOriginalAddMessage = frame.AddMessage
        frame.AddMessage = function(self, t, r, g, b, mid)
          TranslatorAddMessage(self, t, r, g, b, mid)
        end
      end
    end

    pfUI.GravityTRHooked = true
  end

  -- ============================================================
  -- PUENTE WIM (Bilateral — Entrante / Saliente)
  -- ============================================================
  local function HookWIMBridge()
    if not WIM_PostMessage or pfUI.GravityWIMHooked then return end
    local originalWIMPost = WIM_PostMessage

    WIM_PostMessage = function(user, msg, ttype, from, raw_msg, hotkeyFix)
      if C.translator and C.translator.enable == "1" and C.translator.wim_bridge == "1" and raw_msg then
        local isIncoming = (ttype == 1)
        -- FIX: Precedencia de operadores corregida (bug anterior: siempre true con outgoing=1)
        local mode_check = (isIncoming     and C.translator.incoming == "1")
                        or (not isIncoming and C.translator.outgoing == "1")
        if mode_check then
          local src, dest = GetTranslationMode(isIncoming)
          if src and dest then
            local prefix  = src .. "_" .. dest
            local words   = pfUI.translator_dicts[prefix .. "_words"]
            local phrases = pfUI.translator_dicts[prefix .. "_phrases"]
            local keys    = pfUI.translator_dicts[prefix .. "_keys"]
            local buckets = pfUI.translator_dicts[prefix .. "_buckets"]
            local trans   = LocalTranslate(raw_msg, words, phrases, keys, src, buckets)
            if trans then
              -- FIX: Escape correcto de raw_msg antes de string.gsub
              --      (raw_msg puede contener metacaracteres Lua como .-?+[])
              local safe_raw = string.gsub(raw_msg, "([%.%*%-%?%[%]%(%)%^%$%%])", "%%%1")
              msg     = string.gsub(msg, safe_raw, trans .. GetTRTag())
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
  -- INICIALIZACION
  -- ============================================================
  local initFrame = CreateFrame("Frame")
  initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  initFrame:RegisterEvent("ADDON_LOADED")
  initFrame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
      initFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
      
      -- Migración única para forzar la activación de canales en perfiles existentes (v6.8.2)
      if C.translator and not C.translator.force_channels_v682 then
        C.translator.enable = "1"
        C.translator.incoming = "1"
        C.translator.outgoing = "1"
        C.translator.chan_say = "1"
        C.translator.chan_party = "1"
        C.translator.chan_raid = "1"
        C.translator.chan_guild = "1"
        C.translator.chan_whisper = "1"
        C.translator.chan_world = "1"
        C.translator.chan_lfg = "1"
        C.translator.force_channels_v682 = "1"
      end

      pcall(SecureHookOutgoing)
      pcall(HookIncomingChat)
      if IsAddOnLoaded("WIM") then pcall(HookWIMBridge) end
      if C.translator and C.translator.enable == "1" then
        DEFAULT_CHAT_FRAME:AddMessage(
          "|cff00ccff[Translator v6.0.0]|r " ..
          (T["Enable Translator"] or "Traductor Trilingue Activo") .. "."
        )
      end
    elseif event == "ADDON_LOADED" and arg1 == "WIM" then
      pcall(HookWIMBridge)
    end
  end)

  -- ============================================================
  -- COMANDOS DE CHAT (/tr)
  -- ============================================================
  SLASH_PFTR1 = "/tr"
  SlashCmdList["PFTR"] = function(msg)
    if msg == "stats" then
      local s      = pfUI.translator_stats
      local total  = s.total_in + s.total_out + s.cache_hits
      local hitp   = (total > 0) and math.floor((s.cache_hits / total) * 100) or 0
      local detect = pfUI.translator_realm_votes.detected or "auto"
      DEFAULT_CHAT_FRAME:AddMessage(
        "|cff00ccff[TR v" .. pfUI.translator_version .. "]|r" ..
        "  |cffffffaaEntrada:|r "  .. s.total_in  ..
        "  |cffffffaaSalida:|r "   .. s.total_out ..
        "  |cffffffaaCache:|r "    .. s.cache_hits .. " (" .. hitp .. "%)" ..
        "  |cffffffaaServidor:|r " .. detect
      )
    elseif msg == "reset" then
      -- Reinicia deteccion automatica del idioma del reino
      local v = pfUI.translator_realm_votes
      v.en       = 0
      v.es       = 0
      v.zh       = 0
      v.detected = nil
      DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Deteccion de idioma de reino reiniciada.")
    elseif msg == "debug" then
      local d = C.translator.debug_mode
      C.translator.debug_mode = (d == "1") and "0" or "1"
      DEFAULT_CHAT_FRAME:AddMessage(
        "|cff33ffcc[TR]|r Modo debug: " ..
        (C.translator.debug_mode == "1" and "|cff00ff00ON|r" or "|cffff4444OFF|r")
      )
    else
      pfUI.gui.ShowConfig(T["Translator"])
    end
  end

  -- Exponer funcion de traduccion para uso por addons externos
  pfUI.Translate = LocalTranslate

end)
