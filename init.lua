-- Chester v13 - Bot d'aide avec base PostgreSQL + Ollama fallback + materials context
-- API HTTP vers PostgreSQL pour recherche de connaissances
-- Fallback Ollama avec contexte nodes/crafts du serveur

local storage = minetest.get_mod_storage()
local CHESTER_COLOR = minetest.colorize("#A020F0", "[Chester]")
local last_response = {}
local CHESTER_SPAWN = {x = -754, y = 1.5, z = -230}

-- Configuration API PostgreSQL
local API_URL = "http://localhost/chester_api.php"

-- Configuration Ollama
local OLLAMA_URL = "http://127.0.0.1:11434/v1/chat/completions"
local OLLAMA_MODEL = "llama3.2"  -- adapte selon ton modele Ollama

local OLLAMA_SYSTEM_PROMPT = [[
Tu es Chester, le guide sympathique du serveur Minetest "Amelaye in Minerland".
Tu aides les joueurs (souvent des enfants) avec des reponses courtes et simples.
Tu connais les mods : ethereal, glooptest, gloopblocks, rings, supercub.
Reponds toujours en francais, en 2-3 lignes maximum.
Tutoie toujours les joueurs.
Si tu ne sais vraiment pas, dis-le honnetement.
]]

-- HTTP API
local http = minetest.request_http_api()

if not http then
	minetest.log("error", "[Chester] HTTP API non disponible - verifier secure.http_mods dans minetest.conf")
end

-- Charger le contexte des materiaux
local mod_dir = minetest.get_modpath("chester")
local chester_materials = dofile(mod_dir .. "/chester_materials_context.lua")

-- Messages de bienvenue
local welcome_messages = {
	[1] = "Bienvenue sur Amelaye in Minerland ! Va à l'academie via la cabine verte, decouvre les sites majestueux avec la cabine bleue. Tu peux explorer aux alentours et construire dans un endroit eloigne des autres constructions de 500 blocs. Utilise le bouton dans le spawn pour etre teleporte dans une zone non construite !",
	[2] = "Bon retour parmi nous !",
	[3] = "Content de te revoir !"
}

-- Fonction pour encoder les URL
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
local function chester_say(text, player_name, private)
	if private and player_name then
		minetest.chat_send_player(player_name, CHESTER_COLOR .. " " .. text)
	else
		minetest.chat_send_all(CHESTER_COLOR .. " " .. text)
	end
end

-- Fallback Ollama direct avec contexte materials
local function ask_ollama(question, player_name)
	if not http then return end

	chester_say("Un instant je réfléchis ...", player_name, false)

	local system = OLLAMA_SYSTEM_PROMPT
	if chester_materials and chester_materials.get_available_materials then
		system = system .. "\n\n" .. chester_materials.get_available_materials()
	end

	local body = minetest.write_json({
		model = OLLAMA_MODEL,
		messages = {
			{ role = "system", content = system },
			{ role = "user",   content = question }
		},
		max_tokens = 300
	})

	http.fetch({
		url = OLLAMA_URL,
		method = "POST",
		post_data = body,
		extra_headers = {
			"Content-Type: application/json",
			"Authorization: Bearer ollama"
		},
		timeout = 60,
	}, function(result)
		if result.succeeded and result.code == 200 then
			local ok, data = pcall(minetest.parse_json, result.data)
			if ok and data and data.choices and data.choices[1] then
				local text = data.choices[1].message.content
				chester_say(text, player_name, false)
				minetest.log("action", "[Chester] Reponse Ollama+materials envoyee a " .. player_name)
			else
				chester_say("Je n'ai pas trouve de reponse sur ca, desole !", player_name, false)
			end
		else
			chester_say("Oups, je ne sais pas repondre a ca pour le moment !", player_name, false)
			minetest.log("warning", "[Chester] Ollama error code=" .. tostring(result.code))
		end
	end)
end

-- Recherche dans PostgreSQL via API, fallback Ollama si rien trouve
local function search_knowledge(question, player_name)
	if not http then
		chester_say("Desole, je ne peux pas acceder a ma base de connaissances pour le moment.", player_name, false)
		minetest.log("error", "[Chester] HTTP non disponible")
		return
	end

	local url = API_URL .. "?q=" .. url_encode(question)
	minetest.log("action", "[Chester] Requete API: " .. url .. " pour " .. player_name)

	http.fetch({
		url = url,
		timeout = 30,
		method = "GET"
	}, function(result)
		if result.succeeded and result.code == 200 then
			local success, data = pcall(minetest.parse_json, result.data)

			if success and data and data.success and data.data then
				local content = data.data.content

				-- Distinction reponse PostgreSQL vs Ollama (gere par l'API PHP)
				if data.data.generated then
					chester_say(content, player_name, false)
					minetest.log("action", "[Chester] Reponse Ollama (via API PHP) envoyee a " .. player_name)
				else
					chester_say(content, player_name, false)
					minetest.log("action", "[Chester] Reponse PostgreSQL envoyee a " .. player_name)
				end
			else
				-- Rien trouve -> fallback Ollama direct avec contexte materials
				minetest.log("action", "[Chester] Aucun resultat API, fallback Ollama+materials pour: " .. question)
				ask_ollama(question, player_name)
			end
		else
			minetest.log("warning", "[Chester] Erreur API code=" .. tostring(result.code) .. " pour " .. question)
			chester_say("Oups, j'ai un petit probleme de memoire la. Reessaie dans quelques secondes !", player_name, false)
		end
	end)
end

-- Traiter une question
local function process_question(question, player_name)
	search_knowledge(question, player_name)
end


-- Liste des categories disponibles
local function list_categories(player_name)
	chester_say("Je peux t'aider sur :", player_name, true)
	chester_say("- Les mods : ethereal, glooptest, gloopblocks, rings, supercub", player_name, true)
	chester_say("- Les arbres et plantes (pommes dorees, bananiers, etc)", player_name, true)
	chester_say("- Les anneaux magiques (voler, feu, eau, etc)", player_name, true)
	chester_say("- L'avion supercub (pilotage)", player_name, true)
	chester_say("- Les minerais (kalite, alatro, etc)", player_name, true)
	chester_say("", player_name, true)
	chester_say("Pose-moi une question comme : 'chester ou trouver des pommes dorees ?'", player_name, true)
end

-- Anti-spam
local function can_respond(player_name)
	local now = os.time()
	local last = last_response[player_name] or 0
	if now - last < 2 then return false end
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
		chester_say(msg, player_name, true)
		if login_count == 1 then
			chester_say("Je suis Chester, ton guide ! Tu peux me poser des questions en ecrivant 'chester' suivi de ta question.", player_name, true)
			chester_say("Exemple : chester ou trouver des pommes dorees ?", player_name, true)
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
			chester_say("Pose-moi une question ! Exemple : chester ou trouver des pommes dorees ?", name, true)
			return true
		end
		if param == "list" then
			list_categories(name)
			return true
		end
		process_question(param, name)
		return true
	end
})

