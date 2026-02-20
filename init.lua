-- Chester v12 - Bot d'aide avec base PostgreSQL
-- API HTTP vers PostgreSQL pour recherche de connaissances

local storage = minetest.get_mod_storage()
local CHESTER_COLOR = minetest.colorize("#A020F0", "[Chester]")
local last_response = {}
local CHESTER_SPAWN = {x = -754, y = 1.5, z = -230}

-- Configuration API
local API_URL = "http://localhost:8080/chester_api.php"
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

-- Envoyer un message Chester
local function chester_say(text, player_name)
	if player_name then
		minetest.chat_send_player(player_name, CHESTER_COLOR .. " " .. text)
	else
		minetest.chat_send_all(CHESTER_COLOR .. " " .. text)
	end
end

-- Recherche dans PostgreSQL via API
local function search_knowledge(keyword, player_name)
	if not http then
		chester_say("Desole, je ne peux pas acceder a ma base de connaissances pour le moment.", player_name)
		minetest.log("error", "[Chester] HTTP non disponible")  -- ← AJOUTE
		return
	end
	
	local url = API_URL .. "?q=" .. minetest.encode_uri_component(keyword)
	minetest.log("action", "[Chester] Requete API: " .. url)  -- ← AJOUTE
	
	local url = API_URL .. "?q=" .. minetest.encode_uri_component(keyword)
	
	http.fetch({
		url = url,
		timeout = 5,
		method = "GET"
	}, function(result)
		if result.succeeded and result.code == 200 then
			-- Parser la reponse JSON
			local success, data = pcall(minetest.parse_json, result.data)
			
			if success and data and data.success and data.data then
				-- Envoyer la reponse au joueur
				local content = data.data.content
				local category = data.data.category
				
				-- Formater la reponse
				chester_say("(" .. category .. ") " .. content, player_name)
			else
				-- Pas de resultat trouve
				chester_say("Je ne connais pas '" .. keyword .. "'. Essaie /chester list pour voir ce que je connais !", player_name)
			end
		else
			-- Erreur HTTP
			minetest.log("warning", "[Chester] Erreur API: " .. (result.code or "timeout"))
			chester_say("Oups, j'ai un petit probleme de memoire la. Reessaie dans quelques secondes !", player_name)
		end
	end)
end

-- Liste des categories disponibles
local function list_categories(player_name)
	if not http then
		chester_say("Ma base de connaissances n'est pas accessible.", player_name)
		return
	end
	
	-- Pour l'instant on liste les categories connues
	-- TODO: Ajouter endpoint /categories a l'API
	local categories = {
		"mod", "mod_ethereal", "mod_glooptest", "mod_gloopblocks",
		"mod_rings", "mod_supercub", "minerai", "guide"
	}
	
	chester_say("Categories disponibles : " .. table.concat(categories, ", "), player_name)
	chester_say("Utilise /chester help <mot> pour avoir de l'aide !", player_name)
end

-- Anti-spam : verifier si peut repondre
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
			chester_say("Je suis Chester, ton guide ! Tape /chester help <sujet> pour avoir de l'aide. Par exemple : /chester help ethereal", player_name)
		end
	end)
end)

-- Commande /chester
minetest.register_chatcommand("chester", {
	params = "<help/list> [mot-cle]",
	description = "Demander de l'aide a Chester",
	func = function(name, param)
		if not can_respond(name) then
			return false, "Attends un peu avant de me reposer une question !"
		end
		
		local args = {}
		for word in param:gmatch("%S+") do
			table.insert(args, word)
		end
		
		if #args == 0 or args[1] == "help" then
			if #args < 2 then
				chester_say("Utilise /chester help <mot> pour avoir des infos. Exemple : /chester help ethereal", name)
				return true
			end
			
			-- Recherche dans la base
			local keyword = args[2]:lower()
			search_knowledge(keyword, name)
			return true
		end
		
		if args[1] == "list" then
			list_categories(name)
			return true
		end
		
		return false, "Commandes : /chester help <mot> ou /chester list"
	end
})

