SMODS.load_file("src/jokers.lua")()
SMODS.load_file("src/decks.lua")()
SMODS.load_file("src/vouchers.lua")()
SMODS.load_file("src/blinds.lua")()
SMODS.load_file("src/consumables.lua")()
SMODS.load_file("src/misc.lua")()

SMODS.current_mod.extra_tabs = function()
	return {
		label = "Shoutouts",
		tab_definition_function = function()
			return {
				n = G.UIT.ROOT,
				config = {
					align = "cm",
					padding = 0.05,
					colour = G.C.CLEAR,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = {
							padding = 0,
							align = "cm"
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Thank you to Emiliavi for making most of the beautiful art",
									shadow = false,
									scale = 0.4,
									colour = G.C.PURPLE
								}
							}
						}
					},
					{
						n = G.UIT.R,
						config = {
							padding = 0,
							align = "cm"
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Thank you to Emmakyu for helping with the code at certain points",
									shadow = false,
									scale = 0.4,
									colour = G.C.PURPLE
								}
							}
						}
					},
					{
						n = G.UIT.R,
						config = {
							padding = 0,
							align = "cm"
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Names above are based on BlueSky handle",
									shadow = false,
									scale = 0.3,
									colour = G.C.BLUE
								}
							}
						}
					},
					{
						n = G.UIT.R,
						config = {
							padding = 0,
							align = "cm"
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "Lastly, thanks to everyone playing and giving feedback on the mod.",
									shadow = false,
									scale = 0.4,
									colour = G.C.PURPLE
								}
							}
						}
					}
				}
			}
		end
	}
end

SMODS.Atlas {
	-- Key for code to find it with
	key = "MilatroMod",
	-- The name of the file, for the code to pull the atlas from
	path = "MilatroJokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "MilatroModDecks",
	-- The name of the file, for the code to pull the atlas from
	path = "MilatroDecks.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "MilatroBlinds",

	atlas_table = "ANIMATION_ATLAS",

	frames = 21,
	-- The name of the file, for the code to pull the atlas from
	path = "tempBlind.png",
	-- Width of each sprite in 1x size
	px = 34,
	-- Height of each sprite in 1x size
	py = 34
}

--This is so the game doesnt crash with Talisman and Loan Shark joker
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

get_suits_count = function(context)
	local suits = {
		["Hearts"] = 0,
		["Diamonds"] = 0,
		["Spades"] = 0,
		["Clubs"] = 0
	}
	for i = 1, #context.full_hand do
		if context.full_hand[i].ability.name ~= 'Wild Card' then
			if context.full_hand[i]:is_suit('Hearts', true) then
				suits["Hearts"] = suits["Hearts"] + 1
			elseif context.full_hand[i]:is_suit('Diamonds', true) then
				suits["Diamonds"] = suits["Diamonds"] + 1
			elseif context.full_hand[i]:is_suit('Spades', true) then
				suits["Spades"] = suits["Spades"] + 1
			elseif context.full_hand[i]:is_suit('Clubs', true) then
				suits["Clubs"] = suits["Clubs"] + 1
			end
		end
	end
	return suits
end

get_table_size = function(table)
	count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.butterfly_card = { enhancement =  get_bfly_name(G.P_CENTER_POOLS["Enhanced"][1])}
	ret.current_round.eye_rank = { id = 2, name = "2"}
	return ret
end

get_rank_id = function(id)
	if id <= 0 then return "Stone" end
	if id >= 2 and id <= 10 then return tostring(id) end
	if id == 11 then return "Jack" elseif id == 12 then return "Queen" elseif id == 13 then return "King" elseif id == 14 then return "Ace" end
	return "ERROR"
end

get_bfly_name = function(enhancement)
	-- normal case
	if string.find(enhancement.name, "Card") ~= nil and string.find(enhancement.name, "_") == nil then
		return enhancement.name
	end
	-- bonus/mult case
	if string.find(enhancement.name, "Card") == nil and string.find(enhancement.name, "_") == nil then
		return enhancement.name .. " Card"
	end
	-- modded case
	if string.find(enhancement.name, "Card") == nil and string.find(enhancement.name, "_") ~= nil then
		local i = string.find(enhancement.name, "_", 3)
		local len = string.len(enhancement.name)
		local real_enhancement_name = string.sub(enhancement.name, i+1, len)
		real_enhancement_name = string.upper(string.sub(real_enhancement_name, 1, 1)) .. string.sub(real_enhancement_name, 2, string.len(real_enhancement_name))
		return real_enhancement_name .. " Card"
	end
	return "ERROR"
end

function SMODS.current_mod.reset_game_globals(run_start)
	local valid_bfly = {}
	for i = 1, get_table_size(G.P_CENTER_POOLS["Enhanced"]) do
		if G.P_CENTER_POOLS["Enhanced"][i].name ~= "Wild Card" then 
			--update this if i can find a way to easily return enhancement in one line, but since i cant (yet) i need to add specific mod capability
			if string.find(G.P_CENTER_POOLS["Enhanced"][i].name, "mlnc") ~= nil or string.find(G.P_CENTER_POOLS["Enhanced"][i].name, "_", 3) == nil then
				valid_bfly[#valid_bfly+1] = G.P_CENTER_POOLS["Enhanced"][i]
			end
		end
	end
	G.GAME.current_round.butterfly_card.enhancement =  get_bfly_name(pseudorandom_element(valid_bfly, pseudoseed("butterfly")))

	local valid_eye = {}
    for i = 2, 14 do
        if i ~= G.GAME.current_round.eye_rank.id then valid_eye[#valid_eye + 1] = i end
    end
    local eye_card = pseudorandom_element(valid_eye, pseudoseed('eye'..G.GAME.round_resets.ante))
    G.GAME.current_round.eye_rank.id = eye_card
	sendTraceMessage(tostring(eye_card), 'milatro')
	G.GAME.current_round.eye_rank.name = get_rank_id(eye_card)
end