-- Ecouter le chat pour "chester <question>"
minetest.register_on_chat_message(function(name, message)
	local msg_lower = message:lower()
	if msg_lower:match("^chester[%s,:]") or msg_lower == "chester" then
		if not can_respond(name) then
			chester_say("Attends un peu avant de me reposer une question !", name, true)
			return false
		end
		local question = message:match("[Cc]hester[%s,:]*(.+)")
		if question and question ~= "" then
			process_question(question, name)
		else
			chester_say("Oui ? Pose-moi une question !", name, true)
			chester_say("Exemple : chester ou trouver des pommes dorees ?", name, true)
		end
		return false
	end
end)


local punch_count = {}

-- Spawn du NPC Chester (optionnel avec mobs_redo)
if minetest.get_modpath("mobs") then
	mobs:register_mob("chester:chester_npc", {
		type = "npc",
		nametag = "Chester",
		description = "Chester - Guide du serveur",
		passive = true,
		hp_min = 100,
		hp_max = 100,
		immortal = false,
		invulnerable = false,
		damage_texture_modifier = "",
		armor = 100,
		collisionbox = {-0.35, 0, -0.35, 0.35, 1.8, 0.35},
		physical = true,
		collide_with_objects = true,
		visual = "mesh",
		mesh = "character.b3d",
		textures = { {"chester_npc.png"} },
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
			speed_normal = 0, speed_run = 0,
			stand_start = 0,  stand_end = 79,
			walk_start = 0,   walk_end = 79,
			run_start = 0,    run_end = 79,
			punch_start = 200, punch_end = 219,
		},

		on_rightclick = function(self, clicker)
			if not self.nametag or self.nametag == "" then
				self.nametag = "Chester"
			end
			local name = clicker:get_player_name()
			if not can_respond(name) then
				chester_say("Attends un peu avant de me parler a nouveau !", name, true)
				return
			end
			local responses = {
				"Bonjour ! Tu peux me poser des questions en ecrivant 'chester' suivi de ta question !",
				"Salut ! Essaie : chester ou trouver des pommes dorees ?",
				"Coucou ! Je connais plein de choses sur les mods du serveur ! Tape 'chester list'",
				"Hello ! Besoin d'aide ? Tape 'chester' suivi de ta question dans le chat !"
			}
			chester_say(responses[math.random(#responses)], name, true)
		end
	})

	-- Detection des coups sur Chester
	local last_check = {}

	minetest.register_globalstep(function(dtime)
		for _, player in pairs(minetest.get_connected_players()) do
			local player_name = player:get_player_name()
			local ctrl = player:get_player_control()
			if ctrl.dig or ctrl.LMB then
				local pos = player:get_pos()
				local dir = player:get_look_dir()
				local target_pos = vector.add(pos, vector.multiply(dir, 2))
				for _, obj in pairs(minetest.get_objects_inside_radius(target_pos, 2)) do
					local entity = obj:get_luaentity()
					if entity and entity.name == "chester:chester_npc" then
						local now = os.time()
						local last = last_check[player_name] or 0
						if now - last >= 1 then
							last_check[player_name] = now
							punch_count[player_name] = (punch_count[player_name] or 0) + 1
							local count = punch_count[player_name]
							if count == 1 then
								chester_say("Aie ! Arrete de me taper !", player_name, true)
							elseif count == 3 then
								chester_say("Serieux, arrete !", player_name, true)
							elseif count == 5 then
								chester_say("STOP !", player_name, true)
							elseif count == 8 then
								chester_say("DERNIER avertissement !", player_name, true)
							elseif count >= 10 then
								minetest.kick_player(player_name, "Violence envers Chester !")
								punch_count[player_name] = 0
							end
						end
					end
				end
			end
		end
	end)

	-- Forcer HP Chester a 100
	minetest.register_globalstep(function(dtime)
		for _, obj in pairs(minetest.luaentities) do
			if obj.name == "chester:chester_npc" then
				if obj.object and obj.object.set_hp then obj.object:set_hp(100) end
				if obj.health then obj.health = 100 end
			end
		end
	end)

	mobs:register_egg("chester:chester_npc", "Chester NPC", "chester_npc.png", 0)

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

minetest.log("action", "[Chester] v13 charge avec API PostgreSQL + Ollama fallback (" .. API_URL .. ")")