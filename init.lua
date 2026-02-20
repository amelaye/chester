-- Chester v12 - Bot d'aide avec base PostgreSQL
-- API HTTP vers PostgreSQL pour recherche de connaissances

local storage = minetest.get_mod_storage()
local CHESTER_COLOR = minetest.colorize("#A020F0", "[Chester]")
local last_response = {}
local CHESTER_SPAWN = {x = -754, y = 1.5, z = -230}

-- Configuration API
local API_URL = "http://localhost/chester_api.php"
local http = minetest.request_http_api()

if not http then
	minetest.log("error", "[Chester] HTTP API non disponible - verifier secure.http_mods dans minetest.conf")
end

-- Messages de bienvenue
local welcome_messages = {
	[1] = "Bienvenue sur Amelaye in Minerland ! Allez a l'academie via la cabine bleue, decouvrez les sites majestueux avec la cabine rouge. Tu peux explorer aux alentours et construire dans un endroit eloigne des autres constructions de 500 blocs.",
	[2] = "Bon retour parmi nous ! N'oublie pas : utilise le bouton dans le spawn pour etre teleporte dans une zone non construite !",
	[3] = "Content de te revoir ! N'oublie pas : utilise le bouton dans le spawn pour etre teleporte dans une zone non construite !"
}

-- Mots-cles importants pour extraction de phrases
local keywords_map = {
	-- Arbres
	["pomme"] = "golden_apple",
	["pommes dorees"] = "golden_apple",
	["pommes dorées"] = "golden_apple",
	["golden apple"] = "golden_apple",
	["arbre jaune"] = "yellow_tree",
	["yellow tree"] = "yellow_tree",
	["healing tree"] = "yellow_tree",
	["bananier"] = "banana_tree",
	["banana"] = "banana_tree",
	["palmier"] = "palm_tree",
	["palm"] = "palm_tree",
	["olivier"] = "olive_tree",
	["olive"] = "olive_tree",
	["citronnier"] = "lemon_tree",
	["lemon"] = "lemon_tree",
	["cerisier"] = "sakura_tree",
	["sakura"] = "sakura_tree",
	["sequoia"] = "redwood_tree",
	["redwood"] = "redwood_tree",
	
	-- Anneaux
	["voler"] = "celestial_ring",
	["vol"] = "celestial_ring",
	["fly"] = "celestial_ring",
	["celestial"] = "celestial_ring",
	["feu"] = "infernal_ring",
	["lave"] = "infernal_ring",
	["infernal"] = "infernal_ring",
	["eau"] = "abyssal_ring",
	["ocean"] = "abyssal_ring",
	["respirer"] = "abyssal_ring",
	["abyssal"] = "abyssal_ring",
	["lumiere"] = "enlightning_ring",
	["briller"] = "enlightning_ring",
	["enlightning"] = "enlightning_ring",
	["poings"] = "hardening_ring",
	["hardening"] = "hardening_ring",
	["activation"] = "activation_ring",
	["anneau"] = "rings",
	["anneaux"] = "rings",
	
	-- Avion
	["avion"] = "supercub",
	["voler avion"] = "supercub",
	["piloter"] = "supercub",
	["supercub"] = "supercub",
	["decoller"] = "decoller",
	["atterrir"] = "atterrir",
	["carburant"] = "carburant_biofuel",
	
	-- Mods
	["ethereal"] = "ethereal",
	["glooptest"] = "glooptest",
	["gloopblocks"] = "gloopblocks",
	["rings"] = "rings",
	
	-- Minerais
	["pioche"] = "pioche",
	["pioches"] = "pioche",
	["pickaxe"] = "pioche",
	["fer"] = "fer",
	["iron"] = "fer",
	["diamant"] = "diamant",
	["diamond"] = "diamant",
	["mese"] = "mese",
	["or"] = "or",
	["gold"] = "or",
	["kalite"] = "kalite",
	["alatro"] = "alatro",
	["akalin"] = "akalin",
	["arol"] = "arol",
	["talinite"] = "talinite",
	
	-- Blocs
	["cement"] = "cement",
	["ciment"] = "cement",
	["evil"] = "evil_block",
	["rainbow"] = "rainbow_block",
	["basalt"] = "basalt",
	["basalte"] = "basalt",
	["pumice"] = "pumice",
	["obsidian"] = "obsidian",
	["obsidienne"] = "obsidian",
}

-- Fonction pour encoder les URL (si minetest.encode_uri_component n'existe pas)
local function url_encode(str)
	if str then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w %-%_%.%~])",
			function(c) return string.format("%%%02X", string.byte(c)) end)
		str = string.gsub(str, " ", "+")
	end
	return str
end

