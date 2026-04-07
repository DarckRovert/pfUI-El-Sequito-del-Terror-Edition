import os

# --- BASE DE DATOS LINGÜÍSTICA (WoW Vanilla / Turtle WoW) --- #
# Formato: {"español": "inglés"}
# Se expande automáticamente al inverso para crear diccionarios bidireccionales

wow_dict_base = {
    # 1. Frases Hechas (Slang / LFG)
    "busco grupo": "looking for group",
    "buscando grupo": "lfg",
    "buscando más": "lfm",
    "busco mas": "lfm",
    "necesitamos tanque": "need tank",
    "ocupamos tanque": "need tank",
    "necesitamos sanador": "need healer",
    "necesito heal": "need heal",
    "necesitamos dps": "need dps",
    "alguien para": "anyone for",
    "inviten": "invite",
    "invítame": "inv me",
    "dame invi": "inv me",
    "estamos llenos": "we are full",
    "grupo lleno": "group full",
    "buenas": "hello",
    "hola": "hi",
    "adiós": "bye",
    "nos vemos": "see ya",
    "gracias": "thanks",
    "de nada": "yw",
    "buen juego": "gg",
    "buen grupo": "good group",
    "qué tal": "what's up",
    "dónde estás": "where are you",
    "vamos": "let's go",
    "ven aquí": "come here",
    "voy en camino": "on my way",
    "espera": "wait",
    "listo": "ready",
    "r": "r",
    "listos": "ready",
    "revive": "ress",
    "revíveme": "ress me",
    "necesito maná": "oom",
    "sin maná": "oom",
    "maná": "mana",
    "cuidado": "watch out",
    "cuidado con el pull": "careful pull",
    "no aggrees": "don't pull",
    "yo tanqueo": "i'll tank",
    "yo curo": "i'll heal",
    "pega": "attack",
    "fuego a": "focus",
    "maten a": "kill",
    "oveja": "sheep",
    "congela": "trap",
    "sal de ahí": "move out",
    "jefe": "boss",
    "ayuda": "help",
    "auxilio": "help",

    # 2. Clases y Roles
    "guerrero": "warrior",
    "warr": "warr",
    "mago": "mage",
    "sacerdote": "priest",
    "sacer": "priest",
    "pícaro": "rogue",
    "picaro": "rogue",
    "brujo": "warlock",
    "lock": "lock",
    "cazador": "hunter",
    "caza": "hunter",
    "paladín": "paladin",
    "pala": "pala",
    "chamán": "shaman",
    "druida": "druid",
    "feral": "feral",
    "tanque": "tank",
    "sanador": "healer",
    "sanadores": "healers",
    "daño": "dps",
    
    # 3. Zonas y Mazmorras (Vanilla Classic)
    "castillo de colmillo oscuro": "sfk",
    "minas de la muerte": "vc",
    "vancleef": "vc",
    "sima ígnea": "rfc",
    "sima ignea": "rfc",
    "cavernas de los lamentos": "wc",
    "cavernas de lamentos": "wc",
    "horado rajagrillo": "rfd",
    "zahúrda rajagrillo": "rfk",
    "gnomeregan": "gnomeregan",
    "monasterio escarlata": "sm",
    "catedral": "cath",
    "biblioteca": "lib",
    "armería": "armory",
    "armory": "armory",
    "cementerio": "gy",
    "monasterio": "sm",
    "uldaman": "ulda",
    "maraudon": "mara",
    "templo sumergido": "st",
    "profundidades de rocanegra": "brd",
    "cumbre de rocanegra": "brs",
    "cumbre inferior": "lbrs",
    "cumbre superior": "ubrs",
    "scholomance": "scholo",
    "stratholme": "strat",
    "la masacre": "dm",
    "masacre norte": "dm north",
    "masacre este": "dm east",
    "masacre oeste": "dm west",
    "naxxramas": "naxx",
    "guarida de alanegra": "bwl",
    "núcleo de magma": "mc",
    "ruinas de ahn'qiraj": "aq20",
    "templo de ahn'qiraj": "aq40",
    "zul'gurub": "zg",
    "onyxia": "ony",

    # 4. Modificadores y Gramática Básica
    "el": "the",
    "la": "the",
    "los": "the",
    "las": "the",
    "un": "a",
    "una": "a",
    "unos": "some",
    "unas": "some",
    "para": "for",
    "con": "with",
    "en": "in",
    "a": "to",
    "y": "and",
    "o": "or",
    "de": "of",
    "que": "what",
    "qué": "what",
    "quien": "who",
    "quién": "who",
    "donde": "where",
    "dónde": "where",
    "cuando": "when",
    "por qué": "why",
    "porque": "because",
    "como": "how",
    "cómo": "how",
    "si": "yes",
    "no": "no",
    "quizás": "maybe",
    "tal vez": "maybe",
    "siempre": "always",
    "nunca": "never",
    "ahora": "now",
    "luego": "later",
    "antes": "before",
    "después": "after",
    "hoy": "today",
    "mañana": "tomorrow",

    # 5. Interacción del Juego
    "oro": "gold",
    "plata": "silver",
    "cobre": "copper",
    "comprar": "buy",
    "vendo": "wts",
    "vendo": "selling",
    "compro": "wtb",
    "compro": "buying",
    "cambio": "wtt",
    "oferta": "offer",
    "subasta": "auction",
    "casa de subastas": "ah",
    "correo": "mail",
    "buzón": "mailbox",
    "nivel": "level",
    "lvl": "lvl",
    "experiencia": "xp",
    "habilidad": "skill",
    "hechizo": "spell",
    "talentos": "talents",
    "equipo": "gear",
    "espada": "sword",
    "escudo": "shield",
    "hacha": "axe",
    "maza": "mace",
    "arco": "bow",
    "arma de fuego": "gun",
    "varita": "wand",
    "pocion": "potion",
    "poción": "potion",
    "comida": "food",
    "agua": "water",
    "buff": "buff",
    "buf": "buff",
    "montura": "mount",
    "mascota": "pet",
    "grupo": "party",
    "banda": "raid",
    "hermandad": "guild",
    "alianza": "alliance",
    "ally": "ally",
    "horda": "horde",
    "matar": "kill",
    "muerto": "dead",
    "vivo": "alive",
    "daño": "damage",
    "curación": "healing",
    "amenaza": "threat",
    "aggro": "aggro",

    # 6. Ciudades y Rutas
    "venta": "sw",
    "ventormenta": "stormwind",
    "estupor": "if",
    "forjaz": "ironforge",
    "darnassus": "darnassus",
    "orgrimmar": "org",
    "ogrimar": "org",
    "cima del trueno": "tb",
    "entrañas": "uc",
    "undercity": "uc",
    "booty bay": "bb",
    "bahía del botín": "bb",
    "trinquete": "ratchet",
    "gadgetzan": "gadget",
    "garganta grito de guerra": "wsg",
    "arathi": "ab",
    "cuenca de arathi": "ab",
    "valle de alterac": "av",

    # 7. Contextos específicos de combate
    "ataca": "attack",
    "aguanta": "hold",
    "corre": "run",
    "cúrate": "heal up",
    "beber": "drink",
    "bebiendo": "drinking",
    "comiendo": "eating",
    "descanso": "rest",
    "listo": "ready",
    "vamos": "go",
    "escondete": "hide",
    "sigueme": "follow me",
    "ven": "come",
    "detras": "behind",
    "cuidado": "look out",
    "salta": "jump",
    "usa": "use",
    "piedra": "hs",
    "piedra de hogar": "hearthstone"
}

