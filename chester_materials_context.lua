-- chester_materials_context.lua
-- Scanne les nodes, items, outils et recettes du serveur
-- Utilisé pour enrichir le prompt Ollama quand PostgreSQL ne trouve rien

local M = {}

-- Cache pour éviter de tout recalculer à chaque requête
local materials_cache = nil
local materials_cache_hash = nil

-- Hash maison (minetest n'a pas core.sha1)
local function compute_materials_hash()
    local count = 0
    for _ in pairs(minetest.registered_nodes) do count = count + 1 end
    for _ in pairs(minetest.registered_craftitems) do count = count + 1 end
    for _ in pairs(minetest.registered_tools) do count = count + 1 end
    return tostring(count)
end

-- Formatte une recette de craft en texte lisible
local function format_recipe(recipe)
    if not recipe or not recipe.items then return nil end

    local items = {}
    for _, item in pairs(recipe.items) do
        if item and item ~= "" then
            table.insert(items, item)
        end
    end

    if #items == 0 then return nil end
    return table.concat(items, " + ")
end

-- Fonction principale appelée depuis init.lua
function M.get_available_materials()
    local current_hash = compute_materials_hash()

    -- Retourner le cache si rien n'a changé
    if materials_cache and materials_cache_hash == current_hash then
        return materials_cache
    end

    local lines = {}
    local max_items = 200

    -- Nodes
    for name, def in pairs(minetest.registered_nodes) do
        if not name:match("^__builtin:") and name ~= "ignore" and name ~= "air" then
            local desc = (def.description and def.description ~= "") and (" (" .. def.description .. ")") or ""
            table.insert(lines, "Node: " .. name .. desc)
        end
        if #lines >= max_items then break end
    end

    -- Craftitems
    for name, def in pairs(minetest.registered_craftitems) do
        if not name:match("^__builtin:") then
            local desc = (def.description and def.description ~= "") and (" (" .. def.description .. ")") or ""
            table.insert(lines, "Item: " .. name .. desc)
        end
        if #lines >= max_items then break end
    end

    -- Outils
    for name, def in pairs(minetest.registered_tools) do
        if not name:match("^__builtin:") then
            local desc = (def.description and def.description ~= "") and (" (" .. def.description .. ")") or ""
            table.insert(lines, "Tool: " .. name .. desc)
        end
        if #lines >= max_items then break end
    end

    -- Recettes de craft
    local craft_lines = {}
    for name, _ in pairs(minetest.registered_nodes) do
        local recipes = minetest.get_all_craft_recipes(name)
        if recipes then
            for _, recipe in ipairs(recipes) do
                local formatted = format_recipe(recipe)
                if formatted then
                    table.insert(craft_lines, "Craft: " .. name .. " = " .. formatted)
                end
            end
        end
        if #craft_lines >= 100 then break end
    end

    -- Fusionner nodes/items et crafts
    local total = #lines
    local output = "=== ITEMS DU SERVEUR (" .. total .. " enregistres) ===\n"

    for i, line in ipairs(lines) do
        output = output .. line .. "\n"
    end

    if total >= max_items then
        output = output .. "... (liste tronquee a " .. max_items .. " items)\n"
    end

    if #craft_lines > 0 then
        output = output .. "\n=== RECETTES DE CRAFT (" .. #craft_lines .. ") ===\n"
        for _, line in ipairs(craft_lines) do
            output = output .. line .. "\n"
        end
    end

    -- Mettre en cache
    materials_cache = output
    materials_cache_hash = current_hash

    return output
end

return M