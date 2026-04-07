pfUI:RegisterModule("translator", "vanilla", function ()
  -- Traductor NATIVO Offline Bidireccional (ES <-> EN)
  -- Carga instantánea desde diccionarios indexados por longitud para n-gramas

  if not pfUI.translator_dicts then return end

  -- Algoritmo de Traducción In-Memory (Seguro con RegEx Fronterizo)
  local function LocalTranslate(text, dictionary, keyArray)
    if not text or type(text) ~= "string" then return text end
    
    -- Padding para simular fronteras de palabras en todo el texto
    local proc_text = " " .. strlower(text) .. " "
    local translation_occurred = false
    
    for _, key in ipairs(keyArray) do
      if strfind(proc_text, key) then
        local replace_value = dictionary[key]
        -- RegEx Vanilla: (%A) exige que no haya otra letra rodeando la palabra (Word Boundary Seguro)
        local safe_key = string.gsub(key, "(%W)", "%%%1") 
        local pattern = "(%A)(" .. safe_key .. ")(%A)"
        
        -- Ejecutar dos veces para abarcar solapamiento de fronteras ("a y b")
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
      -- Cortar el padding
      return strsub(proc_text, 2, -2)
    end
    return nil
  end

  local originalSendChatMessage = SendChatMessage
  SendChatMessage = function(msg, chatType, language, channel)
    if strsub(msg, 1, 1) == "/" or strsub(msg, 1, 1) == "." then
      originalSendChatMessage(msg, chatType, language, channel)
      return
    end

    local lower_type = strlower(chatType or "")
    if lower_type == "say" or lower_type == "yell" or lower_type == "party" or lower_type == "raid" or lower_type == "guild" or lower_type == "whisper" or lower_type == "channel" then
      local trans_msg = LocalTranslate(msg, pfUI.translator_dicts.esES_enUS, pfUI.translator_dicts.esES_keys)
      if trans_msg then
        originalSendChatMessage(trans_msg, chatType, language, channel)
        return
      end
    end
    originalSendChatMessage(msg, chatType, language, channel)
  end

  pfUI.translator = CreateFrame("Frame")
  pfUI.translator:RegisterEvent("PLAYER_ENTERING_WORLD")
  pfUI.translator:SetScript("OnEvent", function()
    pfUI.translator:UnregisterEvent("PLAYER_ENTERING_WORLD")
    
    -- Hook Seguro en Cascada (Solo Chats de Jugadores, Exceptúa Errores y Entorno)
    if not pfUI.GravityTRHooked then
      local originalChatHandler = ChatFrame_MessageEventHandler
      ChatFrame_MessageEventHandler = function(event)
        if event and strfind(event, "CHAT_MSG_") and arg1 then
          if event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" or event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_CHANNEL" then
             local trans_text = LocalTranslate(arg1, pfUI.translator_dicts.enUS_esES, pfUI.translator_dicts.enUS_keys)
             if trans_text then
                arg1 = trans_text .. " |cff33ffcc[TR]|r"
             end
          end
        end
        return originalChatHandler(event)
      end
      pfUI.GravityTRHooked = true
    end
  end)
end)
