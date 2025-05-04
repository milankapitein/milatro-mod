SMODS.load_file("src/jokers.lua")()
SMODS.load_file("src/decks.lua")()
SMODS.load_file("src/vouchers.lua")()
SMODS.load_file("src/blinds.lua")()
SMODS.load_file("src/consumables.lua")()
SMODS.load_file("src/misc.lua")()


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

local enhancements_list = {
	"Lucky Card",
	"Glass Card",
	"Mult Card",
	"Bonus Card",
	"Stone Card",
	"Steel Card",
	"Gold Card"
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.butterfly_card = { enhancement = enhancements_list[1]}
	ret.current_round.eye_rank = { id = 2, name = "2"}
	return ret
end

get_rank_id = function(id)
	if id <= 0 then return "Stone" end
	if id > 2 and id <= 10 then return tostring(id) end
	if id == 11 then return "Jack" elseif id == 12 then return "Queen" elseif id == 13 then return "King" elseif id == 14 then return "Ace" end
	return "ERROR"
end

function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.butterfly_card = { enhancement = enhancements_list[1] }
	local butterfly_card = pseudorandom("butterfly", 1, #enhancements_list)
	G.GAME.current_round.butterfly_card.enhancement = enhancements_list[butterfly_card]

	local valid_eye = {}
    for i = 2, 14 do
        if i ~= G.GAME.current_round.eye_rank.id then valid_eye[#valid_eye + 1] = i end
    end
    local eye_card = pseudorandom_element(valid_eye, pseudoseed('eye'..G.GAME.round_resets.ante))
    G.GAME.current_round.eye_rank.id = eye_card
	G.GAME.current_round.eye_rank.name = get_rank_id(eye_card)
end