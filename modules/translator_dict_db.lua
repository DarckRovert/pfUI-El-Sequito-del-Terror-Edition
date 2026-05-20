pfUI:RegisterModule("translator_dict_db", "vanilla", function ()
  -- ╔══════════════════════════════════════════════════════════════╗
  -- ║  BASE DE DATOS COLOSAL v6.0.0 — ULTIMATE-TIER SPELLS & QUESTS║
  -- ║  Inyector en Lote Comprimido de Alto Rendimiento             ║
  -- ╚══════════════════════════════════════════════════════════════╝

  local items = {
    {lang="es", text=""},
    {lang="en", text=""},
    {lang="zh", text=""}
  }

  -- Cuenta caracteres chinos (bytes UTF-8 de 3 bytes en rango 224-239)
  local function CountZhChars(s)
    if not s then return 0 end
    local n, i = 0, 1
    local len = strlen(s)
    while i <= len do
      local b = strbyte(s, i)
      if b and b >= 224 and b <= 239 then n = n + 1; i = i + 3
      elseif b and b >= 192 and b <= 223 then i = i + 2
      else i = i + 1 end
    end
    return n
  end

  local function add(es, en, zh)
    items[1].text = es
    items[2].text = en
    items[3].text = zh
    for i = 1, 3 do
      local item_i = items[i]
      local src_lang = item_i.lang
      local src_text = item_i.text
      if src_text and src_text ~= "" then
        if true then
          for j = 1, 3 do
            if i ~= j then
              local item_j = items[j]
              local dest_lang = item_j.lang
              local dest_text = item_j.text
              if dest_text and dest_text ~= "" then
                local isPhrase = strfind(src_text, " ") or strfind(dest_text, " ") or strlen(src_text) > 12 or src_lang == "zh"
                local prefix = src_lang .. "_" .. dest_lang
                -- FIX: NO aplicar strlower a texto chino — corrompe los bytes UTF-8
                local key = (src_lang == "zh") and src_text or strlower(src_text)
                if isPhrase then
                  if not pfUI.translator_dicts[prefix .. "_phrases"][key] then
                    pfUI.translator_dicts[prefix .. "_phrases"][key] = dest_text
                    table.insert(pfUI.translator_dicts[prefix .. "_keys"], key)
                  end
                else
                  pfUI.translator_dicts[prefix .. "_words"][key] = dest_text
                end
              end
            end
          end
        end
      end
    end
  end


  local function load_batch(batch)
    for _, line in ipairs(batch) do
      local p1 = strfind(line, "|", 1, true)
      if p1 then
        local es = strsub(line, 1, p1 - 1)
        local rest = strsub(line, p1 + 1)
        local p2 = strfind(rest, "|", 1, true)
        if p2 then
          local en = strsub(rest, 1, p2 - 1)
          local zh = strsub(rest, p2 + 1)
          add(es, en, zh)
        end
      end
    end
  end

  -- ============================================================
  -- LOTE A: FACULTADES Y HECHIZOS DE CLASE (CLASS SPELLS)
  -- ============================================================
  local spells_batch = {
    "-- Guerrero (Warrior)
    "cargar|charge|冲锋",
    "mortal strike|mortal strike|致死打击",
    "golpe mortal|mortal strike|致死打击",
    "grito de batalla|battle shout|战斗怒吼",
    "executar|execute|斩杀",
    "ejecutar|execute|斩杀",
    "provocar|taunt|嘲讽",
    "actitud defensiva|defensive stance|防御姿态",
    "actitud de batalla|battle stance|战斗姿态",
    "actitud rabiosa|berserker stance|狂暴姿态",
    "grito desmoralizador|demoralizing shout|挫志怒吼",
    "abrumar|overpower|压制",
    "embate de escudo|shield slam|盾牌猛击",
    "desarmar|disarm|缴械",
    "temeridad|recklessness|鲁莽",
    "torbellino|whirlwind|旋风斩",
    "filotormenta|bladestorm|利刃风暴",
    "grito desafiante|challenging shout|挑战怒吼",
    "bloqueo con escudo|shield block|盾牌格挡",
    "pared de escudo|shield wall|盾墙",
    "embate|slam|猛击",
    "desgarrar|rend|撕裂",
    "golpe heroico|heroic strike|英勇打击",
    "rajar|cleave|顺劈斩",
    "ola de choque|shockwave|震荡波",
    "-- Mago (Mage)
    "descarga de escarcha|frostbolt|寒冰箭",
    "descarga de frost|frostbolt|寒冰箭",
    "bola de fuego|fireball|火球术",
    "traslacion|blink|闪现",
    "traslación|blink|闪现",
    "intelecto arcano|arcane intellect|奥术智慧",
    "brillo arcano|arcane brilliance|奥术光辉",
    "polimorfia|polymorph|变形术",
    "oveja|sheep|变羊",
    "nova de escarcha|frost nova|冰霜新星",
    "deflagracion arcana|arcane explosion|奥术爆炸",
    "deflagración arcana|arcane explosion|奥术爆炸",
    "bloque de hielo|ice block|寒冰屏障",
    "barrera de hielo|ice barrier|寒冰护体",
    "poder arcano|arcane power|奥术强化",
    "defensa arcana|arcane power|奥术强化",
    "combustion|combustion|燃烧",
    "combustión|combustion|燃烧",
    "vena helada|icy veins|冰冷血脉",
    "venas heladas|icy veins|冰冷血脉",
    "evocacion|evocation|唤醒",
    "evocación|evocation|唤醒",
    "presencia de la mente|presence of mind|气定神闲",
    "presencia mental|presence of mind|气定神闲",
    "contrahechizo|counterspell|法术反制",
    "armadura de hielo|ice armor|冰霜护甲",
    "armadura de mago|mage armor|魔甲术",
    "armadura de arrabio|molten armor|熔岩护甲",
    "caida lenta|slow fall|缓落术",
    "caída lenta|slow fall|缓落术",
    "robar hechizo|spellsteal|法术吸取",
    "cono de frio|cone of cold|冰锥术",
    "cono de frío|cone of cold|冰锥术",
    "fogonazo|flamestrike|烈焰风暴",
    "crear agua|conjure water|造水术",
    "crear comida|conjure food|造食术",
    "portal orgrimmar|portal: orgrimmar|传送门：奥格瑞玛",
    "portal ventormenta|portal: stormwind|传送门：暴风城",
    "-- Sacerdote (Priest)
    "palabra de poder escudo|power word: shield|真言术：盾",
    "palabra de poder: escudo|power word: shield|真言术：盾",
    "sanacion relampago|flash heal|快速治疗",
    "sanación relámpago|flash heal|快速治疗",
    "palabra de poder dolor|shadow word: pain|真言术：痛",
    "palabra de poder: dolor|shadow word: pain|真言术：痛",
    "sanacion superior|greater heal|强效治疗术",
    "sanación superior|greater heal|强效治疗术",
    "rezo de sanacion|prayer of healing|治疗祷言",
    "rezo de sanación|prayer of healing|治疗祷言",
    "renovar|renew|恢复",
    "desvanecerse|fade|渐隐术",
    "mind blast|mind blast|心灵震爆",
    "explosion mental|mind blast|心灵震爆",
    "explosión mental|mind blast|心灵震爆",
    "forma de las sombras|shadowform|暗影形态",
    "forma de sombra|shadowform|暗影形态",
    "infusion de poder|power infusion|能量灌注",
    "infusión de poder|power infusion|能量灌注",
    "espiritu divino|divine spirit|神圣之灵",
    "espíritu divino|divine spirit|神圣之灵",
    "rezo de espiritu|prayer of spirit|精神祷言",
    "rezo de espíritu|prayer of spirit|精神祷言",
    "tortura mental|mind flay|精神鞭笞",
    "peste devoradora|devouring plague|噬灵疫病",
    "silencio|silence|沉默",
    "disipar magia|dispel magic|驱散魔法",
    "disipar en masa|mass dispel|群体驱散",
    "curar enfermedad|cure disease|祛病术",
    "resurreccion|resurrection|复活术",
    "resurrección|resurrection|复活术",
    "abrazo vampirico|vampiric embrace|吸血鬼的拥抱",
    "abrazo vampírico|vampiric embrace|吸血鬼的拥抱",
    "fuego interno|inner fire|心灵之火",
    "encadenar no-muerto|shackle undead|束缚亡灵",
    "-- Pícaro (Rogue)
    "golpe siniestro|sinister strike|邪恶攻击",
    "sigilo|stealth|潜行",
    "eviscerar|eviscerate|剔骨",
    "hacer picadillo|slice and dice|切割",
    "porrazo|sap|闷棍",
    "cegar|blind|致盲",
    "esfumarse|vanish|消失",
    "patada|kick|脚踢",
    "golpe bajo|cheap shot|偷袭",
    "garrote|garrote|绞喉",
    "emboscada|ambush|伏击",
    "puñalada|backstab|背刺",
    "punalada|backstab|背刺",
    "aluvion de acero|blade flurry|剑刃乱舞",
    "aluvión de acero|blade flurry|剑刃乱舞",
    "adrenalina|adrenaline rush|冲动",
    "subidon de adrenalina|adrenaline rush|冲动",
    "subidón de adrenalina|adrenaline rush|冲动",
    "sangre fria|cold blood|冷血",
    "sangre fría|cold blood|冷血",
    "preparacion|preparation|准备",
    "preparación|preparation|准备",
    "esprintar|sprint|疾跑",
    "forzar cerradura|pick lock|开锁",
    "robar|pickpocket|偷窃",
    "desarmar trampa|disarm trap|解除陷阱",
    "exponer armadura|expose armor|破甲",
    "golpe en los rinones|kidney shot|肾击",
    "golpe en los riñones|kidney shot|肾击",
    "-- Brujo (Warlock)
    "descarga de las sombras|shadow bolt|暗影箭",
    "corrupcion|corruption|腐蚀术",
    "corrupción|corruption|腐蚀术",
    "transfusion de vida|life tap|生命分流",
    "transfusión de vida|life tap|生命分流",
    "miedo|fear|恐惧术",
    "inmolar|immolate|献祭",
    "succionar vida|siphon life|生命虹吸",
    "piedra de salud|healthstone|治疗石",
    "piedra de alma|soulstone|灵魂石",
    "invocar diablillo|summon imp|召唤小鬼",
    "invocar abisario|summon voidwalker|召唤虚空行者",
    "invocar súcubo|summon succubus|召唤魅魔",
    "invocar sucubo|summon succubus|召唤魅魔",
    "maldicion de agonia|curse of agony|痛苦诅咒",
    "maldición de agonía|curse of agony|痛苦诅咒",
    "maldicion de la agonia|curse of agony|痛苦诅咒",
    "maldición de la agonía|curse of agony|痛苦诅咒",
    "maldicion de las sombras|curse of shadow|暗影诅咒",
    "maldición de las sombras|curse of shadow|暗影诅咒",
    "maldicion de los elementos|curse of elements|元素诅咒",
    "maldición de los elementos|curse of elements|元素诅咒",
    "maldicion de debilidad|curse of weakness|虚弱诅咒",
    "maldición de debilidad|curse of weakness|虚弱诅咒",
    "maldicion de temeridad|curse of recklessness|鲁莽诅咒",
    "maldición de temeridad|curse of recklessness|鲁莽诅咒",
    "maldicion de lenguas|curse of tongues|语言诅咒",
    "maldición de lenguas|curse of tongues|语言诅咒",
    "drenar vida|drain life|吸取生命",
    "drenar mana|drain mana|吸取法力",
    "drenar maná|drain mana|吸取法力",
    "drenar alma|drain soul|吸取灵魂",
    "lluvia de fuego|rain of fire|火雨",
    "infierno|inferno|地狱火",
    "desterrar|banish|放逐术",
    "ritual de invocacion|ritual of summoning|召唤仪式",
    "ritual de invocación|ritual of summoning|召唤仪式",
    "ropero|closet|拉人门",
    "portal de invocacion|summoning portal|召唤传送门",
    "portal de invocación|summoning portal|召唤传送门",
    "-- Druida (Druid)
    "rejuvenecimiento|rejuvenation|回春术",
    "recrecimiento|regrowth|愈合",
    "toque de sanacion|healing touch|治疗之触",
    "toque de sanación|healing touch|治疗之触",
    "fuego estelar|starfire|星火术",
    "colera|wrath|愤怒",
    "cólera|wrath|愤怒",
    "forma felina|cat form|猎豹形态",
    "forma de oso|bear form|熊形态",
    "forma de viaje|travel form|旅行形态",
    "estimulo|innervate|激活",
    "estímulo|innervate|激活",
    "marca de lo salvaje|mark of the wild|野性印记",
    "patita|motw|爪子",
    "enredar|entangling roots|纠缠根须",
    "raices enredaderas|entangling roots|纠缠根须",
    "raíces enredaderas|entangling roots|纠缠根须",
    "hibernar|hibernate|休眠",
    "forma de lechucho lunar|moonkin form|枭兽形态",
    "forma de lechúcho lunar|moonkin form|枭兽形态",
    "forma de arbol de vida|tree of life form|生命之树形态",
    "forma de árbol de vida|tree of life form|生命之树形态",
    "presura|dash|急奔",
    "azotar|bash|重击",
    "tranquilidad|tranquility|宁静",
    "limpiar veneno|cure poison|驱毒术",
    "eliminar maldicion|remove curse|解除诅咒",
    "eliminar maldición|remove curse|解除诅咒",
    "-- Paladín (Paladin)
    "imposicion de manos|lay on hands|圣疗术",
    "imposición de manos|lay on hands|圣疗术",
    "bendicion de poder|blessing of might|力量祝福",
    "bendición de poder|blessing of might|力量祝福",
    "luz sagrada|holy light|圣光术",
    "destello de luz|flash of light|圣光闪现",
    "escudo divino|divine shield|圣盾术",
    "burbuja|bubble|无敌",
    "bendicion de reyes|blessing of kings|王者祝福",
    "bendición de reyes|blessing of kings|王者祝福",
    "sentencia|judgement|审判",
    "consagracion|consecration|奉献",
    "consagración|consecration|奉献",
    "aura de retribucion|retribution aura|惩罚光环",
    "aura de retribución|retribution aura|惩罚光环",
    "aura de devocion|devotion aura|虔诚光环",
    "aura de devoción|devotion aura|虔诚光环",
    "aura de concentracion|concentration aura|专注光环",
    "aura de concentración|concentration aura|专注光环",
    "bendicion de salvacion|blessing of salvation|拯救祝福",
    "bendición de salvación|blessing of salvation|拯救祝福",
    "bendicion de sabiduria|blessing of wisdom|智慧祝福",
    "bendición de sabiduría|blessing of wisdom|智慧祝福",
    "bendicion de libertad|blessing of freedom|自由祝福",
    "bendición de libertad|blessing of freedom|自由祝福",
    "bendicion de proteccion|blessing of protection|保护祝福",
    "bendición de protección|blessing of protection|保护祝福",
    "bendicion de sacrificio|blessing of sacrifice|牺牲祝福",
    "bendición de sacrificio|blessing of sacrifice|牺牲祝福",
    "colera vengativa|avenging wrath|复仇之怒",
    "cólera vengativa|avenging wrath|复仇之怒",
    "alas|wings|翅膀",
    "choque sagrado|holy shock|神圣震击",
    "martillo de justicia|hammer of justice|制裁之锤",
    "martillo de colera|hammer of wrath|愤怒之锤",
    "martillo de cólera|hammer of wrath|愤怒之锤",
    "exorcismo|exorcism|驱邪术",
    "-- Chamán (Shaman)
    "descarga de relampagos|lightning bolt|闪电箭",
    "descarga de relámpagos|lightning bolt|闪电箭",
    "ola de sanacion|healing wave|治疗波",
    "ola de sanación|healing wave|治疗波",
    "choque de tierra|earth shock|地震术",
    "choque de llama|flame shock|烈焰震击",
    "choque de escarcha|frost shock|冰霜震击",
    "totem de nexo terrestre|earthbind totem|地缚图腾",
    "tótem de nexo terrestre|earthbind totem|地缚图腾",
    "totem de corriente de agua|healing stream totem|治疗之泉图腾",
    "tótem de corriente de agua|healing stream totem|治疗之泉图腾",
    "ansia de sangre|bloodlust|嗜血",
    "totem de fuerza de la tierra|strength of earth totem|大地之力图腾",
    "tótem de fuerza de la tierra|strength of earth totem|大地之力图腾",
    "totem viento furioso|windfury totem|风怒图腾",
    "tótem viento furioso|windfury totem|风怒图腾",
    "totem de viento furioso|windfury totem|风怒图腾",
    "tótem de viento furioso|windfury totem|风怒图腾",
    "wf|windfury|风怒",
    "arma viento furioso|windfury weapon|风怒武器",
    "escudo de relampagos|lightning shield|闪电盾",
    "escudo de relámpagos|lightning shield|闪电盾",
    "escudo de agua|water shield|水之护盾",
    "sanacion en cadena|chain heal|链状治疗",
    "sanación en cadena|chain heal|链状治疗",
    "relampago en cadena|chain lightning|闪电链",
    "relámpago en cadena|chain lightning|闪电链",
    "gracia de la naturaleza|nature's swiftness|自然迅捷",
    "rapidez de la naturaleza|nature's swiftness|自然迅捷",
    "reencarnacion|reincarnation|复生",
    "reencarnación|reincarnation|复生",
    "totem de temblor|tremor totem|战栗图腾",
    "tótem de temblor|tremor totem|战栗图腾",
    "totem de garra de piedra|stoneclaw totem|石爪图腾",
    "tótem de garra de piedra|stoneclaw totem|石爪图腾",
    "-- Cazador (Hunter)
    "disparo arcano|arcane shot|奥术射击",
    "picadura de serpiente|serpent sting|毒蛇钉刺",
    "marca del cazador|hunter's mark|猎人印记",
    "disparo de punteria|aimed shot|瞄准射击",
    "disparo de puntería|aimed shot|瞄准射击",
    "fingir muerte|feign death|假死",
    "trampa congelante|freezing trap|冰冻陷阱",
    "aspecto de guepardo|aspect of the cheetah|猎豹守护",
    "aspecto de la manada|aspect of the pack|豹群守护",
    "disparo silenciador|silencing shot|沉默射击",
    "disparo de quimera|chimera shot|奇美拉射击",
    "disparo de dispersion|scatter shot|驱散射击",
    "disparo de dispersión|scatter shot|驱散射击",
    "disparo de distraccion|distracting shot|扰乱射击",
    "disparo de distracción|distracting shot|扰乱射击",
    "disparo mortal|kill shot|杀戮射击",
    "redireccion|redirection|误导",
    "redirección|redirection|误导",
    "retirada|disengage|逃脱",
    "asustar bestia|scare beast|恐吓野兽",
    "rastrear humanoides|track humanoids|寻找人型生物",
    "rastrear no-muertos|track undead|寻找亡灵",
    "aspecto de mono|aspect of the monkey|灵猴守护",
    "aspecto de halcon|aspect of the hawk|雄鹰守护",
    "aspecto de halcón|aspect of the hawk|雄鹰守护",
    "revivir mascota|revive pet|复活宠物",
    "curar mascota|mend pet|治疗宠物",
    "alimentar mascota|feed pet|喂养宠物",
    "-- Buffs y utilidades de raid cruciales
    "resguardo contra el miedo|fear ward|防恐结界",
    "fear ward|fear ward|防恐",
    "defensa contra miedo|fear ward|防恐",
    "piedra de vida|healthstone|糖",
    "saludable|healthstone|糖",
    "mermelada|healthstone|糖",
    "piedra alma|soulstone|灵魂石",
    "ss|soulstone|灵魂石",
    "invocar void|summon voidwalker|召唤蓝胖",
    "invocar cazador|summon felhunter|召唤地狱犬",
    "felhunter|felhunter|狗/地狱犬",
    "desterrar|banish|放逐",
    "ritual de invocacion|ritual of summoning|拉人/召唤仪式",
    "fortaleza|power word: fortitude|耐力",
    "intelecto|arcane intellect|智力",
    "espiritu divino|divine spirit|精神",
    "marca de lo salvaje|mark of the wild|爪子",
    "motw|mark of the wild|爪子",
    "bendicion de reyes|blessing of kings|王者",
    "bendicion de poder|blessing of might|力量",
    "bendicion de sabiduria|blessing of wisdom|智慧",
    "bendicion de salvacion|blessing of salvation|拯救",
    "salvacion|salvation|拯救",
    "reyes|kings|王者",
    "sabiduria|wisdom|智慧",
    "viento furioso|windfury|风怒",
    "-- Adiciones masivas de hechizos (Clásicos y Custom)
    "estimulo|innervate|激活",
    "palabra de poder escudo|power word: shield|真言术：盾",
    "pw shield|power word: shield|真言术：盾",
    "escudo de tierra|earth shield|大地盾",
    "fuego de alma|soul fire|灵魂之火",
    "descarga de las sombras|shadow bolt|暗影箭",
    "dolor de sombras|shadow pain|暗影痛苦",
    "palabra de las sombras: dolor|shadow word: pain|暗影字：痛",
    "palabra de sombras dolor|shadow word: pain|暗影痛",
    "sed de sangre|bloodthirst|嗜血",
    "imposicion de manos|lay on hands|圣疗术",
    "tormenta divina|divine storm|神圣风暴",
    "desarmar trampas|disarm trap|解除陷阱",
    "fuego de fenix|phoenix fire|凤凰之火",
    "teletransporte|teleport|传送",
    "portal de mago|mage portal|传送门",
    "crear portal|conjure portal|制造传送门",
    "piedra de alma ss|soulstone|灵魂石",
    "ss en tank|ss on tank|给坦绑灵魂石",
    "piedra de alma en tanque|ss on tank|灵魂石给坦",
    "piedra de salud hs|healthstone|健康糖",
    "estimulo al heal|innervate on healer|激活给奶妈",
    "estimulo a mi|innervate me|给我激活",
    "estimular al heal|innervate healer|给治疗激活",
    "tacho de luz|lightwell|光明之泉",
    "pozo de luz|lightwell|光明之泉",
    "bendi de salvacion|blessing of salvation|拯救祝福",
    "bendi de libertad|blessing of freedom|自由祝福",
    "bendi de reyes|blessing of kings|王者祝福",
    "bendi de sabiduria|blessing of wisdom|智慧祝福",
    "bendi de poder|blessing of might|力量祝福",
    "bendi de proteccion|blessing of protection|保护祝福",
    "bendi de sacrificio|blessing of sacrifice|牺牲祝福",
    "gracia de aire|grace of air|风之优雅",
    "totem gracia de aire|grace of air totem|风之优雅图腾",
    "tótem de fuerza|strength totem|力量图腾",
    "totem de fuerza|strength totem|力量图腾",
    "totem de resistencia|resistance totem|抗性图腾",
    "tótem de resistencia|resistance totem|抗性图腾",
    "rejuvenecimiento|rejuvenation|回春术",
    "fuego feerico|faerie fire|精灵之火",
    "fuego feérico|faerie fire|精灵之火",
    "estimular|innervate|激活",
    "forma de oso temible|dire bear form|巨熊形态",
    "forma acuatica|aquatic form|水栖形态",
    "forma acuática|aquatic form|水栖形态",
    "huracan|hurricane|飓风",
    "huracán|hurricane|飓风",
    "fuego lunar|moonfire|月火术",
    "raices enredadoras|entangling roots|缠绕根须",
    "raíces enredadoras|entangling roots|缠绕根须",
    "arañazo|rake|斜掠",
    "aranazo|rake|斜掠",
    "destripar|rip|割裂",
    "magullar|maul|槌击",
    "azotar|swipe|横扫",
    "limpiar|cleanse|清算",
    "sello de rectitud|seal of righteousness|正义圣印",
    "sello de orden|seal of command|命令圣印",
    "aura de reprension|retribution aura|惩罚光环",
    "aura de reprensión|retribution aura|惩罚光环",
    "succion de vida|siphon life|生命虹吸",
    "succión de vida|siphon life|生命虹吸",
    "fuego infernal|hellfire|地狱烈焰",
    "lluvia de fuego|rain of fire|火焰之雨",
    "invocar manafago|summon felhunter|召唤地狱猎犬",
    "invocar manáfago|summon felhunter|召唤地狱猎犬",
    "crear piedra de salud|create healthstone|制造治疗石",
    "crear piedra de alma|create soulstone|制造灵魂石",
    "quemadura de las sombras|shadowburn|暗影灼烧",
    "sanacion en cadena|chain heal|治疗链",
    "sanación en cadena|chain heal|治疗链",
    "cadena de relampagos|chain lightning|闪电链",
    "cadena de relámpagos|chain lightning|闪电链",
    "descarga de relampagos|lightning bolt|闪电箭",
    "choque de llamas|flame shock|烈焰震击",
    "totem derribador|grounding totem|根基图腾",
    "tótem derribador|grounding totem|根基图腾",
    "totem fuerza de la tierra|earthbind totem|地缚图腾",
    "tótem fuerza de la tierra|earthbind totem|地缚图腾",
    "totem corriente de sanacion|healing stream totem|治疗之泉图腾",
    "tótem corriente de sanación|healing stream totem|治疗之泉图腾",
    "totem fuente de mana|mana spring totem|法力之泉图腾",
    "tótem fuente de maná|mana spring totem|法力之泉图腾",
    "totem abrasador|searing totem|灼热图腾",
    "tótem abrasador|searing totem|灼热图腾",
    "totem nova de fuego|fire nova totem|火焰新星图腾",
    "tótem nova de fuego|fire nova totem|火焰新星图腾",
    "arma muerdepiedras|rockbiter weapon|石化武器",
    "arma estigma de escarcha|frostbrand weapon|冰霜武器",
    "arma lengua de fuego|flametongue weapon|火舌武器",
    "lobo fantasmal|ghost wolf|幽魂之狼",
    "disparo automatico|auto shot|自动射击",
    "disparo automático|auto shot|自动射击",
    "multidisparo|multi-shot|多重射击",
    "disparo de conmocion|concussive shot|震荡射击",
    "disparo de conmoción|concussive shot|震荡射击",
    "disparo arcano|arcane shot|奥术射击",
    "picadura de vibora|viper sting|蝰蛇钉刺",
    "picadura de víbora|viper sting|蝰蛇钉刺",
    "fijar objetivo|hunter's mark|猎人印记",
    "trampa de escarcha|frost trap|冰霜陷阱",
    "trampa inmolacion|immolation trap|献祭陷阱",
    "trampa inmolación|immolation trap|献祭陷阱",
    "trampa explosiva|explosive trap|爆炸陷阱",
    "llamar a mascota|call pet|召唤宠物",
    "aliviar mascota|mend pet|治疗宠物",
    "retirar mascota|dismiss pet|解散宠物",
    "ojo de la bestia|eyes of the beast|野兽之眼",
    "aspecto del mono|aspect of the monkey|灵猴守护",
    "aspecto del halcon|aspect of the hawk|雄鹰守护",
    "aspecto del halcón|aspect of the hawk|雄鹰守护",
    "aspecto del guepardo|aspect of the cheetah|猎豹守护"
  }

  -- ============================================================
  -- LOTE B: MISIONES DE ALTA FRECUENCIA (QUESTS)
  -- ============================================================
  local quests_batch = {
    "el diplomatico perdido|the missing diplomat|失踪的使节",
    "el diplomático perdido|the missing diplomat|失踪的使节",
    "las colinas de tuercespina|the green hills of stranglethorn|荆棘谷 de 青山",
    "la batalla de darrowshire|the battle for darrowshire|达隆郡 de 战斗",
    "en mis suenos|in dreams|在梦中",
    "en mis sueños|in dreams|在梦中",
    "la gran mascarada|the great masquerade|大化装舞会",
    "una reliquia del pasado|a relic of the past|过去的遗物",
    "mision de tienda de supervivencia|survival tent quest|生存帐篷任务",
    "misión de tienda de supervivencia|survival tent quest|生存帐篷任务",
    "la prueba de los elementos|the test of elements|元素的试炼",
    "el libro de ur|the book of ur|乌尔之书",
    "el regreso de helcular|helcular's revenge|赫尔库拉的复仇",
    "el fin de los hermitas|the hermit's end|隐士 de 终结",
    "la leyenda de stalvan|the legend of stalvan|斯塔文的传说",
    "mor'ladim|mor'ladim|摩拉迪姆",
    "la caida de rocanegra|the fall of blackrock|黑石山的沦陷",
    "la caída de rocanegra|the fall of blackrock|黑石山的沦陷",
    "el gran rescate|the great rescue|伟大的营救",
    "el ataque de la plaga|the plague attack|天灾军团的进攻",
    "la purificacion de darrowshire|the purification of darrowshire|净化达隆郡",
    "la purificación de darrowshire|the purification of darrowshire|净化达隆郡",
    "armas de espiritu|spirit weapons|精神武器",
    "armas de espíritu|spirit weapons|精神武器",
    "el collar de lady sylvanas|lady sylvanas' necklace|希尔瓦娜斯的项链",
    "el colgante de sylvanas|lady sylvanas' necklace|希尔瓦娜斯的项链",
    "las pruebas del chaman|the shaman trials|萨满的试炼",
    "las pruebas del chamán|the shaman trials|萨满的试炼",
    "el destino de alicia|alicia's destiny|爱丽丝的命运",
    "el destino de alicia|alicia's destiny|爱丽丝的命运",
    "el corazon de hakkar|the heart of hakkar|哈卡的心脏",
    "el corazón de hakkar|the heart of hakkar|哈卡的心脏",
    "la cabeza de onyxia|the head of onyxia|奥妮克希亚的头颅",
    "la cabeza de nefarían|the head of nefarian|奈法利安的头颅",
    "la cabeza de nefarian|the head of nefarian|奈法利安的头颅",
    "el rescate de reginald windsor|the rescue of reginald windsor|营救雷吉纳德·温德索尔",
    "el regreso del heroe|the return of the hero|英雄的归来",
    "el regreso del héroe|the return of the hero|英雄的归来",
    "el vástago de onyxia|the brood of onyxia|奥妮克希亚的子嗣",
    "el vastago de onyxia|the brood of onyxia|奥妮克希亚的子嗣",
    "mision custom|custom quest|自定义任务",
    "misión custom|custom quest|自定义任务",
    "el secreto de alah'thalas|the secret of alah'thalas|亚拉萨拉斯的秘密",

    -- Misiones personalizadas de Turtle WoW
    "tienda de campana de supervivencia|survival tent quest|生存帐篷任务",
    "mision de campamento|survival tent quest|帐篷任务",
    "amenaza en el bosque oscuro|threat in the darkwood|暮色森林的威胁",
    -- Adiciones extras
    "el despertar de la plaga|the plague awakening|天灾的觉醒",
    "el despertar de la sombra|the shadow awakening|阴影的觉醒",
    "mision de montura|mount quest|坐骑任务",
    "misión de montura|mount quest|坐骑任务",
    "mision de clase|class quest|职业任务",
    "misión de clase|class quest|职业任务",
    "mision de gremio|guild quest|公会任务",
    "misión de gremio|guild quest|公会任务"
  }

  -- ============================================================
  -- LOTE C: OBJETOS E ÍTEMS COMUNES Y EXCLUSIVOS (ITEMS)
  -- ============================================================
  local items_batch = {
    "trueno furioso|thunderfury|雷霆之怒",
    "trueno furioso espada bendecida del hijo del viento|thunderfury",
    "blessed blade of the windseeker|雷霆之怒，逐风者的祝福之剑",
    "trueno furioso",
    "espada bendecida del hijo del viento|thunderfury",
    "sulfuras",
    "mano de ragnaros|sulfuras",
    "hand of ragnaros|萨弗拉斯，炎魔拉格纳罗斯之手",
    "sulfuras mano de ragnaros|sulfuras",
    "escama de tortuga|turtle scale|乌龟壳",
    "moneda turtle|turtle coin|乌龟币",
    "ficha de rol|roleplay token|角色扮演代币",
    "tienda de supervivencia|survival tent|生存帐篷",
    "tienda survival|survival tent|生存帐篷",
    "tabardo personalizado|custom tabard|定制战袍",
    "bolsa de 18 casillas|18 slot bag|18格包包",
    "bolsa de 20 casillas|20 slot bag|20格包包",
    "pocion de vida|health potion|生命药水",
    "poción de vida|health potion|生命药水",
    "pocion de mana|mana potion|法力药水",
    "poción de maná|mana potion|法力药水",
    "agua destilada|sweet nectar|甜花蜜",
    "pan de centeno|crusty rye bread|黑面包",
    "hoja de truenos|thunderfury|雷霆之怒",
    "ateish",
    "gran báculo del guardián|atiesh",
    "greatstaff of the guardian|埃提耶什，守护者的传说之杖",
    "atiesh gran baculo del guardian|atiesh",
    "atiesh",
    "gran baculo del guardian|atiesh",
    "atiesh|atiesh|埃提耶什",
    "crepusculo|twilight|暮光",
    "crepúsculo|twilight|暮光",
    "ashbringer corrupta|corrupted ashbringer|堕落的灰烬使者",
    "la ashbringer|ashbringer|灰烬使者",
    "cazador de hojas|leaf hunter|叶子弓",
    "arco de hoja de cazador|rhok'delar",
    "longbow of the ancient keepers|罗克迪拉，上古守护者的长弓",
    "rhok'delar|rhok'delar|罗克迪拉",
    "lok'delar|lok'delar|洛克迪拉",
    "bastón de la bendicion|benediction|祈福",
    "baston de la bendicion|benediction|祈福",
    "bastón de la bendición|benediction|祈福",
    "baston de la bendición|benediction|祈福",
    "la bendicion|benediction|祈福",
    "la bendición|benediction|祈福",
    "perdicion de los reyes|kingsfall|帝殒",
    "perdición de los reyes|kingsfall|帝殒",
    "kingsfall|kingsfall|帝殒",
    "el ojo de sulfuras|eye of sulfuras|萨弗拉斯之眼",
    "ojo de sulfuras|eye of sulfuras|萨弗拉斯之眼",
    "cristal de mana|mana crystal|法力水晶",
    "cristal de maná|mana crystal|法力水晶",
    "rubi de mana|mana ruby|法力红宝石",
    "rubí de maná|mana ruby|法力红宝石",
    "moneda de oro turtle|turtle gold coin|乌龟金币",
    "tabardo de gremio|guild tabard|公会战袍",
    "bolsa de viaje de 16 casillas|16 slot bag|16格包",
    "pocion de proteccion contra el fuego|fire protection potion|抗火药水",
    "poción de protección contra el fuego|fire protection potion|抗火药水",
    "pocion de proteccion contra la naturaleza|nature protection potion|自然防护药水",
    "poción de protección contra la naturaleza|nature protection potion|自然防护药水",
    "pocion de invisibilidad|invisibility potion|隐形药水",
    "poción de invisibilidad|invisibility potion|隐形药水",
    "elixir de elixir de gigante|elixir of giants|巨人药剂",
    "elixir de gigante|elixir of giants|巨人药剂",
    "elixir de fuerza de gigante|elixir of giants|巨人药剂",
    "frasco de poder supremo|flask of supreme power|超能合剂",
    "frasco de titan|flask of the titans|泰坦合剂",
    "frasco de titán|flask of the titans|泰坦合剂",
    "frasco de sabiduria destilada|flask of distilled wisdom|精炼智慧合剂",
    "frasco de sabiduría destilada|flask of distilled wisdom|精炼智慧合剂",
    "-- Ítems Turtle WoW e ítems emblemáticos de raid
    "tienda de supervivencia|survival tent|生存帐篷",
    "tienda survival|survival tent|帐篷",
    "tabardo de gremio custom|custom guild tabard|定制公会战袍",
    "bolsa de 18 casillas|18 slot bag|18格包",
    "bolsa de 20 casillas|20 slot bag|20格包",
    "bolsa de 24 casillas|24 slot bag|24格包",
    "ficha de rol|roleplay token|角色扮演币",
    "donacion de tienda|shop donation|商城赞助",
    "-- Adiciones extras
    "lagrima de neltharion|neltharion's tear|奈萨里奥之泪",
    "lágrima de neltharion|neltharion's tear|奈萨里奥之泪",
    "nelth tear|neltharion's tear|奈萨里奥之泪/泪",
    "talisman de poder efimero|talisman of ephemeral power|短暂能量护符",
    "talisman de poder efímero|talisman of ephemeral power|短暂能量护符",
    "set t1|t1 set|T1套",
    "set t2|t2 set|T2套",
    "set t3|t3 set|T3套",
    "tier 1|t1|T1",
    "tier 2|t2|T2",
    "tier 3|t3|T3",
    "montura epica|epic mount|千金马",
    "montura épica|epic mount|千金马",
    "montura rapida|fast mount|快马",
    "montura rápida|fast mount|快马",
    "piedra de hogar|hearthstone|炉石",
    "piedra hogar|hearthstone|炉石",
    "hearthstone|hearthstone|炉石",
    "dft|drake fang talisman|龙牙饰物",
    "talisman de colmillo de dragon|drake fang talisman|龙牙饰物",
    "talismán de colmillo de dragón|drake fang talisman|龙牙饰物",
    "zhm|zin'rokh",
    "destroyer of worlds|辛洛斯，诸界的毁灭者",
    "zinrokh|zin'rokh",
    "zin'rokh|zin'rokh",
    "crusader enchant|enchant weapon - crusader|附魔武器 - 十字军",
    "encantamiento de cruzado|enchant weapon - crusader|附魔武器 - 十字军",
    "encantamiento cruzado|enchant weapon - crusader|附魔武器 - 十字军",
    "spellpower enchant|enchant weapon - spellpower|附魔武器 - 法术能量",
    "encantamiento de poder de hechizo|enchant weapon - spellpower|附魔武器 - 法术能量",
    "encantamiento poder de hechizo|enchant weapon - spellpower|附魔武器 - 法术能量",
    "paño de tejido rúnico|runecloth|符文布",
    "pano de tejido runico|runecloth|符文布",
    "paño de seda|silk cloth|丝绸",
    "pano de seda|silk cloth|丝绸",
    "paño de tejido mágico|mageweave cloth|魔纹布",
    "pano de tejido magico|mageweave cloth|魔纹布",
    "paño de lino|linen cloth|亚麻布",
    "pano de lino|linen cloth|亚麻布",
    "paño de lana|wool cloth|毛料",
    "pano de lana|wool cloth|毛料",
    "paño vil|felcloth|恶魔布",
    "pano vil|felcloth|恶魔布",
    "loto negro|black lotus|黑莲花",
    "salvia plateada|mountain silversage|山鼠草",
    "capullo de loto|lotus bloom|莲花",
    "hierba cardenal|cardinal ruby|赤玉石",
    "flor de peste|plaguebloom|瘟疫花",
    "hojahielo|icecap|冰盖草",
    "sueñamaleza|dreamfoil|梦叶草",
    "suenamaleza|dreamfoil|梦叶草",
    "sangrerregia|kingsblood|皇血草",
    "raíz de tierra|earthroot|地根草",
    "raiz de tierra|earthroot|地根草",
    "musgo de tumba|grave moss|墓地苔",
    "acero vivo|living steel|活化钢",
    "barra de hierro|iron bar|铁锭",
    "barra de acero|steel bar|钢锭",
    "barra de mitril|mithril bar|秘银锭",
    "barra de torio|thorium bar|瑟银锭",
    "barra de arcanita|arcanite bar|奥金锭",
    "barra de veraplata|truesilver bar|真银锭",
    "barra de oro|gold bar|金锭",
    "barra de plata|silver bar|银锭",
    "barra de cobre|copper bar|铜锭",
    "barra de bronce|bronze bar|青铜锭",
    "barra de estaño|tin bar|锡锭",
    "barra de estano|tin bar|锡锭",
    "diamante de azeroth|azerothian diamond|艾泽拉斯钻石",
    "cristal arcano|arcane crystal|奥术水晶",
    "zafiro azul|blue sapphire|蓝宝石",
    "gran rubí|huge emerald|大块绿宝石",
    "gran rubi|huge emerald|大块绿宝石",
    "diamante estrella|star ruby|星木红宝石",
    "perla negra|black pearl|黑珍珠",
    "perla iridiscente|iridescent pearl|彩色珍珠",
    "perla dorada|golden pearl|金珍珠",
    "esencia de aire|essence of air|空气精华",
    "esencia de agua|essence of water|水之精华",
    "esencia de fuego|essence of fire|火焰精华",
    "esencia de tierra|essence of earth|大地精华",
    "esencia de no-muerto|essence of undeath|死灵精华",
    "gloria de los caídos|glory of the fallen|堕落者的荣耀",
    "lágrima de la diosa|tear of the goddess|女神之泪",
    "lagrima de la diosa|tear of the goddess|女神之泪",
    "gema del vacio|void gem|虚空宝石",
    "gema del vacío|void gem|虚空宝石",
    "crematoria|ashbringer|灰烬使者",
    "sulfuras|sulfuras|萨弗拉斯"
  }

  -- ============================================================
  -- LOTE D: JERGA AVANZADA DE INTERNET Y REAL LIFE EXTENDIDA
  -- ============================================================
  local slang_batch = {
    "no pasa nada|it's fine|没事",
    "esta bien|it's ok|没事",
    "está bien|it's ok|没事",
    "deja de llorar|stop crying|别哭了",
    "que pro|what a pro|太专业了",
    "eres el mejor|you are the best|你最棒了",
    "buen intento|nice try|尽力了",
    "no pasa nada buen intento|np nt|没事，尽力了",
    "tengo mucho lag|i have high lag|我好卡啊",
    "caida de internet|internet dropped|网络断了",
    "caída de internet|internet dropped|网络断了",
    "reiniciar pc|restart pc|重启电脑",
    "tengo sueno me voy a dormir|tired going to sleep|困了，去睡觉了",
    "tengo sueño me voy a dormir|tired going to sleep|困了，去睡觉了",
    "nos vemos manana|see you tomorrow|明天见",
    "nos vemos mañana|see you tomorrow|明天见",
    "hola a todos",
    "como estan|hi all how are you|大家好，你们好吗",
    "cómo están|hi all how are you|大家好，你们好吗",
    "mucho exito|good luck|祝成功",
    "mucho éxito|good luck|祝成功",
    "tengo que ir al bano|need to go to restroom|去个洗手间",
    "tengo que ir al baño|need to go to restroom|去个洗手间",
    "afk bano|afk bio|洗手间暂离",
    "afk baño|afk bio|洗手间暂离",
    "bio break|bio break|方便一下",
    "regreso en 5 minutos|back in 5 minutes|5分钟后回来",
    "regreso en 5 min|back in 5 min|5分钟回来",
    "dame lider|give me lead|给我队长",
    "dame líder|give me lead|给我队长",
    "pasa el lider|pass lead|传火/给队长",
    "pasa el líder|pass lead|传火/给队长",
    "hazme lider|make me lead|升我队长",
    "hazme líder|make me lead|升我队长",
    "necesitamos mas dps|need more dps|需要更多DPS",
    "necesitamos más dps|need more dps|需要更多DPS",
    "necesitamos healer|need healer|缺治疗",
    "necesitamos tanque|need tank|缺坦克",
    "el tanque se murio|tank died|坦倒了",
    "el tanque se murió|tank died|坦倒了",
    "cuidado con el pull|careful with pull|小心拉怪",
    "cuidado pull|care with pull|小心怪",
    "vamos a limpiar|let's clear|清小怪",
    "wipear|wipe|灭地",
    "es un wipe|it's a wipe|灭了",
    "revivan por favor|please resurrect|请复活我",
    "revivan pls|res pls|求复活",
    "dame resurreccion|res me pls|复活我",
    "dame resurrección|res me pls|复活我",
    "dame piedra de alma|soulstone me|给我绑灵魂石",
    "tira piedra de alma|ss me pls|绑灵魂石",
    "invoca por favor|summon please|求拉/召唤",
    "dame portal|portal please|求开门",
    "mago haz comida|mage conjure food|法师面包",
    "mago agua por favor|mage water please|法师给点水",
    "mago agua pls|mage water pls|法师水",
    "bufos por favor|buffs please|求buff",
    "dame bufos|buff me pls|给点buff",
    "marca de lo salvaje pls|motw pls|求爪子",
    "intelecto pls|intellect pls|求智力",
    "fortaleza pls|fortitude pls|求耐力",
    "espiritu pls|spirit pls|求精神",
    "espíritu pls|spirit pls|求精神",
    "reyes pls|kings pls|求王者",
    "poder de batalla pls|might pls|求力量祝福",
    "el healer no tiene mana|healer oom|治疗没蓝了",
    "el healer no tiene maná|healer oom|治疗没蓝了",
    "oom|out of mana|没蓝了",
    "estoy sin mana|out of mana|我没蓝了",
    "estoy sin maná|out of mana|我没蓝了",
    "beber agua|drinking water|回蓝中",
    "esperen|wait|等等",
    "esperen un momento|wait a moment|等一下",
    "listo|ready|准备好了",
    "listos|ready|好了吗",
    "check de listos|ready check|就位确认",
    "rc|ready check|就位确认",
    "pullear|pulling|拉怪了",
    "ya voy|i am coming|来了",
    "buena batalla|good fight|好样的",
    "buen intento|nice try|虽败犹荣",
    "felicidades|congrats|恭喜",
    "felicidades por el nivel|grats on level|恭喜升级",
    "felicidades por el drop|grats on drop|恭喜拿装备",
    "grats|congrats|恭喜",
    "gz|congrats|恭喜",
    "gracias a todos|thanks all|谢谢大家",
    "gracias por el grupo|thanks for group|谢谢组队",
    "buen grupo|good group|优秀的队伍",
    "-- Abreviaturas de chat y reclutamientos avanzados (LFG/LFM)
    "necesito summon|need summon|求拉",
    "necesito invocacion|need summon|求拉",
    "need summon|need summon|求拉",
    "click portal|click portal|点门",
    "123 en el portal|click portal 123|点门123",
    "123 port|click portal 123|123点门",
    "por favor invoca|summon pls|拉人谢谢",
    "inv pls|invite please|求组",
    "invitame por favor|invite please|组我谢谢",
    "lf1m tank|need 1 tank|缺1坦",
    "lf2m dps|need 2 dps|缺2输出",
    "lf1m healer|need 1 healer|缺1奶",
    "manco|noob|菜鸟",
    "carreado|boosted|被带的",
    "carrear|boost|带刷",
    "noob|noob|新手/菜鸟",
    "wipe total|wipe|灭地",
    "666|awesome|666/牛逼",
    "niu bi|pro|牛逼",
    "sb|idiot|傻逼",
    "my bad|my bad|我的错",
    "wd|my bad|我的/抱歉",
    "-- Adiciones extras
    "ayudame por favor|help me please|求帮/帮我",
    "ayudame pls|help pls|求帮",
    "ayuda en mision|quest help|任务求助",
    "mision de grupo|group quest|精英任务",
    "grupo por favor|group please|求组/组队",
    "invitame pls|invite pls|求拉/求组",
    "estoy listo|i am ready|我准备好了",
    "estamos listos|we are ready|我们好了",
    "espera un segundo|wait a sec|等一下",
    "ya voy de camino|on my way|我在路上了",
    "ya vuelvo|back soon|马上回来",
    "buen intento a todos|nice try all|尽力了大家",
    "gracias por el carry|thanks for carry|谢谢大佬带",
    "gracias carry|thanks carry|谢谢带我",
    "carry de mazmorra|dungeon carry|副本带刷",
    "carry de oro|gold carry|金币带刷",
    "busco comprador|selling run|金团招买家",
    "busco tank|looking for tank|求组坦克",
    "busco heal|looking for heal|求组治疗",
    "dps extra|extra dps|多余的DPS",
    "mas dps|more dps|更多输出",
    "no ninja loot|no ninja|不要毛装备",
    "loot libre|free loot|自由拾取",
    "loot de grupo|group loot|队伍分配",
    "botin libre|free loot|自由分配",
    "maestro despojador|master loot|分配者/主分配",
    "ml|master looter|队长分配",
    "gdkp|gdkp|金团/G团",
    "dkp|dkp|DKP团",
    "roll de dados|roll dice|掷骰子",
    "tirar dados|roll dice|掷骰子",
    "dame dados|roll me|掷骰子",
    "saque 100|rolled 100|roll了100",
    "saque 1|rolled 1|roll了1",
    "mala suerte|bad luck|运气差",
    "buena suerte con el loot|good luck loot|祝好运掉落",
    "felicidades amigo|grats buddy|恭喜兄弟",
    "gracias amigo|thanks mate|多谢兄弟",
    "juego aburrido|boring game|无聊的游戏",
    "no seas toxico|don't be toxic|别这么暴躁",
    "no seas tóxico|don't be toxic|别这么暴躁",
    "estoy comiendo|i'm eating|吃饭去",
    "voy al bano|brb bathroom|去洗手间",
    "voy al baño|brb bathroom|去洗手间",
    "juego con lag|i'm lagging|卡死了",
    "me da tirones|stuttering|掉帧",
    "cuantos ms tienes|what's your ping|你多少延迟",
    "cuántos ms tienes|what's your ping|你多少延迟",
    "cuanto ping|how much ping|延迟多高",
    "cuánto ping|how much ping|延迟多高",
    "tengo ping alto|high ping|延迟太高了",
    "me desconecte|disconnected|掉线了",
    "me desconecté|disconnected|掉线了",
    "esperando a un amigo|waiting for a friend|等朋友",
    "viene mi amigo|friend is coming|朋友马上来",
    "solo hablamos espanol|we only speak spanish|我们只说西班牙语",
    "solo hablamos español|we only speak spanish|我们只说西班牙语",
    "no hablo ingles|i don't speak english|不会说英语",
    "no hablo inglés|i don't speak english|不会说英语",
    "no hablo chino|i don't speak chinese|不会说中文",
    "puedes usar traductor|can you use translator|能用翻译器吗",
    "usa pfui translator|use pfui translator|用pfUI翻译器吧",
    "alguien habla espanol|anyone speaks spanish|有人说西班牙语吗",
    "alguien habla español|anyone speaks spanish|有人说西班牙语吗",
    "hermandad latina|latin guild|拉美公会",
    "hermandad hispana|spanish guild|西班牙语公会",
    "reclutando latinos|recruiting latins|招募拉美玩家",
    "hola a todos|hi everyone|大家好",
    "gracias por el grupo|thanks for the group|谢谢组队",
    "buen grupo|good group|好队伍",
    "buena party|good party|好队伍",
    "GGwp|good game well played|打得好",
    "ggs|good games|打得好",
    "lol|laugh out loud|哈哈",
    "lmao|laugh my ass off|笑死了",
    "rofl|rolling on floor laughing|笑死我了",
    "wtf|what the fuck|什么鬼",
    "omg|oh my god|我的天",
    "noob|noob|菜鸟",
    "manco|noob|手残/菜鸟",
    "pro|pro|大神",
    "maestro|master|师傅",
    "jefe|boss|老板",
    "tkm|love you|爱你",
    "te quiero|i love you|我爱你",
    "besos|kisses|亲亲",
    "abrazos|hugs|抱抱",
    "saludos|regards|问候"
  }

  -- ============================================================
  -- LOTE E: ZONAS Y CAPITALES (ZONES)
  -- ============================================================
  local zones_batch = {
    "páramos de poniente|westfall|西部荒野",
    "paramos de poniente|westfall|西部荒野",
    "bosque de elwynn|elwynn forest|艾尔文森林",
    "bosque del ocaso|duskwood|暮色森林",
    "crestagrana|redridge|赤脊山",
    "montañas de crestagrana|redridge mountains|赤脊山",
    "vallesangre|stranglethorn vale|荆棘谷",
    "tuercespina|stranglethorn vale|荆棘谷",
    "valle de tuercespina|stranglethorn vale|荆棘谷",
    "arathi|arathi|阿拉希高地",
    "tierras altas de arathi|arathi highlands|阿拉希高地",
    "los páramos|the barrens|贫瘠之地",
    "los paramos|the barrens|贫瘠之地",
    "páramos|barrens|贫瘠之地",
    "paramos|barrens|贫瘠之地",
    "marjal revolcafango|dustwallow marsh|尘泥沼泽",
    "mil agujas|thousand needles|千针石林",
    "tanaris|tanaris|塔纳利斯",
    "cráter de un'goro|un'goro crater|安戈洛环形山",
    "crater de un'goro|un'goro crater|安戈洛环形山",
    "silithus|silithus|希利苏斯",
    "cuna de invierno|winterspring|冬泉谷",
    "tierras de la peste del este|eastern plaguelands|东瘟疫之地",
    "tierras de la peste del oeste|western plaguelands|西瘟疫之地",
    "estepas ardientes|burning steppes|燃烧平原",
    "garganta de fuego|searing gorge|灼热峡谷",
    "el paso de la muerte|deadwind pass|逆风小径",
    "valle de fresno|ashenvale|灰谷",
    "ashenvale|ashenvale|灰谷",
    "desolace|desolace|凄凉之地",
    "claros de tirisfal|tirisfal glades|提瑞斯法林地",
    "bosque de argénteos|silverpine forest|银松森林",
    "bosque de argenteos|silverpine forest|银松森林",
    "laderas de trabalomas|hillsbrad foothills|希尔斯布莱德丘陵",
    "trabalomas|hillsbrad|希尔斯布莱德",
    "tierras del interior|the hinterlands|辛特兰",
    "ventormenta|stormwind|暴风城",
    "forjaz|ironforge|铁炉堡",
    "darnassus|darnassus|达纳苏斯",
    "orgrimmar|orgrimmar|奥格瑞玛",
    "cima del trueno|thunder bluff|雷霆崖",
    "entrañas|undercity|幽暗城",
    "entranas|undercity|幽暗城",
    "bahía del botín|booty bay|藏宝海湾",
    "bahia del botin|booty bay|藏宝海湾",
    "booty bay|booty bay|藏宝海湾",
    "-- Adiciones extras de zonas y subzonas
    "isla de lapidis|lapidis isle|拉皮迪斯岛",
    "isla lapidis|lapidis isle|拉皮迪斯岛",
    "isla de gillijim|gillijim's isle|吉利吉姆岛",
    "isla gillijim|gillijim's isle|吉利吉姆岛",
    "alah'thalas|alah'thalas|亚拉萨拉斯",
    "tierras altas de thalassian|thalassian highlands|萨拉斯高地",
    "mirza's oasis|mirza's oasis|米尔扎绿洲",
    "oasis de mirza|mirza's oasis|米尔扎绿洲",
    "oasis mirza|mirza's oasis|米尔扎绿洲",
    "valle de alanah|alanah valley|阿兰纳谷",
    "alanah valley|alanah valley|阿兰纳谷",
    "islas de bruma|misty islands|迷雾群岛",
    "islas misty|misty islands|迷雾群岛",
    "cumbres de tormenta|alterac mountains|奥特兰克山脉",
    "montañas de alterac|alterac mountains|奥特兰克山脉",
    "valle de las pruebas|valley of trials|试炼谷",
    "valle de pruebas|valley of trials|试炼谷",
    "cerrotajo|razor hill|剃刀岭",
    "aldea sen'jin|sen'jin village|森金村",
    "aldea senjin|sen'jin village|森金村",
    "islas del eco|echo isles|回音群岛",
    "islas eco|echo isles|回音群岛",
    "cresta del trueno|thunder ridge|雷霆山",
    "barranco seco|drygulch ravine|枯谷",
    "fuerte tiragarde|tiragarde keep|提拉加德城堡",
    "terrenos erizados|razormane grounds|剃刀野猪营地",
    "roca del craneo|skull rock|骷髅石",
    "roca del cráneo|skull rock|骷髅石",
    "mesa de nube roja|redcloud mesa|红云台地",
    "nube roja|redcloud mesa|红云台地",
    "aldea pezuna de sangre|bloodhoof village|血蹄村",
    "aldea pezuña de sangre|bloodhoof village|血蹄村",
    "caravana saqueada|ravaged caravan|被毁的商队",
    "rocas rojas|red rocks|红石谷",
    "mina de ventura y cia|the venture co. mine|风险投资公司矿井",
    "mina de ventura y cía|the venture co. mine|风险投资公司矿井",
    "excavacion de bael'dun|bael'dun digsite|巴尔丹挖掘场",
    "excavación de bael'dun|bael'dun digsite|巴尔丹挖掘场",
    "campamento taurajo|camp taurajo|陶拉祖营地",
    "el cruce|the crossroads|十字路口",
    "el lodazal de lodo|the sludge fen|淤泥沼泽",
    "cumbre niebla de pavor|dreadmist peak|畏雾山峰",
    "fuerte de la guardia del norte|northwatch hold|北方城堡",
    "fuerte guardia del norte|northwatch hold|北方城堡",
    "pozas olvidadas|the forgotten pools|被遗忘的池塘",
    "oasis de agua frondosa|lushwater oasis|甜水绿洲",
    "oasis estancado|the stagnant oasis|死水绿洲",
    "trinquete|ratchet|棘齿城",
    "dalaran|dalaran|达拉然",
    "strahnbrad|strahnbrad|斯坦恩布莱德",
    "ruinas de alterac|ruins of alterac|奥特兰克废墟",
    "solar de northfold|northfold manor|诺斯弗德农场",
    "granja go'shek|goshek farm|高雪克农场",
    "granja goshek|goshek farm|高雪克农场",
    "sentinela de refugio|refuge point|避难谷地",
    "sentinela de martillo|hammerfall|落锤镇",
    "castillo de stromgarde|stromgarde keep|激流堡",
    "castillo stromgarde|stromgarde keep|激流堡",
    "cueva de faldir|faldir's cove|法尔迪平湾",
    "viaducto de thandol|thandol span|萨多尔大桥",
    "kargath|kargath|卡加斯",
    "portal oscuro|dark portal|黑暗之门",
    "castillo de nethergarde|nethergarde keep|守望堡",
    "castillo nethergarde|nethergarde keep|守望堡",
    "la muralla|the bulwark|堡垒",
    "campo santo|deathknell|丧钟镇",
    "granja solliden|solliden farmstead|索利丹农场",
    "molinos de agamand|agamand mills|阿加曼德磨坊",
    "rémol|brill|布瑞尔",
    "remol|brill|布瑞尔",
    "isla de fenris|fenris isle|芬里斯岛",
    "isla fenris|fenris isle|芬里斯岛",
    "aldea piroleña|pyrewood village|焚木村",
    "aldea pirolena|pyrewood village|焚木村",
    "castillo de colmillo oscuro|shadowfang keep|影牙城堡",
    "castillo colmillo oscuro|shadowfang keep|影牙城堡",
    "sfk|shadowfang keep|影牙城堡",
    "vega del amparo|hearthglen|壁炉谷",
    "ruinas de andorhal|ruins of andorhal|安多哈尔废墟",
    "colina del pesar|sorrow hill|悔恨丘陵",
    "lago darrowmere|darromere lake|达隆米尔湖",
    "caer darrow|caerdarrow|凯尔达隆",
    "villa de darrow|darrowshire|达隆郡",
    "mano de tyr|tyr's hand|提尔之手",
    "capilla de la esperanza de la luz|light's hope chapel|圣光之愿礼拜堂",
    "capilla esperanza de la luz|light's hope chapel|圣光之愿礼拜堂",
    "costasur|southshore|南海镇",
    "molino de tarren|tarren mill|塔伦米尔",
    "castillo de durnholde|durnholde keep|敦霍尔德城堡",
    "castillo durnholde|durnholde keep|敦霍尔德城堡",
    "isla de la purgación|purgation isle|净化之岛",
    "isla de la purgacion|purgation isle|净化之岛",
    "pico nido de águilas|aerie peak|鹰巢山",
    "pico nido de aguilas|aerie peak|鹰巢山",
    "jintha'alor|jintha'alor|辛萨罗",
    "altar de zul|the altar of zul|祖尔祭坛",
    "kharanos|kharanos|卡加斯 / 卡拉诺斯",
    "anvilmar|anvilmar|安威玛尔",
    "cantera de gol'bolar|gol'bolar quarry|戈尔波拉采石场",
    "valle de villanorte|northshire valley|北郡山谷",
    "lago de cristal|crystal lake|水晶湖",
    "mina del abismo de far|fargodeep mine|法戈第矿洞",
    "villadorada|goldshire|闪金镇",
    "campamento leñador de la vega del este|eastvale logging camp|东谷伐木场",
    "campamento lenador de la vega del este|eastvale logging camp|东谷伐木场",
    "torre de azora|tower of azora|阿佐拉之塔",
    "karazhan|karazhan|卡拉赞",
    "cruce del hombre muerto|deadman's crossing|死人路口",
    "villa oscura|duskwood / darkshire|夜色镇",
    "colina del cuervo|ravenhill|乌鸦岭",
    "arboleda del crepúsculo|twilight grove|暮色森林",
    "arboleda del crepusculo|twilight grove|暮色森林",
    "thelsamar|thelsamar|塞尔萨玛",
    "presa de la cantera|stonewrought dam|巨石水坝",
    "villa del lago|lakeshire|湖畔镇",
    "castillo de stonewatch|stonewatch|石堡",
    "expedición de nesingwary|nesingwary expedition|纳辛贝里远征队",
    "expedicion de nesingwary|nesingwary expedition|纳辛贝里远征队",
    "campamento base de grom'gol|grom'gol base camp|格罗姆高营地",
    "campamento base de gromgol|grom'gol base camp|格罗姆高营地",
    "rocard|stonard|斯通纳德",
    "estanque de las lágrimas|pool of tears|泪水之池",
    "estanque de las lagrimas|pool of tears|泪水之池",
    "arroyo de la luna|moonbrook|月溪镇",
    "colina del centinela|sentinel hill|哨兵岭",
    "faro de poniente|westfall lighthouse|西部荒野灯塔",
    "pistas de centelleo|the shimmering flats|闪光平原",
    "puerto de bonvapor|steamwheedle port|热砂港",
    "gadgetzan|gadgetzan|加基森",
    "valle de los vigilantes|valley of the watchers|观察者谷",
    "fuerte cenarion|cenarion hold|塞纳里奥要塞",
    "valle de las lanzas|valley of the spears|巨齿谷",
    "aldea de viento del sur|southwind village|南风村",
    "vista eterna|everlook|永望镇",
    "bastión de los fauces de madera|timbermaw hold|木喉要塞",
    "bastion de los fauces de madera|timbermaw hold|木喉要塞",
    "bastión de plumaluna|feathermoon stronghold|羽月要塞",
    "bastion de plumaluna|feathermoon stronghold|羽月要塞",
    "claro de la branda del halcón|talonbranch glade|爪枝林",
    "claro de la branda del halcon|talonbranch glade|爪枝林",
    "aldea brisa de plata|silverbreeze village|银风村",
    "aldea brisa de estrellas|starbreeze village|星风村",
    "nordanaar|nordanaar|诺丹纳",
    "arboleda creciente|crescent grove|新月林地",
    "tumba de los siete|tomb of the seven|七贤之墓",
    "tumba de los 7|tomb of the seven|七贤之墓",
    "campamento rebelde|rebel camp|反抗军营地",
    "campamento base de thalassian|thalassian base camp|萨拉斯大本营",
    "valle de la luna este|eastmoon ruins|东月废墟",
    "valle de la luna sur|southmoon ruins|南月废墟",
    "tierras secas|the dry hills|干旱丘陵",
    "isla del terror|isle of dread|恐惧之岛",
    "isla de otoño eterno|isle of eternal autumn|永秋岛",
    "puesto maulogg|maulogg post|毛洛格哨站",
    "refugio maulogg|maulogg refuge|毛洛格避难所",
    "cima terror|dreadmist peak|畏雾山峰",
    "valle devastado|feralscar vale|野性伤痕山谷",
    "paso de los riscos|cliff pass|悬崖小径",
    "colina de brujas|witch hill|女巫岭",
    "valle del rocío|dew valley|露水谷",
    "tumba de ironbeard|ironbeard's tomb|铁须之墓",
    "fortaleza gnarlpine|gnarlpine hold|瘤木要塞",
    "puesto forestal de hacha de trueno|thunderaxe fortress|雷斧堡垒",
    "muro de thoradin|thoradin's wall|索拉丁之墙",
    "arroyo del terror|terror run|恐惧小径",
    "tumba de uter|uther's tomb|乌瑟尔之墓",
    "el remolino|the maelstrom|大漩涡",
    "santuario esmeralda|emerald sanctuary|翡翠圣地",
    "campamento de kargath|kargath expedition|卡加斯远征军",
    "isla purificación|purgation isle|净化之岛",
    "isla jaguero|jaguero isle|哈圭罗岛",
    "campamento grom'gol|grom'gol base camp|格罗姆高营地",
    "asentamiento nethander|nethander stead|尼桑德农场",
    "el marjal resbaladizo|the slithering scar|泥泞低地",
    "minas de la muerte|deadmines|死亡矿井",
    "puesto libre de viento|freewind post|乱风岗",
    "puesto del hacha|axepost|战斧哨站",
    "cañón del eco|echo canyon|回音峡谷",
    "el bosque oscuro|darkwoods|黑暗森林",
    "las ruinas de andorhal|the ruins of andorhal|安多哈尔废墟",
    "campamento nesingwary|nesingwary's expedition|奈辛瓦里远征队",
    "arena de gurubashi|gurubashi arena|古拉巴什竞技场",
    "zulfarrak|zul'farrak|祖尔法拉克",
    "cueva de los lamentos|wailing caverns|哀嚎洞穴",
    "sima ígnea|ragefire chasm|怒焰裂谷",
    "sima ignea|ragefire chasm|怒焰裂谷",
    "kraul escaldarrajes|razorfen kraul|剃刀沼泽",
    "zahúrda rojiza|razorfen downs|剃刀高地",
    "cavernas de brazanegra|blackfathom deeps|黑暗深渊",
    "gnomeregan|gnomeregan|诺莫瑞根",
    "monasterio escarlata|scarlet monastery|血色修道院",
    "urldaman|uldamen|奥达曼",
    "profundidades de roca negra|blackrock depths|黑石深渊",
    "cumbre de roca negra|blackrock spire|黑石塔",
    "nucleo de magma|molten core|熔火之心",
    "núcleo de magma|molten core|熔火之心",
    "guarida de alanegra|blackwing lair|黑翼之巢",
    "naxxramas|naxxramas|纳克萨玛斯"
  }

  -- ============================================================
  -- LOTE F: MECÁNICAS DE COMBATE Y TERMINOLOGÍA PVE/PVP (MECHANICS)
  -- ============================================================
  local mechanics_batch = {
    "control de masas|crowd control|控怪/羊/恐惧",
    "cc|crowd control|控制/控怪",
    "linea de vision|line of sight|卡视角",
    "línea de visión|line of sight|卡视角",
    "los|line of sight|卡视角",
    "daño en el tiempo|damage over time|持续伤害",
    "dano en el tiempo|damage over time|持续伤害",
    "dot|damage over time|持续伤害/DOT",
    "sanacion en el tiempo|healing over time|持续治疗",
    "sanación en el tiempo|healing over time|持续治疗",
    "hot|healing over time|持续治疗/HOT",
    "daño por segundo|damage per second|伤害输出/DPS",
    "dano por segundo|damage per second|伤害输出/DPS",
    "dps|damage per second|输出/伤害",
    "tanque|tank|坦克/防战/熊T",
    "healer|healer|治疗/奶妈",
    "curador|healer|治疗/奶妈",
    "esbirro|add|小怪",
    "esbirros|adds|小怪",
    "bicho|mob|小怪",
    "bichos|mobs|怪",
    "jefe|boss|首领/BOSS",
    "limpiar|clear|清怪",
    "pull|pull|拉怪",
    "atraer|pull|拉怪",
    "foco|focus|集火/单点",
    "disipar|dispel|驱散",
    "cortar hechizo|interrupt|打断施法",
    "cortar cast|interrupt|打断",
    "amenaza|threat|仇恨",
    "aggro|aggro|仇恨/怪打我",
    "robar agro|draw aggro|OT/抢仇恨",
    "robar aggro|draw aggro|OT/抢仇恨",
    "ot|overthreat|OT/仇恨失控",
    "kitear|kiting|风筝",
    "hacer cometa|kiting|拉风筝",
    "combatir|combat|战斗",
    "en combate|in combat|战斗中",
    "fuera de combate|out of combat|脱战/战斗外",
    "resucitar|resurrect|复活",
    "revivir|revive|复活",
    "buff|buff|增益/Buff",
    "debuff|debuff|减益/Debuff",
    "veneno|poison|毒",
    "maldicion|curse|诅咒",
    "maldición|curse|诅咒",
    "enfermedad|disease|疾病",
    "magia|magic|魔法",
    "resistencia|resistance|抗性",
    "armadura|armor|护甲"
  }

  -- ============================================================
  -- LOTE G: PROFESIONES, MATERIALES Y COMERCIO (PROFESSIONS & TRADE)
  -- ============================================================
  local professions_batch = {
    -- Profesiones Primarias
    "alquimia|alchemy|炼金术",
    "herboristería|herbalism|草药学",
    "herboristeria|herbalism|草药学",
    "minería|mining|采矿",
    "mineria|mining|采矿",
    "herrería|blacksmithing|锻造",
    "herreria|blacksmithing|锻造",
    "ingeniería|engineering|工程学",
    "ingenieria|engineering|工程学",
    "peletería|leatherworking|制皮",
    "peleteria|leatherworking|制皮",
    "desollar|skinning|剥皮",
    "sastrería|tailoring|裁缝",
    "sastreria|tailoring|裁缝",
    "encantamiento|enchanting|附魔",
    "encantamiento|enchanting|附魔",

    -- Profesiones Secundarias y Custom
    "supervivencia|survival|生存",
    "cocina|cooking|烹饪",
    "pesca|fishing|钓鱼",
    "primeros auxilios|first aid|急救",

    -- Especializaciones e interacciones
    "ingenieria gnomica|gnomish engineering|侏儒工程学",
    "ingeniería gnómica|gnomish engineering|侏儒工程学",
    "ingenieria goblin|goblin engineering|地精工程学",
    "ingeniería goblin|goblin engineering|地精工程学",
    "alquimia de transmutacion|transmutation alchemy|转化大师",
    "alquimia de transmutación|transmutation alchemy|转化大师",
    "elixires|elixirs|药剂",
    "pociones|potions|药水",

    -- Comercio y Economía
    "craftear|craft|制作",
    "crafteo|craft|制作",
    "materiales|mats|材料",
    "receta|recipe|配方",
    "patrón|pattern|图纸",
    "patron|pattern|图纸",
    "comerciar|trade|交易",
    "ligado al equipar|bind on equip|装备后绑定",
    "ligado al recoger|bind on pickup|拾取后绑定",
    "boe|bind on equip|装绑",
    "bop|bind on pickup|拾绑",
    "banco de gremio|guild bank|公会仓库",
    "subasta|auction house|拍卖行",
    "ah|auction house|拍卖行",
    "compro|buying|收购",
    "vendo|selling|出售",
    "cambio|trading|交换",
    "gremio|guild|公会",
    "hermandad|guild|公会",
    "invitar al gremio|guild invite|公会邀请",
    "inv al gremio|guild invite|公会邀请"
  }

  -- ============================================================
  -- LOTE H: CONTENIDO, ZONAS, MAZMORRAS Y MODOS CUSTOM DE TURTLE WOW
  -- ============================================================
  local turtle_custom_batch = {
    "-- Mazmorras y Raids Custom
    "arboleda creciente|crescent grove|新月林地",
    "arboleda|crescent grove|新月林地",
    "tumba de los siete|tomb of the seven|七贤之墓",
    "tumba de los 7|tomb of the seven|七贤之墓",
    "laboratorio de alah'thalas|alah'thalas laboratory|亚拉萨拉斯实验室",
    "alah'thalas|alah'thalas|亚拉萨拉斯",
    "-- Geografía y Zonas Custom
    "isla de gillijim|gillijim's isle|吉利吉姆岛",
    "isla gillijim|gillijim's isle|吉利吉姆岛",
    "isla de lapidis|lapidis isle|拉皮迪斯岛",
    "isla lapidis|lapidis isle|拉皮迪斯岛",
    "tierras altas destrozadas|shattered highlands|破碎高地",
    "monte hyjal|mount hyjal|海加尔山",
    "valle bosquenegro|blackwood glen|黑木谷",
    "bosquenegro|blackwood glen|黑木谷",
    "-- Modos de Juego y Desafíos
    "hardcore|hardcore|硬核/一命",
    "hc|hardcore|硬核",
    "modo hardcore|hardcore mode|一命模式/硬核模式",
    "vagabundo|vagrant|流浪者",
    "modo vagabundo|vagrant mode|流浪者模式",
    "lento y constante|slow and steady|慢而稳",
    "slow y steady|slow and steady|慢而稳",
    "autodidacta|self-crafted|自制装备/孤狼",
    "modo autodidacta|self-crafted mode|自制模式",
    "glifo de la tortuga|glyph of the turtle|乌龟雕文",
    "glifo de tortuga|glyph of the turtle|乌龟雕文",
    "modo exhausto|exhausted mode|精疲力竭模式",
    "-- Modos",
    "desafíos y social de Turtle WoW
    "un solo intento|one life|一命",
    "modo un solo intento|hardcore mode|一命模式",
    "f en el chat|f in chat|发F/点赞",
    "rip bozo|rip bozo|好死",
    "we go agane|we go again|再来一次",
    "self crafted|self crafted|自制装备",
    "vagrant|vagrant|流浪者",
    "-- Adiciones extras de contenido custom
    "glifo de fatiga|glyph of fatigue|疲劳雕文",
    "glifo de superacion|glyph of progression|进度雕文",
    "glifo de superación|glyph of progression|进度雕文",
    "carpa de supervivencia|survival tent|生存帐篷",
    "tienda para descansar|resting tent|双倍经验帐篷",
    "tienda de descanso|resting tent|休息帐篷",
    "campamento de descanso|resting camp|休息营地",
    "campamento de superviviente|survivor camp|生存者营地",
    "piedra de ilusion|illusion stone|幻化石",
    "piedra de ilusión|illusion stone|幻化石",
    "ilusion|illusion|幻化",
    "ilusión|illusion|幻化",
    "glifo custom|custom glyph|自定义雕文",
    "tienda xp|xp tent|经验帐篷",
    "xp tent|xp tent|帐篷",
    "tent xp|xp tent|帐篷",
    "moneda de plata turtle|turtle silver coin|乌龟银币",
    "gilneas|gilneas city|吉尔尼斯城",
    "ciudad de gilneas|gilneas city|吉尔尼斯城",
    "criptas de karazhan|karazhan crypts|卡拉赞地下墓穴",
    "criptas karazhan|karazhan crypts|卡拉赞地下墓穴",
    "bóveda de ventormenta|stormwind vault|暴风城地牢",
    "boveda de ventormenta|stormwind vault|暴风城地牢",
    "cantera de hateforge|hateforge quarry|仇恨熔炉采石场",
    "cantera hateforge|hateforge quarry|仇恨熔炉采石场",
    "cavernas del tiempo|caverns of time|时光之穴",
    "isla de los diseñadores|designer island|设计师之岛",
    "isla de los disenadores|designer island|设计师之岛",
    "tierras altas de tirisfal|tirisfal uplands|提瑞斯法高地",
    "isla de gillijim|gillijim's isle|吉利吉姆岛",
    "carpa de la luna de sangre|bloodmoon tent|血月帐篷",
    "tienda de supervivencia|survival tent|生存帐篷",
    "modo hardcore|hardcore mode|硬核模式",
    "modo tortuga|turtle mode|乌龟模式",
    "modo guerra|warmode|战争模式",
    "modo de guerra|warmode|战争模式",
    "supervivencia|survival|生存",
    "carpinteria|woodworking|木工",
    "carpintería|woodworking|木工",
    "moneda donador|donation coin|捐赠币",
    "tienda de turtle|turtle shop|乌龟商店",
    "transmog|transmogrification|幻化",
    "transfiguración|transmogrification|幻化",
    "transfiguracion|transmogrification|幻化",
    "apariencia|appearance|外观",
    "montura tortuga|turtle mount|乌龟坐骑",
    "caballero de la muerte|death knight|死亡骑士",
    "elfo alto|high elf|高等精灵",
    "goblin|goblin|地精",
    "campamento goblin|goblin camp|地精营地",
    "tienda goblin|goblin shop|地精商店",
    "mercader de monturas|mount vendor|坐骑商人",
    "banco portátil|portable bank|便携银行",
    "banco portatil|portable bank|便携银行"
  }

  -- ============================================================
  -- LOTE I: ESTADÍSTICAS, ATRIBUTOS, RESISTENCIAS Y TALENTOS (STATS & SPECS)
  -- ============================================================
  local stats_talents_batch = {
    -- Atributos Principales
    "fuerza|strength|力量",
    "agilidad|agility|敏捷",
    "aguante|stamina|耐力",
    "intelecto|intellect|智力",
    "espíritu|spirit|精神",
    "espiritu|spirit|精神",

    -- Estadísticas Secundarias de Combate
    "índice de golpe|hit rating|命中等级",
    "indice de golpe|hit rating|命中等级",
    "golpe crítico|crit rating|爆击等级",
    "golpe critico|crit rating|爆击等级",
    "crítico|crit|爆击",
    "critico|crit|爆击",
    "esquivar|dodge|躲闪",
    "parada|parry|招架",
    "bloqueo|block|格挡",
    "poder de ataque|attack power|攻击强度",
    "ap|attack power|攻强",
    "poder con hechizos|spell power|法术强度",
    "sp|spell power|法强",
    "sanación|healing power|治疗效果",
    "sanacion|healing power|治疗效果",
    "penetración de armadura|armor penetration|护甲穿透",
    "penetracion de armadura|armor penetration|护甲穿透",
    "defensa|defense|防御",

    -- Tipos de Daño y Resistencias
    "daño físico|physical damage|物理伤害",
    "daño fisico|physical damage|物理伤害",
    "fuego|fire|火焰",
    "escarcha|frost|冰霜",
    "naturaleza|nature|自然",
    "sombras|shadow|暗影",
    "arcano|arcane|奥术",
    "sagrado|holy|神圣",
    "resistencia al fuego|fire resistance|火焰抗性",
    "resistencia a la escarcha|frost resistance|冰霜抗性",
    "resistencia a la naturaleza|nature resistance|自然抗性",
    "resistencia a las sombras|shadow resistance|暗影抗性",
    "resistencia a lo arcano|arcane resistance|奥术抗性",

    -- Clases y Especializaciones de Talentos
    "guerrero|warrior|战士",
    "paladín|paladin|圣骑士",
    "paladin|paladin|圣骑士",
    "cazador|hunter|猎人",
    "pícaro|rogue|潜行者/盗贼",
    "picaro|rogue|潜行者/盗贼",
    "sacerdote|priest|牧师",
    "chamán|shaman|萨满",
    "chaman|shaman|萨满",
    "mago|mage|法师",
    "brujo|warlock|术士",
    "druida|druid|德鲁伊",
    "armas|arms|武器",
    "furia|fury|狂暴",
    "protección|protection|防护",
    "proteccion|protection|防护",
    "retribución|retribution|惩戒",
    "retribucion|retribution|惩戒",
    "bestias|beast mastery|野兽控制",
    "puntería|marksmanship|射击",
    "punteria|marksmanship|射击",
    "sutileza|subtlety|敏锐",
    "asesinato|assassination|刺杀",
    "disciplina|discipline|戒律",
    "elemental|elemental|元素",
    "mejora|enhancement|增强",
    "restauración|restoration|恢复",
    "restauracion|restoration|恢复",
    "aflicción|affliction|痛苦",
    "afliccion|affliction|痛苦",
    "demonología|demonology|恶魔学识",
    "demonologia|demonology|恶魔学识",
    "destrucción|destruction|毁灭",
    "destruccion|destruction|毁灭",
    "equilibrio|balance|平衡",
    "combate feral|feral combat|野性战斗"
  }

  -- ============================================================
  -- LOTE J: PVP, CAMPOS DE BATALLA Y CONSUMIBLES DE RAID (PVP & CONSUMABLES)
  -- ============================================================
  local pvp_consumables_batch = {
    -- Campos de Batalla (BGs)
    "garganta grito de guerra|warsong gulch|战歌峡谷",
    "garganta de grito de guerra|warsong gulch|战歌峡谷",
    "wsg|warsong gulch|战歌",
    "valle de alterac|alterac valley|奥特兰克山谷",
    "av|alterac valley|奥山",
    "cuenca de arathi|arathi basin|阿拉希盆地",
    "ab|arathi basin|阿拉希",

    -- Objetivos PvP y Estructuras
    "cementerio|graveyard|墓地",
    "gy|graveyard|墓地",
    "bandera|flag|旗帜",
    "mina|mine|矿洞",
    "aserradero|lumber mill|伐木场",
    "lm|lumber mill|伐木场",
    "establo|stables|马厩",
    "establos|stables|马厩",
    "herrería|blacksmith|铁匠铺",
    "herreria|blacksmith|铁匠铺",
    "bs|blacksmith|铁匠铺",
    "granja|farm|农场",

    -- Rangos y Mecánicas PvP
    "rango pvp|pvp rank|PVP军衔",
    "muertes con honor|honorable kills|荣誉击杀",
    "hk|honorable kills|击杀",
    "puntos de honor|honor points|荣誉点",
    "marcas de warsong|warsong marks|战歌牌子",
    "marcas de arathi|arathi marks|阿拉希牌子",
    "marcas de alterac|alterac marks|奥山牌子",

    -- Consumibles de Raid y Soporte
    "agua de maná|mana water|法力水",
    "agua de mana|mana water|法力水",
    "pan|bread|面包",
    "comida|food|食物",
    "bebida|drink|饮料",
    "té de cardo|thistle tea|菊花茶",
    "te de cardo|thistle tea|菊花茶",
    "pocion de mana mayor|major mana potion|大蓝",
    "poción de maná mayor|major mana potion|大蓝",
    "pocion de vida mayor|major healing potion|大红",
    "poción de vida mayor|major healing potion|大红",
    "runa demoníaca|demonic rune|恶魔符文",
    "runa demoniaca|demonic rune|恶魔符文",
    "runa oscura|dark rune|黑暗符文",
    "venda de tejido de runas gruesa|heavy runecloth bandage|厚符文布绷带",
    "venda de tejido de runas|runecloth bandage|符文布绷带",
    "busco calabozo|looking for dungeon|求组副本",
    "busco mazmorra|looking for dungeon|求组副本",
    "hacer misiones|do quests|做任务",
    "subir nivel|leveling|升级",
    "levear|leveling|升级",
    "boostear|boosting|带刷",

    -- Consumibles y pvp adicionales
    "pocion de accion libre|free action potion|自由行动药水",
    "pocion de accion viva|living action potion|活性行动药水",
    "fap|free action potion|自由行动药水",
    "aceite de mago brillante|brilliant wizard oil|卓越巫师之油",
    "aceite de mana brillante|brilliant mana oil|卓越法力之油",
    "aceite de mago|wizard oil|巫师之油",
    "aceite de mana|mana oil|法力之油"
  }

  -- Ejecutar la carga masiva en lotes comprimidos
  load_batch(spells_batch)
  load_batch(quests_batch)
  load_batch(items_batch)
  load_batch(slang_batch)
  load_batch(zones_batch)
  load_batch(mechanics_batch)
  load_batch(professions_batch)
  load_batch(turtle_custom_batch)
  load_batch(stats_talents_batch)
  load_batch(pvp_consumables_batch)

  -- ============================================================
  -- EXPANSION LEXICA v7.1 — VOCABULARIO WoW CHINO AMPLIADO
  -- Clases, roles, zonas, slang gaming, chat conversacional
  -- ============================================================

  -- Clases de personaje
  add("guerrero",                   "warrior",                   "战士")
  add("mago",                       "mage",                      "法师")
  add("picaro",                     "rogue",                     "盗贼")
  add("druida",                     "druid",                     "德鲁伊")
  add("cazador",                    "hunter",                    "猎人")
  add("sacerdote",                  "priest",                    "牧师")
  add("brujo",                      "warlock",                   "术士")
  add("paladin",                    "paladin",                   "圣骑士")
  add("chaman",                     "shaman",                    "萨满")

  -- Roles de raid/grupo
  add("tanque",                     "tank",                      "坦克")
  add("sanador",                    "healer",                    "奶妈")
  add("dps",                        "dps",                       "输出")
  add("dano",                       "damage",                    "伤害")
  add("curacion",                   "healing",                   "治疗")
  add("soporte",                    "support",                   "辅助")
  add("iniciador",                  "puller",                    "拉怪")

  -- Instancias clásicas
  add("minas de la muerte",         "deadmines",                 "死亡矿井")
  add("monasterio carmesi",         "scarlet monastery",         "血色修道院")
  add("ciudad de gnomeregan",       "gnomeregan",                "诺莫瑞根")
  add("altos del razorfen",         "razorfen downs",            "剃刀高地")
  add("maraudon",                   "maraudon",                  "玛拉顿")
  add("templo de atal'hakkar",      "sunken temple",             "沉没的神庙")
  add("profundidades de blackrock", "blackrock depths",          "黑石深渊")
  add("cumbre de blackrock",        "blackrock spire",           "黑石塔")
  add("stratholme",                 "stratholme",                "斯坦索姆")
  add("scholomance",                "scholomance",               "通灵学院")
  add("zul'farrak",                 "zul'farrak",                "祖尔法拉克")
  add("guarida de onyxia",          "onyxia's lair",             "熔火之心")
  add("nucleo de magma",            "molten core",               "熔火之心")
  add("bastión negro",              "blackwing lair",            "黑翼之巢")
  add("templo ahn'qiraj",           "temple of ahn'qiraj",       "安其拉神庙")
  add("ruinas de ahn'qiraj",        "ruins of ahn'qiraj",        "安其拉废墟")
  add("naxxramas",                  "naxxramas",                 "纳克萨玛斯")

  -- Instancias TBC
  add("karazhan",                   "karazhan",                  "卡拉赞")
  add("gruul",                      "gruul's lair",              "格鲁尔的巢穴")
  add("magtheridon",                "magtheridon's lair",        "玛瑟里顿的巢穴")
  add("templo serpiente",           "serpentshrine cavern",      "毒蛇神殿洞穴")
  add("cumbre del ojo",             "tempest keep",              "风暴要塞")
  add("monte hyjal",                "mount hyjal",               "海加尔山")
  add("fortaleza del sol negro",    "black temple",              "黑暗神殿")
  add("bastión del sol",            "sunwell plateau",           "太阳之井高地")
  add("bastillon del sol",          "sunwell",                   "太阳堡垒")

  -- Ciudades principales
  add("ciudad de tormenta",         "stormwind",                 "暴风城")
  add("ironforge",                  "ironforge",                 "铁炉堡")
  add("darnassus",                  "darnassus",                 "达纳苏斯")
  add("exodar",                     "the exodar",                "埃克索达")
  add("orgrimmar",                  "orgrimmar",                 "奥格瑞玛")
  add("villafría",                  "undercity",                 "幽暗城")
  add("cima del trueno",            "thunder bluff",             "雷霆崖")
  add("ciudad astral",              "silvermoon",                "银月城")
  add("shattrath",                  "shattrath city",            "沙塔斯城")

  -- Vocabulario gaming WoW (términos que aparecen con frecuencia en chat chino)
  add("nivel",                      "level",                     "等级")
  add("experiencia",                "experience",                "经验")
  add("subir nivel",                "level up",                  "升级")
  add("leveling",                   "leveling",                  "练级")
  add("grindear",                   "grinding",                  "刷怪")
  add("farmear",                    "farming",                   "刷素材")
  add("bot",                        "bot",                       "机器人")
  add("tramposo",                   "cheater",                   "外挂党")
  add("instancia",                  "dungeon",                   "副本")
  add("mazmorra",                   "dungeon",                   "地下城")
  add("banda",                      "raid",                      "团队副本")
  add("entrar instancia",           "enter dungeon",             "进副本")
  add("correr instancia",           "run dungeon",               "打副本")
  add("limpiar instancia",          "clear dungeon",             "通关副本")
  add("busco grupo",                "looking for group",         "求组队")
  add("formando grupo",             "forming group",             "组队中")
  add("grupo lleno",                "group full",                "满员了")
  add("reclutando",                 "recruiting",                "招募中")
  add("equipamiento",               "gear",                      "装备")
  add("objeto",                     "item",                      "物品")
  add("arma",                       "weapon",                    "武器")
  add("armadura",                   "armor",                     "护甲")
  add("anillo",                     "ring",                      "戒指")
  add("amuleto",                    "necklace",                  "项链")
  add("habilidad",                  "skill",                     "技能")
  add("talento",                    "talent",                    "天赋")
  add("jefe",                       "boss",                      "首领")
  add("monstruo",                   "mob",                       "怪物")
  add("elite",                      "elite",                     "精英")
  add("basura",                     "trash mob",                 "小怪")
  add("saqueo",                     "loot",                      "掉落")
  add("botín",                      "loot drop",                 "战利品")
  add("raro",                       "rare",                      "稀有")
  add("epico",                      "epic",                      "史诗")
  add("legendario",                 "legendary",                 "传说")
  add("necesito",                   "need roll",                 "需要摇")
  add("codicia",                    "greed roll",                "贪婪摇")
  add("encantamiento",              "enchant",                   "附魔")
  add("gema",                       "gem",                       "宝石")
  add("engaste",                    "socket",                    "宝石孔")
  add("tabla",                      "crafting table",            "工作台")

  -- Términos económicos WoW
  add("subasta",                    "auction house",             "拍卖行")
  add("en venta",                   "for sale",                  "出售")
  add("comprando",                  "buying",                    "收购")
  add("precio",                     "price",                     "价格")
  add("barato",                     "cheap",                     "便宜")
  add("caro",                       "expensive",                 "贵")
  add("intercambio",                "trade",                     "交易")
  add("intercambiar",               "exchange",                  "以物换物")
  add("envio",                      "mail",                      "邮寄")
  add("dinero de oro",              "gold",                      "金币")
  add("dinero de plata",            "silver",                    "银币")
  add("dinero de cobre",            "copper",                    "铜币")
  add("mercader",                   "vendor",                    "商人")

  -- Slang gaming chino WoW específico
  add("utilísimo",                  "very useful",               "好用")
  add("por qué no",                 "why not",                   "为啥")
  add("directamente",               "just go",                   "直接")
  add("elfo de sangre",             "blood elf",                 "血精灵")
  add("intendente",                 "quartermaster",             "军需官")
  add("interior exterior",          "inside outside",            "内外")
  add("sanador colega",             "healer",                    "奶妈")
  add("feria de la oscuridad",      "darkmoon faire",            "马戏团")
  add("villa de botín",             "booty bay",                 "闪金镇")
  add("casual",                     "casual",                    "休闲")
  add("compañero",                  "comrade",                   "同志")
  add("respeto",                    "respect",                   "尊敬")
  add("honor",                      "honor",                     "荣誉")
  add("gremio",                     "guild",                     "公会")
  add("lider de gremio",            "guild master",              "会长")
  add("miembro",                    "member",                    "成员")
  add("novato",                     "newbie",                    "萌新")
  add("veterano",                   "veteran",                   "老玩家")
  add("tramposo",                   "cheater",                   "外挂")
  add("campo de batalla",           "battleground",              "战场")
  add("arena",                      "arena",                     "竞技场")
  add("punto de honor",             "honor point",               "荣誉点")
  add("llave de mazmorra",          "dungeon key",               "副本钥匙")
  add("clase de personaje",         "character class",           "职业")
  add("raza",                       "race",                      "种族")
  add("servidor",                   "server",                    "服务器")
  add("alianza",                    "alliance",                  "联盟")
  add("horda",                      "horde",                     "部落")

  -- Chat conversacional chino en WoW
  add("hola a todos",               "hello everyone",            "大家好")
  add("bienvenido",                 "welcome",                   "欢迎")
  add("buen juego",                 "well played",               "打得好")
  add("bien hecho",                 "well done",                 "做得好")
  add("impresionante",              "awesome",                   "厉害")
  add("muy fuerte",                 "very strong",               "好强")
  add("genial",                     "great",                     "太好了")
  add("felicitaciones",             "congratulations",           "恭喜")
  add("empezar",                    "start",                     "开始")
  add("terminar",                   "finish",                    "结束")
  add("continuar",                  "continue",                  "继续")
  add("vamos",                      "let's go",                  "走吧")
  add("falló",                      "failed",                    "失败了")
  add("logrado",                    "succeeded",                 "成功了")
  add("listo",                      "ready",                     "准备好")
  add("esperando",                  "waiting",                   "等待中")
  add("llegando",                   "on my way",                 "快到了")
  add("entiendo",                   "I see",                     "明白了")
  add("no entiendo",                "don't understand",          "不明白")
  add("cuánto tiempo",              "how long",                  "多久")
  add("cuántos",                    "how many",                  "多少")
  add("cuándo empezamos",           "when do we start",          "什么时候开始")
  add("se puede",                   "is it possible",            "可以吗")
  add("sin problema",               "no problem",                "没问题")
  add("lo intento",                 "I'll try",                  "试试")
  add("no puedo",                   "I can't",                   "不行")
  add("ahora mismo",                "right now",                 "马上")
  add("de vuelta",                  "back",                      "回来了")
  add("me voy",                     "I'm leaving",               "下线了")
  add("buenas tardes",              "good afternoon",            "下午好")
  add("buenas noches",              "good night",                "晚上好")
  add("hasta luego",                "see you later",             "改天见")
  add("hasta mañana",               "see you tomorrow",          "明天见")
  add("qué pasa",                   "what's up",                 "怎么了")
  add("sin problema",               "no problem",                "没事儿")
  add("con cuidado",                "be careful",                "小心点")
  add("buena suerte",               "good luck",                 "加油")
  add("me alegra",                  "glad to hear",              "太好了")
  add("demasiado tiempo",           "too long",                  "太久了")
  add("hora",                       "hour",                      "小时")
  add("media hora",                 "half hour",                 "半小时")
  add("un momento",                 "one moment",                "稍等")
  add("tiempo real",                "real time",                 "时候")
  add("objetivo",                   "target",                    "目标")
  add("mision",                     "quest",                     "任务")
  add("recompensa",                 "reward",                    "奖励")
  add("completar mision",           "complete quest",            "完成任务")
  add("aceptar mision",             "accept quest",              "接任务")
  add("entregas de mision",         "quest turn in",             "交任务")
  add("hay alguien",                "is anyone there",           "有没有")
  add("nadie",                      "nobody",                    "没人")
  add("lo consigo",                 "I can get it",              "我去买")
  add("el jefe final",              "final boss",                "最终boss")
  add("el jefe difícil",            "hard boss",                 "难打")
  add("entrar ahora",               "enter now",                 "进来吧")
  add("afuera",                     "outside",                   "外面")
  add("zona de guerra",             "warzone",                   "战区")
  add("mundo abierto",              "open world",                "野外")
  add("pvp",                        "pvp",                       "玩家对战")
  add("pve",                        "pve",                       "副本挑战")

  -- ============================================================
  -- EXPANSION LEXICA v7.1 — FRASES VERBALES Y COMBATE
  -- ============================================================

  -- Frases de acción de 2 chars (verbos compuestos frecuentes en chat)
  add("saber",                      "know",                      "知道")
  add("entender",                   "understand",                "明白")
  add("llegar",                     "arrive",                    "到了")
  add("salir",                      "leave",                     "出去")
  add("entrar",                     "enter",                     "进去")
  add("volver",                     "return",                    "回来")
  add("ir",                         "go",                        "出发")
  add("esperar",                    "wait",                      "等等")
  add("ver",                        "see",                       "看看")
  add("intentar",                   "try",                       "试试")
  add("preparar",                   "prepare",                   "准备")
  add("cancelar",                   "cancel",                    "取消")
  add("confirmar",                  "confirm",                   "确认")
  add("terminar",                   "done",                      "完了")
  add("continuar",                  "continue",                  "继续")
  add("comenzar",                   "begin",                     "开始")
  add("finalizar",                  "end",                       "结束")
  add("unirse",                     "join",                      "加入")
  add("salir del grupo",            "leave group",               "退队")
  add("expulsar",                   "kick",                      "踢出")
  add("invitar",                    "invite",                    "邀请")
  add("rechazar",                   "decline",                   "拒绝")
  add("aceptar",                    "accept",                    "接受")
  add("ignorar",                    "ignore",                    "无视")
  add("reportar",                   "report",                    "举报")
  add("bloquear",                   "block",                     "屏蔽")
  add("conectarse",                 "login",                     "登录")
  add("desconectarse",              "logout",                    "下线")
  add("reconectar",                 "reconnect",                 "重连")
  add("recargar ui",                "reload ui",                 "重载UI")

  -- Estado del jugador
  add("en línea",                   "online",                    "在线")
  add("ocupado",                    "busy",                      "没空")
  add("libre",                      "free",                      "有空")
  add("ya regresé",                 "back",                      "回来了")
  add("me desconecté",              "disconnected",              "掉线了")
  add("tengo lag",                  "lagging",                   "卡顿")
  add("ya llegué",                  "I'm here",                  "到了")
  add("ya estoy",                   "I'm ready",                 "准备好")
  add("recién entré",               "just logged in",            "刚上线")
  add("me voy a dormir",            "going to sleep",            "去睡觉")
  add("vuelvo en un rato",          "be back soon",              "稍后回来")
  add("estoy cenando",              "eating dinner",             "吃饭中")
  add("ya me voy",                  "leaving now",               "下线了")
  add("mañana juego",               "playing tomorrow",          "明天再玩")

  -- Mecánicas de combate (2+ chars zh)
  add("cooldown",                   "cooldown",                  "冷却")
  add("en cooldown",                "on cooldown",               "冷却中")
  add("castear",                    "cast",                      "施法")
  add("interrumpir",                "interrupt",                 "打断")
  add("silencio",                   "silence",                   "沉默")
  add("aturdir",                    "stun",                      "眩晕")
  add("ralentizar",                 "slow",                      "减速")
  add("control",                    "cc",                        "控制")
  add("cc de masa",                 "aoe cc",                    "群控")
  add("rango",                      "range",                     "范围")
  add("daño en área",               "aoe damage",                "范围伤害")
  add("estallido",                  "burst",                     "爆发")
  add("escudo",                     "shield",                    "护盾")
  add("buff positivo",              "buff",                      "增益")
  add("debuff",                     "debuff",                    "减益")
  add("provocar",                   "taunt",                     "嘲讽")
  add("resucitar",                  "resurrect",                 "复活")
  add("golpe crítico",              "critical hit",              "暴击")
  add("bloqueo",                    "block",                     "格挡")
  add("esquivar",                   "dodge",                     "闪避")
  add("parar",                      "parry",                     "招架")
  add("acertar",                    "hit",                       "命中")
  add("fallar",                     "miss",                      "未命中")
  add("cantidad de vida",           "health points",             "血量")
  add("puntos de maná",             "mana points",               "法力")
  add("energía",                    "energy",                    "能量")
  add("furia",                      "rage",                      "怒气")
  add("concentración",              "focus",                     "集中")
  add("combo",                      "combo",                     "连击")
  add("emboscada",                  "ambush",                    "偷袭")
  add("sigilo",                     "stealth",                   "潜行")
  add("transformar",                "polymorph",                 "变形")
  add("domar",                      "tame",                      "驯服")
  add("mascota",                    "pet",                       "宠物")
  add("invocar conjuro",            "summon",                    "召唤")
  add("trampa",                     "trap",                      "陷阱")
  add("marcar",                     "mark",                      "标记")
  add("golpe",                      "hit",                       "击中")
  add("ataque especial",            "special attack",            "技能攻击")
  add("habilidad ultimate",         "ultimate ability",          "大招")
  add("tiempo de reutilización",    "reuse time",                "复用时间")

  -- Términos de PvP
  add("campo de batalla",           "battleground",              "战场")
  add("arena pvp",                  "arena",                     "竞技场")
  add("honorable",                  "honor",                     "荣誉")
  add("reputación pvp",             "pvp reputation",            "战场声望")
  add("rango de honor",             "honor rank",                "荣誉等级")
  add("asesino",                    "killer",                    "杀手")
  add("matar al objetivo",          "kill target",               "击杀目标")
  add("capturar bandera",           "capture flag",              "夺旗")
  add("defender base",              "defend base",               "守点")
  add("atacar base",                "attack base",               "打点")
  add("nodo",                       "node",                      "节点")
  add("flag carrier",               "flag carrier",              "旗手")
  add("curar al portador",          "heal fc",                   "奶旗手")
  add("matar al portador",          "kill fc",                   "打旗手")
  add("campo de batalla de warsong","warsong gulch",             "战歌峡谷")
  add("cuencas de arathi",          "arathi basin",              "阿拉希盆地")
  add("ojo de la tormenta",         "eye of the storm",          "风暴之眼")
  add("garganta alterac",           "alterac valley",            "奥山战役")
  add("batalla naval de strand",    "strand of the ancients",    "古代海滩")

  -- Profesiones (completo)
  add("herrería",                   "blacksmithing",             "锻造")
  add("sastrería",                  "tailoring",                 "裁缝")
  add("joyería",                    "jewelcrafting",             "珠宝加工")
  add("ingeniería",                 "engineering",               "工程学")
  add("alquimia",                   "alchemy",                   "炼金")
  add("encantamiento",              "enchanting",                "附魔")
  add("curtido",                    "leatherworking",            "制革")
  add("costura fina",               "fine tailoring",            "精细裁缝")
  add("herbología",                 "herbalism",                 "草药学")
  add("minería",                    "mining",                    "采矿")
  add("descuelleo",                 "skinning",                  "剥皮")
  add("pesca",                      "fishing",                   "钓鱼")
  add("cocina",                     "cooking",                   "烹饪")
  add("primeros auxilios",          "first aid",                 "急救")

  -- Materiales y crafting
  add("mineral de hierro",          "iron ore",                  "铁矿石")
  add("mineral de acero",           "steel ore",                 "钢铁矿石")
  add("mineral de mitril",          "mithril ore",               "秘银矿")
  add("mineral de thorium",         "thorium ore",               "奥铁矿")
  add("mineral de adamantita",      "adamantite ore",            "精金矿")
  add("mineral de fel iron",        "fel iron ore",              "魔铁矿")
  add("hierba de brionia",          "briarthorn",                "野玫瑰")
  add("hierba de leyenda",          "fadeleaf",                  "消逝叶")
  add("hierba de peacebloom",       "peacebloom",                "和平草")
  add("hierba de mageroyal",        "mageroyal",                 "法师草")
  add("materiales",                 "materials",                 "材料")
  add("mata hierba",                "herb gathering",            "采草药")
  add("cuero grueso",               "heavy leather",             "厚皮")
  add("tela de lino",               "linen cloth",               "亚麻布")
  add("tela de seda",               "silk cloth",                "丝绸布")
  add("tela rúnica",                "runecloth",                 "符文布")
  add("piel robusta",               "rugged leather",            "粗革皮")
  add("formula",                    "recipe",                    "配方")
  add("plano",                      "schematic",                 "设计图")
  add("patron",                     "pattern",                   "裁缝图纸")
  add("libro de hechizos",          "spellbook",                 "技能书")

  -- Economía WoW extendida
  add("precio de subasta",          "auction price",             "拍卖价格")
  add("comprar en subasta",         "buy from ah",               "从拍卖行买")
  add("vender en subasta",          "sell on ah",                "上拍卖行")
  add("precio de compra",           "buyout price",              "一口价")
  add("precio inicial",             "starting bid",              "起拍价")
  add("puja",                       "bid",                       "出价")
  add("el precio cayó",             "price dropped",             "价格降了")
  add("el precio subió",            "price went up",             "价格涨了")
  add("consejo de subasta",         "ah tip",                    "拍卖行技巧")
  add("trampa de precio",           "price trap",                "价格陷阱")
  add("revender",                   "resell",                    "倒卖")
  add("cuánto cuesta",              "how much",                  "多少钱")
  add("cuánto por",                 "how much for",              "多少钱一个")
  add("lo vendo a",                 "selling for",               "卖价")
  add("negociar",                   "negotiate",                 "谈价格")
  add("trato",                      "deal",                      "成交")
  add("ya pagué",                   "already paid",              "已经付钱")
  add("mandame el objeto",          "send the item",             "发邮件给我")

  -- Frases de guild/hermandad
  add("unirse al gremio",           "join guild",                "加入公会")
  add("fundador de gremio",         "guild founder",             "会长")
  add("oficial de gremio",          "guild officer",             "干部")
  add("miembro del gremio",         "guild member",              "成员")
  add("expulsado del gremio",       "guild kicked",              "踢出公会")
  add("gremio recluta",             "guild recruiting",          "公会招募")
  add("gremio casual",              "casual guild",              "休闲公会")
  add("gremio de raid",             "raiding guild",             "团本公会")
  add("gremio pvp",                 "pvp guild",                 "PVP公会")
  add("eventos del gremio",         "guild events",              "公会活动")
  add("banco del gremio",           "guild bank",                "公会银行")
  add("tabard del gremio",          "guild tabard",              "公会外袍")
  add("reputación del gremio",      "guild reputation",          "公会声望")
  add("chat del gremio",            "guild chat",                "公会频道")
  add("anuncio del gremio",         "guild notice",              "公会公告")
  add("necesitamos miembros",       "need members",              "缺人")
  add("somos pocos",                "we are few",                "人不够")
  add("ya somos suficientes",       "enough people",             "人够了")
  add("la raid empieza",            "raid starts",               "团本开始")
  add("registrate a la raid",       "sign up for raid",          "报名参加")
  add("confirmado para raid",       "confirmed for raid",        "确认参团")
  add("cancelar raid",              "raid cancelled",            "取消团本")
  add("raid pospuesta",             "raid postponed",            "推迟团本")

  -- Frases de server/eventos
  add("evento del servidor",        "server event",              "服务器活动")
  add("mantenimiento del servidor", "server maintenance",        "服务器维护")
  add("el servidor está caído",     "server is down",            "服务器崩了")
  add("el servidor se cayó",        "server crashed",            "掉服了")
  add("volver a conectar",          "reconnecting",              "重新连接")
  add("tiempo de servidor",         "server time",               "服务器时间")
  add("zona horaria del servidor",  "server timezone",           "服务器时区")
  add("feria de la oscuridad",      "darkmoon faire",            "暗月节")
  add("festival de invierno",       "winter veil",               "冬幕节")
  add("hallowsen",                  "hallow's end",              "万圣节")
  add("amor en el aire",            "love is in the air",        "爱在空气中")
  add("festival de fuego",          "midsummer fire",            "仲夏火焰节")
  add("festival de huevos",         "noblegarden",               "贵族花园")
  add("día de los niños",           "children's week",           "儿童节")
  add("fiesta de la cerveza",       "brewfest",                  "啤酒节")
  add("invasión de fuego elemental","elemental invasion",        "元素入侵")

  -- Frases de chat de rol/narrativo WoW
  add("horda para siempre",         "for the horde",             "为了部落")
  add("por la alianza",             "for the alliance",          "为了联盟")
  add("por el honor",               "for the honor",             "为了荣誉")
  add("listo para la pelea",        "ready to fight",            "准备战斗")
  add("defensas de la ciudad",      "city defense",              "守城")
  add("atacar la ciudad",           "attack the city",           "攻城")
  add("invasión de horda",          "horde invasion",            "部落入侵")
  add("invasión de alianza",        "alliance invasion",         "联盟入侵")
  add("matando facciones",          "faction killing",           "杀对立阵营")
  add("mundo compartido",           "shared world",              "公开地图")

  -- Frases conversacionales adicionales de WoW
  add("qué nivel eres",             "what level are you",        "你几级了")
  add("cuánto tiempo llevas",       "how long have you played",  "玩多久了")
  add("eres nuevo",                 "are you new",               "你是新人")
  add("recién empecé",              "just started",              "刚开始玩")
  add("llevo mucho jugando",        "playing for a long time",   "玩很久了")
  add("primera vez aquí",           "first time here",           "第一次来")
  add("cuántas veces fuiste",       "how many times did you go", "去了几次")
  add("limpié el raid",             "cleared the raid",          "通关团本")
  add("primera vez raideando",      "first raid",                "第一次团本")
  add("qué personaje juegas",       "what class do you play",    "你玩什么职业")
  add("soy tank",                   "I am tank",                 "我是坦克")
  add("soy healer",                 "I am healer",               "我是治疗")
  add("soy dps",                    "I am dps",                  "我是输出")
  add("tengo buen equipo",          "I have good gear",          "我装备好")
  add("mi equipo es malo",          "my gear is bad",            "我装备差")
  add("necesito mejorar",           "need to improve",           "需要加强")
  add("tengo muy buen equipo",      "fully geared",              "装备齐了")
  add("quiero instanciar",          "want to dungeon",           "想跑副本")
  add("quiero raidear",             "want to raid",              "想跑团本")
  add("quiero pvpear",              "want to pvp",               "想打PVP")
  add("soy malo en pvp",            "bad at pvp",                "PVP很菜")
  add("soy bueno en pvp",           "good at pvp",               "PVP很强")
  add("dónde te dropeó",            "where did it drop",         "哪里掉落")
  add("me dropeo algo bueno",       "got a good drop",           "掉了好东西")
  add("nada útil",                  "nothing useful",            "没好东西")
  add("todo gris",                  "all grey",                  "全是垃圾")
  add("saqué algo raro",            "got a rare",                "掉了稀有")
  add("saqué un épico",             "got an epic",               "掉了史诗")
  add("actualicé",                  "upgraded",                  "升级了")
  add("mejoré mi equipo",           "gear upgrade",              "装备升级")

  -- Términos de chat de Turtle WoW específico
  add("turtle wow",                 "turtle wow",                "乌龟WOW")
  add("servidor turtle",            "turtle server",             "乌龟服")
  add("servidor privado",           "private server",            "私服")
  add("servidor personalizado",     "custom server",             "自定义服务器")
  add("parche personalizado",       "custom patch",              "自定义补丁")
  add("contenido nuevo",            "new content",               "新内容")
  add("zona nueva",                 "new zone",                  "新区域")
  add("mazmorra nueva",             "new dungeon",               "新副本")
  add("clase nueva",                "new class",                 "新职业")
  add("raza nueva",                 "new race",                  "新种族")
  add("en el parche",               "in the patch",              "在补丁里")
  add("próxima actualización",      "next update",               "下次更新")
  add("nota de parche",             "patch notes",               "补丁说明")
  add("cambio de balance",          "balance change",            "平衡调整")
  add("nerf",                       "nerf",                      "削弱")
  add("buff de parche",             "buff",                      "加强")
  add("servidor estable",           "stable server",             "服务器稳定")
  add("sin lag",                    "no lag",                    "不卡")
  add("muchos jugadores",           "many players",              "人很多")
  add("pocos jugadores",            "few players",               "人很少")
  add("servidor lleno",             "server full",               "服务器满了")
  add("cola de entrada",            "login queue",               "排队等待")

  -- Abreviaturas y términos numéricos en chat chino WoW
  add("10 de nivel",                "level 10",                  "10级")
  add("20 de nivel",                "level 20",                  "20级")
  add("30 de nivel",                "level 30",                  "30级")
  add("40 de nivel",                "level 40",                  "40级")
  add("50 de nivel",                "level 50",                  "50级")
  add("60 de nivel",                "level 60",                  "60级")
  add("nivel máximo",               "max level",                 "满级")
  add("personaje de nivel max",     "max level character",       "满级号")
  add("personaje nuevo",            "new character",             "新号")
  add("personaje de alt",           "alt character",             "小号")
  add("cuenta nueva",               "new account",               "新账号")
  add("10 monedas de oro",          "10 gold",                   "10金")
  add("100 monedas de oro",         "100 gold",                  "100金")
  add("1000 monedas de oro",        "1000 gold",                 "1000金")
  add("precio en oro",              "gold price",                "金币价格")
  add("sin dinero",                 "no money",                  "没金币")
  add("rico en juego",              "wealthy in game",           "土豪")
  add("donador",                    "donor",                     "充值玩家")
  add("sin pagar",                  "free to play",              "不花钱")
  add("versión gratuita",           "free version",              "免费版本")

  -- ============================================================
  -- RE-INDEXACIÓN DE BUCKETS POST-CARGA DE BASE DE DATOS
  -- ============================================================
  -- Dado que translator_dict ya inicializó los buckets, re-construimos
  -- los buckets para incluir los nuevos elementos inyectados de Spells & Quests.
  local p_keys = { "es_en", "en_es", "zh_en", "en_zh", "zh_es", "es_zh" }
  for _, p in ipairs(p_keys) do
    table.sort(pfUI.translator_dicts[p .. "_keys"], function(a, b) return strlen(a) > strlen(b) end)

    pfUI.translator_dicts[p .. "_buckets"] = {}
    local buckets = pfUI.translator_dicts[p .. "_buckets"]
    local keys = pfUI.translator_dicts[p .. "_keys"]
    local src_lang = strsub(p, 1, 2)

    for _, key in ipairs(keys) do
      local first_key = nil
      if src_lang == "zh" then
        local b = string.byte(key, 1)
        local char_len = 1
        if b and b >= 224 and b <= 239 then char_len = 3
        elseif b and b >= 192 and b <= 223 then char_len = 2 end
        first_key = strsub(key, 1, char_len)
      else
        first_key = string.gsub(key, "^([%a%d\128-\255]+).*", "%1")
      end

      if first_key and first_key ~= "" then
        buckets[first_key] = buckets[first_key] or {}
        table.insert(buckets[first_key], key)
      end
    end
  end

  if pfUI_config.translator and pfUI_config.translator.debug_mode == "1" then
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Base de Datos v7.1 cargada. Clases, roles, zonas clasicas/TBC, ciudades, gaming WoW, economía, slang chino y conversacional indexados.")
  end

end)