-- Commande /spawn (teleportation)
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

-- Spawn du NPC Chester avec eggs
-- Depend de mobs_redo
if minetest.get_modpath("mobs") then
	mobs:register_mob("chester:chester_npc", {
		type = "npc",
		passive = true,
		hp_min = 100,
		hp_max = 100,
		armor = 100,
		collisionbox = {-0.35, -1, -0.35, 0.35, 0.8, 0.35},
		visual = "mesh",
		mesh = "character.b3d",
		textures = {
			{"chester_npc.png"}
		},
		makes_footstep_sound = true,
		sounds = {},
		walk_velocity = 0,
		run_velocity = 0,
		jump = false,
		drops = {},
		water_damage = 0,
		lava_damage = 0,
		light_damage = 0,
		follow = {},
		view_range = 15,
		owner = "",
		order = "stand",
		fear_height = 0,
		jump_height = 0,
		stepheight = 0,
		automatic_face_movement_dir = false,
		fear_height = 0,
		walk_chance = 0,           -- ← AJOUTE
		stand_chance = 100,        -- ← AJOUTE
		jump_chance = 0,           -- ← AJOUTE
		pathfinding = false,       -- ← AJOUTE
		floats = 0,                -- ← AJOUTE
		collisionbox = {-0.35, 0, -0.35, 0.35, 1.8, 0.35},
		physical = true,              -- ← AJOUTE
		collide_with_objects = true,  -- ← AJOUTE
		animation = {
			speed_normal = 0,       -- ← Change de 30 à 0
			speed_run = 0,          -- ← Change de 30 à 0
			stand_start = 0,
			stand_end = 79,
			walk_start = 0,         -- ← Change de 168 à 0
			walk_end = 79,          -- ← Change de 187 à 79
			run_start = 0,          -- ← Change de 168 à 0
			run_end = 79,           -- ← Change de 187 à 79
			punch_start = 200,
			punch_end = 219,
		},
		
		on_rightclick = function(self, clicker)
			local name = clicker:get_player_name()
			
			if not can_respond(name) then
				chester_say("Attends un peu avant de me parler a nouveau !", name)
				return
			end
			
			local responses = {
				"Bonjour ! Tape /chester help <sujet> pour que je t'aide !",
				"Salut ! Tu cherches de l'aide ? Utilise /chester help <mot>",
				"Coucou ! Je connais plein de choses sur les mods du serveur !",
				"Hello ! Besoin d'aide ? /chester list pour voir ce que je sais !"
			}
			
			chester_say(responses[math.random(#responses)], name)
		end
	})
	
	-- Egg de spawn Chester (privilege server)
	mobs:register_egg("chester:chester_npc", "Chester NPC", "chester_npc.png", 0)
	
	-- Spawn unique de Chester au demarrage
	minetest.register_on_mods_loaded(function()
		minetest.after(3, function()  -- Attendre que le monde soit bien chargé
			-- Compter tous les Chester existants
			local all_objects = minetest.luaentities
			local chester_count = 0
			
			for id, entity in pairs(all_objects) do
				if entity.name == "chester:chester_npc" then
					chester_count = chester_count + 1
				end
			end
			
			minetest.log("action", "[Chester] " .. chester_count .. " Chester(s) trouve(s)")
			
			-- Si aucun Chester, en spawn un
			if chester_count == 0 then
				local chester = minetest.add_entity(CHESTER_SPAWN, "chester:chester_npc")
				if chester then
					local ent = chester:get_luaentity()
					if ent then
						ent.nametag = "Chester"
						ent.tamed = true
					end
					minetest.log("action", "[Chester] Chester spawne au spawn")
				end
			end
		end)
	end)
	
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
				return true, "Oeuf de Chester donne !"
			end
			return false
		end
	})
end

minetest.log("action", "[Chester] v12 charge avec API PostgreSQL (" .. API_URL .. ")")
