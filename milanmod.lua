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

-- Humble Joker
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

-- Circle Joker
SMODS.Joker{
	key = 'circle_joker',

	loc_txt = {
		name = 'Circle Joker',
		text = {
			"If hand contains 1 card",
			"this joker gains {C:mult}#2# {}Mult",
			"and {C:chips}#4# {}chips",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult & {C:chips}+#3# {C:inactive}Chips)"
		}
	},

	config = { extra = {mult = 0, mult_gain = 3, chips = 0, chip_gain = 14 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 1, y = 0},
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,



	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				chip_mod = card.ability.extra.chips,
				--TODO: currently only says +mult, add definition to dictionary for both mult and chips so it prints that correctly
				message = localize{type='variable', key='a_mult', vars = {card.ability.extra.mult} } 
			}
		end
		if context.before and #context.full_hand == 1 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain -- maybe change to self.extra? spare trousers does it like that
			return {
				message = 'Upgrade!',
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'spectral_teller',
	loc_txt = {
		name = 'Spectral Teller',
		text = {
			"Gains {C:white,X:mult}X#1#{} Mult per",
			"unique Spectral card used this run",
			"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
		}
	},

	config = { extra = { Xmult_gain = 0.5, Xmult = 1}},


	loc_vars = function(self, info_queue, card)
		local spectral_used = 0
		for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectral_used = spectral_used + 1 end end
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain   } }
	end,

	rarity = 3,
	atlas = 'MilanMod',
	pos = {x = 2, y = 0},
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local spectral_used = 0
			for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectral_used = spectral_used + 1 end end
			return {
				Xmult_mod = card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain,
				message = localize{type='variable', key='a_xmult', vars = {card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain} }
			}
		end
	end
}