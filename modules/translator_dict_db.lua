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

  local function add(es, en, zh)
    items[1].text = es
    items[2].text = en
    items[3].text = zh
    for i = 1, 3 do
      local item_i = items[i]
      local src_lang = item_i.lang
      local src_text = item_i.text
      if src_text and src_text ~= "" then
        for j = 1, 3 do
          if i ~= j then
            local item_j = items[j]
            local dest_lang = item_j.lang
            local dest_text = item_j.text
            if dest_text and dest_text ~= "" then
              local isPhrase = strfind(src_text, " ") or strfind(dest_text, " ") or strlen(src_text) > 12 or src_lang == "zh"
              local prefix = src_lang .. "_" .. dest_lang
              local key = string.lower(src_text)
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
    -- Guerrero (Warrior)
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

    -- Mago (Mage)
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

    -- Sacerdote (Priest)
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

    -- Pícaro (Rogue)
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

    -- Brujo (Warlock)
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

    -- Druida (Druid)
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

    -- Paladín (Paladin)
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

    -- Chamán (Shaman)
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

    -- Cazador (Hunter)
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
    "alimentar mascota|feed pet|喂养宠物"
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
    "el fin de los hermitas|the hermit's end|隐士的终结",
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
    "el secreto de alah'thalas|the secret of alah'thalas|亚拉萨拉斯的秘密"
  }

  -- ============================================================
  -- LOTE C: OBJETOS E ÍTEMS COMUNES Y EXCLUSIVOS (ITEMS)
  -- ============================================================
  local items_batch = {
    "trueno furioso|thunderfury|雷霆之怒",
    "trueno furioso espada bendecida del hijo del viento|thunderfury, blessed blade of the windseeker|雷霆之怒，逐风者的祝福之剑",
    "trueno furioso, espada bendecida del hijo del viento|thunderfury, blessed blade of the windseeker|雷霆之怒，逐风者的祝福之剑",
    "sulfuras, mano de ragnaros|sulfuras, hand of ragnaros|萨弗拉斯，炎魔拉格纳罗斯之手",
    "sulfuras mano de ragnaros|sulfuras, hand of ragnaros|萨弗拉斯，炎魔拉格纳罗斯之手",
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
    "ateish, gran báculo del guardián|atiesh, greatstaff of the guardian|埃提耶什，守护者的传说之杖",
    "atiesh gran baculo del guardian|atiesh, greatstaff of the guardian|埃提耶什，守护者的传说之杖",
    "atiesh, gran baculo del guardian|atiesh, greatstaff of the guardian|埃提耶什，守护者的传说之杖",
    "atiesh|atiesh|埃提耶什",
    "crepusculo|twilight|暮光",
    "crepúsculo|twilight|暮光",
    "ashbringer corrupta|corrupted ashbringer|堕落的灰烬使者",
    "la ashbringer|ashbringer|灰烬使者",
    "cazador de hojas|leaf hunter|叶子弓",
    "arco de hoja de cazador|rhok'delar, longbow of the ancient keepers|罗克迪拉，上古守护者的长弓",
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
    "frasco de sabiduría destilada|flask of distilled wisdom|精炼智慧合剂"
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
    "hola a todos, como estan|hi all how are you|大家好，你们好吗",
    "hola a todos, cómo están|hi all how are you|大家好，你们好吗",
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
    "buen grupo|good group|优秀的队伍"
  }

  -- Ejecutar la carga masiva en lotes comprimidos
  load_batch(spells_batch)
  load_batch(quests_batch)
  load_batch(items_batch)
  load_batch(slang_batch)

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
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ffcc[TR]|r Base de Datos v6.0.0 cargada. Spells, Quests y items indexados.")
  end
end)
