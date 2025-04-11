SMODS.Atlas {
	-- Key for code to find it with
	key = "MilanMod",
	-- The name of the file, for the code to pull the atlas from
	path = "MilanJokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Joker{
    key = 'humble_joker',

	loc_txt = {
		name = 'Humble Joker',
		text = {
			"{C:white,X:mult} X#1# {} Mult"
		}
	},

	config = { extra = { Xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize{type='variable', key='a_xmult', vars = {card.ability.extra.Xmult} }
			}
		end
	end
}