-- Envoyer un message Chester
local function chester_say(text, player_name)
	if player_name then
		minetest.chat_send_player(player_name, CHESTER_COLOR .. " " .. text)
	else
		minetest.chat_send_all(CHESTER_COLOR .. " " .. text)
	end
end

-- Extraire mots-cles d'une phrase
local function extract_keywords(phrase)
	local phrase_lower = phrase:lower()
	local found_keywords = {}
	
	-- Chercher les expressions multi-mots en premier
	for pattern, keyword in pairs(keywords_map) do
		if #pattern > 3 and phrase_lower:find(pattern, 1, true) then
			table.insert(found_keywords, keyword)
		end
	end
	
	-- Si rien trouvé, chercher les mots individuels
	if #found_keywords == 0 then
		for word in phrase_lower:gmatch("%w+") do
			if keywords_map[word] then
				table.insert(found_keywords, keywords_map[word])
			end
		end
	end
	
	return found_keywords
end

-- Recherche dans PostgreSQL via API
local function search_knowledge(keyword, player_name)
	if not http then
		chester_say("Desole, je ne peux pas acceder a ma base de connaissances pour le moment.", player_name)
		minetest.log("error", "[Chester] HTTP non disponible")
		return
	end
	
	local url = API_URL .. "?q=" .. url_encode(keyword)
	minetest.log("action", "[Chester] Requete API: " .. url .. " pour " .. player_name)
	
	http.fetch({
		url = url,
		timeout = 5,
		method = "GET"
	}, function(result)
		if result.succeeded and result.code == 200 then
			local success, data = pcall(minetest.parse_json, result.data)
			
			if success and data and data.success and data.data then
				local content = data.data.content
				
				chester_say(content, player_name)
				minetest.log("action", "[Chester] Reponse envoyee a " .. player_name .. " pour " .. keyword)
			else
				chester_say("Je ne connais pas '" .. keyword .. "'. Essaie de reformuler ou tape 'chester list' !", player_name)
				minetest.log("action", "[Chester] Aucun resultat pour: " .. keyword)
			end
		else
			minetest.log("warning", "[Chester] Erreur API code=" .. tostring(result.code) .. " pour " .. keyword)
			chester_say("Oups, j'ai un petit probleme de memoire la. Reessaie dans quelques secondes !", player_name)
		end
	end)
end

-- Traiter une question en langage naturel
local function process_question(question, player_name)
	local keywords = extract_keywords(question)
	
	if #keywords == 0 then
		chester_say("Je n'ai pas bien compris ta question. Peux-tu la reformuler ?", player_name)
		chester_say("Ou tape 'chester list' pour voir ce que je connais.", player_name)
		return
	end
	
	-- Rechercher le premier mot-cle trouve
	search_knowledge(keywords[1], player_name)
end

-- Liste des categories disponibles
local function list_categories(player_name)
	chester_say("Je peux t'aider sur :", player_name)
	chester_say("- Les mods : ethereal, glooptest, gloopblocks, rings, supercub", player_name)
	chester_say("- Les arbres et plantes (pommes dorees, bananiers, etc)", player_name)
	chester_say("- Les anneaux magiques (voler, feu, eau, etc)", player_name)
	chester_say("- L'avion supercub (pilotage)", player_name)
	chester_say("- Les minerais (kalite, alatro, etc)", player_name)
	chester_say("", player_name)
	chester_say("Pose-moi une question comme : 'chester ou trouver des pommes dorees ?'", player_name)
end

-- Anti-spam
local function can_respond(player_name)
	local now = os.time()
	local last = last_response[player_name] or 0
	
	if now - last < 2 then
		return false
	end
	
	last_response[player_name] = now
	return true
end

-- Message de bienvenue
minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local login_count = storage:get_int(player_name .. "_logins") or 0
	
	login_count = login_count + 1
	storage:set_int(player_name .. "_logins", login_count)
	
	minetest.after(2, function()
		local msg = welcome_messages[math.min(login_count, 3)]
		chester_say(msg, player_name)
		
		if login_count == 1 then
			chester_say("Je suis Chester, ton guide ! Tu peux me poser des questions en ecrivant 'chester' suivi de ta question.", player_name)
			chester_say("Exemple : chester ou trouver des pommes dorees ?", player_name)
		end
	end)
end)

-- Commande /chester
minetest.register_chatcommand("chester", {
	params = "<question ou list>",
	description = "Poser une question a Chester",
	func = function(name, param)
		if not can_respond(name) then
			return false, "Attends un peu avant de me reposer une question !"
		end
		
		if param == "" then
			chester_say("Pose-moi une question ! Exemple : chester ou trouver des pommes dorees ?", name)
			return true
		end
		
		if param == "list" then
			list_categories(name)
			return true
		end
		
		-- Traiter la question
		process_question(param, name)
		return true
	end
})

