SMODS.load_file("src/jokers.lua")()
-- SMODS.load_file("src/decks.lua")()

to_number = to_number or function(x)
    return x
end

contains = function(table, item)
    for k, v in pairs(table) do
        if v == item then
            return true
        end
    end
    return false
end