-- chester_materials_context.lua v3
-- Injection ciblée des nodes selon la question (inspiré de LLM-Connect Asset Picker)

local M = {}

local mod_dir = minetest.get_modpath("chester")
local translations = dofile(mod_dir .. "/chester_translations.lua")

-- Nettoie les séquences de couleur Minetest
local function clean_desc(desc)
    if not desc then return "" end
    desc = desc:gsub("\027%([^)]*%)", "")
    desc = desc:gsub("\027E", "")
    desc = desc:gsub("\027", "")
    desc = desc:match("([^\n]+)") or desc
    desc = desc:match("^%s*(.-)%s*$")
    return desc
end

-- Extrait le nom du mod depuis un identifiant mod:item
local function extract_mod(question)
    return question:match("([%w_]+):[%w_]+")
end

-- Récupère les ingrédients d'un craft
local function get_craft(name)
    local recipes = minetest.get_all_craft_recipes(name)
    if not recipes or not recipes[1] then return nil end
    local ingredients = {}
    for _, item in pairs(recipes[1].items) do
        if item and item ~= "" then
            table.insert(ingredients, item)
        end
    end
    if #ingredients == 0 then return nil end
    return table.concat(ingredients, " + ")
end

-- Cherche les nodes/items/outils d'un mod spécifique
local function get_nodes_by_mod(mod_name)
    local results = {}
    local count = 0
    local max = 40

    for name, def in pairs(minetest.registered_nodes) do
        if count >= max then break end
        if name:match("^" .. mod_name .. ":") then
            local desc = clean_desc(def.description)
            if desc == "" then desc = name end
            table.insert(results, "NODE " .. name .. " : " .. desc)
            local craft = get_craft(name)
            if craft then
                table.insert(results, "CRAFT " .. name .. " : " .. craft)
            end
            count = count + 1
        end
    end

    for name, def in pairs(minetest.registered_tools) do
        if count >= max then break end
        if name:match("^" .. mod_name .. ":") then
            local desc = clean_desc(def.description)
            if desc == "" then desc = name end
            table.insert(results, "TOOL " .. name .. " : " .. desc)
            local craft = get_craft(name)
            if craft then
                table.insert(results, "CRAFT " .. name .. " : " .. craft)
            end
            count = count + 1
        end
    end

    for name, def in pairs(minetest.registered_craftitems) do
        if count >= max then break end
        if name:match("^" .. mod_name .. ":") then
            local desc = clean_desc(def.description)
            if desc == "" then desc = name end
            table.insert(results, "ITEM " .. name .. " : " .. desc)
            local craft = get_craft(name)
            if craft then
                table.insert(results, "CRAFT " .. name .. " : " .. craft)
            end
            count = count + 1
        end
    end

    return results
end

-- Cherche les nodes dont la description ou le nom contient un mot-clé
local function get_nodes_by_keyword(keyword)
    local results = {}
    local count = 0
    local max = 20
    local kw = keyword:lower()

    for name, def in pairs(minetest.registered_nodes) do
        if count >= max then break end
        local desc = clean_desc(def.description)
	if desc:lower():match("%f[%w]" .. kw .. "%f[%W]") or name:lower():match("%f[%w]" .. kw .. "%f[%W]") then
       -- if desc:lower():match(kw) or name:lower():match(kw) then
            if desc == "" then desc = name end
            table.insert(results, "NODE " .. name .. " : " .. desc)
            local craft = get_craft(name)
            if craft then
                table.insert(results, "CRAFT " .. name .. " : " .. craft)
            end
            count = count + 1
        end
    end

    for name, def in pairs(minetest.registered_tools) do
        if count >= max then break end
        local desc = clean_desc(def.description)
        if desc:lower():match(kw) or name:lower():match(kw) then
            if desc == "" then desc = name end
            table.insert(results, "TOOL " .. name .. " : " .. desc)
            local craft = get_craft(name)
            if craft then
                table.insert(results, "CRAFT " .. name .. " : " .. craft)
            end
            count = count + 1
        end
    end

    for name, def in pairs(minetest.registered_craftitems) do
        if count >= max then break end
        local desc = clean_desc(def.description)
        if desc:lower():match(kw) or name:lower():match(kw) then
            if desc == "" then desc = name end
            table.insert(results, "ITEM " .. name .. " : " .. desc)
            local craft = get_craft(name)
            if craft then
                table.insert(results, "CRAFT " .. name .. " : " .. craft)
            end
            count = count + 1
        end
    end

    return results
end

-- Fonction principale : retourne le contexte ciblé selon la question
function M.get_context_for_question(question)
    local q = question:lower()

    -- Cas 1 : identifiant mod:item détecté
    local mod_name = extract_mod(q)
    if mod_name and mod_name ~= "" then
        local nodes = get_nodes_by_mod(mod_name)
        if #nodes > 0 then
            return "=== ITEMS DU MOD '" .. mod_name .. "' SUR CE SERVEUR ===\n"
                .. table.concat(nodes, "\n")
        end
    end

    -- Cas 2 : recherche par mots-clés
    local ignored = {
        "quoi", "quel", "comment", "faire", "sert", "est", "que",
        "pour", "dans", "avec", "les", "des", "une", "chester",
        "peut", "peux", "fais", "trouver", "avoir", "obtenir",
        "dire", "savoir", "connais", "connait", "sais", "fait",
        "reine", "roi", "qui", "quand", "alors", "donc", "mais"
    }

    local words = {}
    for word in q:gmatch("[%w_]+") do
        if #word >= 5 then
            local skip = false
            for _, ign in ipairs(ignored) do
                if word == ign then skip = true; break end
            end
            if not skip then
                table.insert(words, word)
            end
        end
    end

    -- Traduire les mots français en anglais
    for i, word in ipairs(words) do
        if translations[word] then
            words[i] = translations[word]
        end
    end

    -- Dédoublonner après traduction
    local seen_words = {}
    local unique_words = {}
    for _, word in ipairs(words) do
        if not seen_words[word] then
            seen_words[word] = true
            table.insert(unique_words, word)
        end
    end

    local all_results = {}
    local seen = {}
    for _, word in ipairs(unique_words) do
        local results = get_nodes_by_keyword(word)
        for _, r in ipairs(results) do
            if not seen[r] then
                seen[r] = true
                table.insert(all_results, r)
            end
        end
    end

    if #all_results > 0 then
        return "=== ITEMS CORRESPONDANTS SUR CE SERVEUR ===\n"
            .. table.concat(all_results, "\n")
    end

    -- Cas 3 : rien trouvé
    return nil
end

return M