local preemptive_batch = {
  -- Clases y Specs (Abreviaciones chinas)
  "战|warrior|guerrero",
  "战士|warrior|guerrero",
  "法|mage|mago",
  "法师|mage|mago",
  "牧|priest|sacerdote",
  "牧师|priest|sacerdote",
  "贼|rogue|pícaro",
  "潜行者|rogue|pícaro",
  "猎|hunter|cazador",
  "猎人|hunter|cazador",
  "德|druid|druida",
  "小德|druid|druida",
  "德鲁伊|druid|druida",
  "术|warlock|brujo",
  "术士|warlock|brujo",
  "萨|shaman|chamán",
  "萨满|shaman|chamán",
  "骑|paladin|paladín",
  "骑士|paladin|paladín",
  "防|prot|protección",
  "奶|heal|healer",
  "惩戒|ret|reprensión",
  "狂暴|fury|furia",
  "暗牧|shadow|sombras",
  "火法|fire|fuego",
  "冰法|frost|escarcha",

  -- Mazmorras Clásicas (Abreviaciones)
  "哀嚎|wc|lamentos",
  "死矿|dm|minas",
  "影牙|sfk|castillo oscuro",
  "深渊|brd|profundidades",
  "血色|sm|monasterio",
  "剃刀|rfk|rajamanto",
  "高地|rfd|zarcas",
  "玛拉顿|mara|maraudon",
  "神庙|st|templo",
  "黑石|brs|cumbre",
  "厄运|dm|la masacre",
  "通灵|scholo|scholomance",
  "斯坦索姆|strat|stratholme",
  "祖格|zg|zul'gurub",
  "废墟|aq20|ruinas",
  "黑翼|bwl|guarida de alanegra",
  "黑龙|ony|onyxia",

  -- Acciones y Verbos Comunes
  "打|do/hit|hacer/pegar",
  "杀|kill|matar",
  "去|go|ir",
  "来|come|venir",
  "给|give|dar",
  "买|buy|comprar",
  "卖|sell|vender",
  "进|enter|entrar",
  "退|leave|salir",
  "等|wait|esperar",
  "组|invite|invitar",
  "交易|trade|comerciar",
  "帮忙|help|ayudar",
  "任务|quest|misión",
  "升级|level up|subir de nivel",
  "复活|resurrect|resucitar",
  "拉|summon|invocar",
  "跑|run|correr",
  "死|die|morir",
  "灭|wipe|wipear",
  "开|open/start|abrir/empezar",

  -- Pronombres y Jerga Social
  "我|i|yo",
  "你|you|tú",
  "他|he|él",
  "她|she|ella",
  "我们|we|nosotros",
  "你们|you|ustedes",
  "他们|they|ellos",
  "兄弟|brother|hermano",
  "大佬|pro|pro",
  "菜鸟|noob|noob",
  "妹子|girl|chica",
  "老婆|wife|esposa",
  "朋友|friend|amigo",
  "人|people|gente",

  -- Preguntas y Gramática
  "怎么|how|cómo",
  "哪里|where|dónde",
  "多少|how much|cuánto",
  "为什么|why|por qué",
  "什么|what|qué",
  "什么时候|when|cuándo",
  "谁|who|quién",

  -- Modificadores, Tiempo y Cantidad
  "现在|now|ahora",
  "等下|later|luego",
  "今天|today|hoy",
  "明天|tomorrow|mañana",
  "很多|a lot|mucho",
  "一点|a little|un poco",
  "全部|all|todo",
  "没有|none|nada",
  "对|yes/right|sí/correcto",
  "错|wrong|equivocado",
  "好|good/ok|bien/ok",
  "不好|bad/no|mal/no",

  -- Términos de Turtle WoW y MMORPG
  "乌龟|turtle|tortuga",
  "双采|double gathering|doble recolección",
  "龟壳|turtle shell|caparazón",
  "帐篷|tent|tienda",
  "排队|queue|cola",
  "跨阵营|crossfaction|facciones cruzadas",
  "联盟|alliance|alianza",
  "部落|horde|horda",
  "坦克|tank|tanque",
  "治疗|healer|sanador",
  "输出|dps|dps",
  "队长|leader|líder",
  "金币|gold|oro",
  "拍卖行|ah|subasta",
  "银行|bank|banco",
  "公会|guild|hermandad",
  "频道|channel|canal",
  "插件|addon|addon"
}

for _, line in ipairs(preemptive_batch) do
  local p1 = strfind(line, "|", 1, true)
  if p1 then
    local zh = strsub(line, 1, p1 - 1)
    local rest = strsub(line, p1 + 1)
    local p2 = strfind(rest, "|", 1, true)
    if p2 then
      local en = strsub(rest, 1, p2 - 1)
      local es = strsub(rest, p2 + 1)
      add(es, en, zh)
    end
  end
end