-- Ecouter le chat pour "chester <question>"
minetest.register_on_chat_message(function(name, message)
	local msg_lower = message:lower()
	
	-- Detecter si le message commence par "chester"
	if msg_lower:match("^chester[%s,:]") or msg_lower == "chester" then
		if not can_respond(name) then
			chester_say("Attends un peu avant de me reposer une question !", name)
			return false
		end
		
		-- Extraire la question (tout ce qui suit "chester")
		local question = message:match("[Cc]hester[%s,:]*(.+)")
		
		if question and question ~= "" then
			process_question(question, name)
		else
			chester_say("Oui ? Pose-moi une question !", name)
			chester_say("Exemple : chester ou trouver des pommes dorees ?", name)
		end
		
		return false
	end
end)

-- Commande /spawn
minetest.register_chatcommand("spawn", {
	description = "Se teleporter au spawn",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if player then
			player:set_pos(CHESTER_SPAWN)
			chester_say("Te voila au spawn !", name)
			return true
		end
		return false, "Erreur de teleportation"
	end
})

-- Commande admin cleanup
minetest.register_chatcommand("chester_cleanup", {
	description = "Supprimer tous les Chester sauf un (admin)",
	privs = {server = true},
	func = function(name)
		local count = 0
		local kept = false
		
		for _, obj in pairs(minetest.luaentities) do
			if obj.name == "chester:chester_npc" then
				if not kept then
					kept = true
					minetest.log("action", "[Chester] Chester garde")
				else
					obj.object:remove()
					count = count + 1
				end
			end
		end
		
		return true, "Chester cleanup: " .. count .. " supprime(s)"
	end
})

-- Spawn du NPC Chester (optionnel avec mobs_redo)
if minetest.get_modpath("mobs") then
	mobs:register_mob("chester:chester_npc", {
		type = "npc",
		nametag = "Chester",
		description = "Chester - Guide du serveur",
		passive = true,
		hp_min = 100,
		hp_max = 100,
		immortal = true,
		invulnerable = true,
		damage_texture_modifier = "",  -- ← AJOUTE (pas de flash rouge)

		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			return true  -- Bloque tous les dégâts
		end,
		armor = 100,
		collisionbox = {-0.35, 0, -0.35, 0.35, 1.8, 0.35},
		physical = true,
		collide_with_objects = true,
		visual = "mesh",
		mesh = "character.b3d",
		textures = {
			{"chester_npc.png"}
		},
		makes_footstep_sound = false,
		sounds = {},
		walk_velocity = 0,
		run_velocity = 0,
		jump = false,
		jump_height = 0,
		stepheight = 0,
		walk_chance = 0,
		stand_chance = 100,
		jump_chance = 0,
		pathfinding = false,
		floats = 0,
		automatic_face_movement_dir = false,
		drops = {},
		water_damage = 0,
		lava_damage = 0,
		light_damage = 0,
		follow = {},
		view_range = 15,
		owner = "",
		order = "stand",
		fear_height = 0,
		animation = {
			speed_normal = 0,
			speed_run = 0,
			stand_start = 0,
			stand_end = 79,
			walk_start = 0,
			walk_end = 79,
			run_start = 0,
			run_end = 79,
			punch_start = 200,
			punch_end = 219,
		},
		
		on_rightclick = function(self, clicker)
			-- Forcer le nametag
			if not self.nametag or self.nametag == "" then
				self.nametag = "Chester"
			end
			
			local name = clicker:get_player_name()
			
			if not can_respond(name) then
				chester_say("Attends un peu avant de me parler a nouveau !", name)
				return
			end
			
			local responses = {
				"Bonjour ! Tu peux me poser des questions en ecrivant 'chester' suivi de ta question !",
				"Salut ! Essaie : chester ou trouver des pommes dorees ?",
				"Coucou ! Je connais plein de choses sur les mods du serveur ! Tape 'chester list'",
				"Hello ! Besoin d'aide ? Tape 'chester' suivi de ta question dans le chat !"
			}
			
			chester_say(responses[math.random(#responses)], name)
		end
	})
	
	-- Egg de spawn Chester (privilege server)
	mobs:register_egg("chester:chester_npc", "Chester NPC", "chester_npc.png", 0)
	
	-- Commande admin pour donner l'egg
	minetest.register_chatcommand("giveme_chester", {
		params = "",
		description = "Donne l'oeuf de spawn Chester (admin)",
		privs = {server = true},
		func = function(name)
			local player = minetest.get_player_by_name(name)
			if player then
				local inv = player:get_inventory()
				inv:add_item("main", "chester:chester_npc")
				return true, "Oeuf de Chester donne ! Place-le au spawn."
			end
			return false
		end
	})
end

minetest.log("action", "[Chester] v12 charge avec API PostgreSQL (" .. API_URL .. ")")