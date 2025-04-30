SMODS.load_file("src/jokers.lua")()
SMODS.load_file("src/decks.lua")()
SMODS.load_file("src/vouchers.lua")()
SMODS.load_file("src/blinds.lua")()


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
		['Hearts'] = 0,
		['Diamonds'] = 0,
		['Spades'] = 0,
		['Clubs'] = 0
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