# Add sorted keys so longer phrases match first
sorted_keys_es = sorted(wow_dict_base.keys(), key=lambda x: len(x), reverse=True)

lua_output = '''pfUI:RegisterModule("translator_dict", "vanilla", function ()
  -- LIBRERIA LÉXICA OFFLINE (Generada vía Gravity AI Bridge)
  -- Contiene mapeos direccionales ES <-> EN optimizados para memoria.
  
  pfUI.translator_dicts = pfUI.translator_dicts or {}
  pfUI.translator_dicts.esES_enUS = {}
  pfUI.translator_dicts.enUS_esES = {}
  pfUI.translator_dicts.esES_keys = {}
  pfUI.translator_dicts.enUS_keys = {}
'''

# Generar Lua de diccionarios ES -> EN
for es_k in sorted_keys_es:
    en_v = wow_dict_base[es_k]
    # Escape comillas para lua
    es_k_esc = es_k.replace('"', '\\"')
    en_v_esc = en_v.replace('"', '\\"')
    # Add to dictionary
    lua_output += f'  pfUI.translator_dicts.esES_enUS["{es_k_esc}"] = "{en_v_esc}"\n'
    lua_output += f'  table.insert(pfUI.translator_dicts.esES_keys, "{es_k_esc}")\n'

lua_output += "\n  -- ALGORITHM PIVOT (EN -> ES Reverse mapping)\n"

# Create EN -> ES dictionary, handle duplicates by keeping the longest or first match
en_es_dict = {}
for es_k, en_v in wow_dict_base.items():
    if en_v not in en_es_dict:
        en_es_dict[en_v] = es_k

sorted_keys_en = sorted(en_es_dict.keys(), key=lambda x: len(x), reverse=True)

for en_k in sorted_keys_en:
    es_v = en_es_dict[en_k]
    en_k_esc = en_k.replace('"', '\\"')
    es_v_esc = es_v.replace('"', '\\"')
    lua_output += f'  pfUI.translator_dicts.enUS_esES["{en_k_esc}"] = "{es_v_esc}"\n'
    lua_output += f'  table.insert(pfUI.translator_dicts.enUS_keys, "{en_k_esc}")\n'

lua_output += 'end)\n'

with open(r"E:\Turtle Wow\Interface\AddOns\pfUI\modules\translator_dict.lua", "w", encoding="utf-8") as f:
    f.write(lua_output)

print("Diccionario Lua compilado con éxito.")
