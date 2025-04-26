SMODS.load_file("src/jokers.lua")()
SMODS.load_file("src/decks.lua")()
SMODS.load_file("src/vouchers.lua")()

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
