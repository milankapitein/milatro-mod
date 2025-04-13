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
SMODS.Joker {
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
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
			}
		end
	end
}

-- Circle Joker
SMODS.Joker {
	key = 'circle_joker',

	loc_txt = {
		name = 'Circle Joker',
		text = {
			"If hand contains {C:attention}1 {}card",
			"this joker gains {C:mult}+#2# {}Mult",
			"and {C:chips}+#4# {}Chips",
			"{C:inactive}(Currently {C:mult}+#1# {C:inactive}Mult & {C:chips}+#3# {C:inactive}Chips)"
		}
	},

	config = { extra = { mult = 0, mult_gain = 3, chips = 0, chip_gain = 14 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,

	rarity = 3,
	atlas = 'MilanMod',
	pos = { x = 1, y = 0 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,



	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				chip_mod = card.ability.extra.chips,
				--TODO: currently only says +mult, add definition to dictionary for both mult and chips so it prints that correctly
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
		if context.before and #context.full_hand == 1 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			card.ability.extra.mult = card.ability.extra.mult +
				card.ability.extra
				.mult_gain -- maybe change to self.extra? spare trousers does it like that
			return {
				message = 'Upgrade!',
				card = card
			}
		end
	end
}

-- Bad Omen
SMODS.Joker {
	key = 'bad_omen',
	loc_txt = {
		name = 'Bad Omen',
		text = {
			"Gains {C:white,X:mult}X#1#{} Mult per",
			"unique {C:spectral}Spectral {}card used this run",
			"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
		}
	},

	config = { extra = { Xmult_gain = 0.5, Xmult = 1 } },


	loc_vars = function(self, info_queue, card)
		local spectral_used = 0
		for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectral_used = spectral_used + 1 end end
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain } }
	end,

	rarity = 3,
	atlas = 'MilanMod',
	pos = { x = 2, y = 0 },
	cost = 9,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local spectral_used = 0
			for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectral_used = spectral_used + 1 end end
			return {
				Xmult_mod = card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain } }
			}
		end
	end
}

-- Red Joker
SMODS.Joker {
	key = 'red_joker',

	loc_txt = {
		name = 'Red Joker',
		text = {
			"Gains {C:chips}+#1# {}Chips per {C:attention}discard{}.",
			"{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)"
		}
	},

	config = { extra = { chips_gain = 15, chips = 0 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 3, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
		if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
			return {
				message = '+15 chips',
				colour = G.C.CHIPS,
				card = card
			}
		end
	end
}

-- Rigged Wheel
local base_poll_edition = poll_edition
function poll_edition(key, mod, no_neg, guaranteed)
	if (next(SMODS.find_card('j_mlnc_rigged_wheel'))) then
		mod = mod or 1 --basically the code of the poll_edition function but i changed one number
		local edition_poll = pseudorandom(pseudoseed(key or 'edition_generic'))
		local tempval = pseudorandom(pseudoseed(key or 'edition_generic'), 1, 4)
		if guaranteed and edition_poll > 1 - 0.01725 * 100 then
			if tempval == 1 then
				return { negative = true }
			elseif tempval == 2 then
				return { polychrome = true }
			elseif tempval == 3 then
				return { holo = true }
			elseif tempval == 4 then
				return { foil = true }
			end
		elseif edition_poll > 1 - 0.01725 * G.GAME.edition_rate * mod then
			if tempval == 1 then
				return { negative = true }
			elseif tempval == 2 then
				return { polychrome = true }
			elseif tempval == 3 then
				return { holo = true }
			elseif tempval == 4 then
				return { foil = true }
			end
		end
	else
		return base_poll_edition(key, mod, no_neg, guaranteed)
	end
end

SMODS.Joker {
	key = 'rigged_wheel',

	loc_txt = {
		name = 'Rigged Wheel',
		text = {
			"All chances for {C:enhanced}Editions {}are",
			"equally likely, including {C:dark_edition}Negative{}."
		}
	},

	config = { extra = {} },

	loc_vars = function(self, info_queue, card)
		-- This is the way to add an info_queue, which is extra information about other cards
		-- like Stone Cards on Marble/Stone Jokers, Steel Cards on Steel Joker, and
		-- in this case, information about negative editions on Perkeo.
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 4, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = false
}

-- Brick by brick
SMODS.Joker {
	key = 'brick_by_brick',

	loc_txt = {
		name = 'Brick by Brick',
		text = {
			"This Joker gains {C:mult}+#1# {}Mult",
			"for each scoring {C:attention}Stone {}card.",
			"{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)"
		}
	},

	config = { extra = { mult_gain = 3, mult = 0 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 5, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
		if context.individual and context.cardarea == G.play and context.other_card:get_id() < 0 and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = '+3 Mult',
				colour = G.C.Mult,
				card = card
			}
		end
	end
}

-- Miner
SMODS.Joker {
	key = 'miner',

	loc_txt = {
		name = 'Miner',
		text = {
			"Retriggers all played {C:attention}Stone {}cards"
		}
	},

	config = { extra = { repetitions = 1 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions + 1 } }
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 6, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() < 0 then
				return {
					message = localize('k_again_ex'),
					-- repetitions = card.ability.extra.repetitions,
					-- card = context.other_card
					repetitions = card.ability.extra.repetitions,
					card = context.self
				}
			end
		end
	end
}


-- Colorblindness
-- inspired by https://github.com/TheOneGoofAli/TOGAPackBalatro/blob/20a4d9d2d930cb22daa22c01930aaafb67656daf/togastuff.lua#L211-L242
local original_card_is_suit = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
	if flush_calc then
		if next(SMODS.find_card('j_mlnc_colorblindness')) and (self.base.suit == 'Clubs' or self.base.suit == 'Diamonds') == (suit == 'Clubs' or suit == 'Diamonds') then
			return true
		end
		if next(SMODS.find_card('j_mlnc_colorblindness')) and next(SMODS.find_card('j_smeared')) then
			return true
		end
		return original_card_is_suit(self, suit, bypass_debuff, flush_calc)
	else
		if self.debuff and not bypass_debuff then return end
		if next(SMODS.find_card('j_mlnc_colorblindness')) and (self.base.suit == 'Clubs' or self.base.suit == 'Diamonds') == (suit == 'Clubs' or suit == 'Diamonds') then
			return true
		end
		if next(SMODS.find_card('j_mlnc_colorblindness')) and next(SMODS.find_card('j_smeared')) then
			return true
		end
		return original_card_is_suit(self, suit, bypass_debuff, flush_calc)
	end
end

SMODS.Joker {
	key = 'colorblindness',

	loc_txt = {
		name = 'Colorblindness',
		text = {
			"{V:3}Clubs{} and {V:4}Diamonds{} count",
			"as the same suit."
		}
	},

	config = { extra = {} },

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				"Spade",
				"Heart",
				"Club",
				"Diamond",
				colours = {
					G.C.SUITS.Spades,
					G.C.SUITS.Hearts,
					G.C.SUITS.Clubs,
					G.C.SUITS.Diamonds
				}
			}
		}
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 7, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = false
}

-- Wild West
SMODS.Joker {
	key = 'wild_west',
	loc_txt = {
		name = 'Wild West',
		text = {
			"{C:mult}+#1# {}Mult for scoring {C:attention}Wild {}card",
			"in the leftmost position."
		}
	},

	config = { extra = { mult = 30 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,

	rarity = 1,
	atlas = 'MilanMod',
	cost = 5,
	pos = { x = 8, y = 0 },

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card == context.full_hand[1] and context.other_card.ability.name == "Wild Card" then
				return {
					-- TODO: fix the position of text, blueprint says it at the joker, but wild west at the card
					mult = card.ability.extra.mult,
					card = context.other_card,
					message = "YEEE-HAW!"
				}
			end
		end
	end
}

-- Fire Tornado
SMODS.Joker {
	key = 'fire_tornado',

	loc_txt = {
		name = 'Fire Tornado',
		text = {
			"{C:mult}+#1# {}Mult if played hand only",
			"contains {V:2}Hearts {}and {V:4}Diamonds{}."
		}
	},

	config = { extra = { mult = 20 } },

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				"Spade",
				"Heart",
				"Club",
				"Diamond",
				colours = {
					G.C.SUITS.Spades,
					G.C.SUITS.Hearts,
					G.C.SUITS.Clubs,
					G.C.SUITS.Diamonds
				}
			}
		}
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 9, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
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
			if suits["Clubs"] <= 0 and suits["Spades"] <= 0 then
				return {
					mult = card.ability.extra.mult,
				}
			end
		end
	end

}

-- Symmetry Joker
SMODS.Joker {
	key = 'symmertry_joker',

	loc_txt = {
		name = 'Symmetry Joker',
		text = {
			"{C:attention}Retrigger {}all scoring {C:attention} 8s{},",
			"{C:attention}6s {}, {C:attention}9s {}and {C:attention}Aces {}"
		}
	},

	config = { extra = { repetitions = 1 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions + 1 } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 0, y = 1 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 6 or context.other_card:get_id() == 8 or context.other_card:get_id() == 9 or context.other_card:get_id() == 14 then
				return {
					message = localize('k_again_ex'),
					repetitions = card.ability.extra.repetitions,
					card = context.self
				}
			end
		end
	end
}

-- Hole in One
SMODS.Joker {
	key = 'hole_in_one',

	loc_txt = {
		name = 'Hole in One',
		text = {
			"If {C:attention}first {} of round contains",
			"a scoring {C:attention}Ace {}, earn {C:money}$#1#{}."
		}
	},

	config = { extra = { dollar = 5 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollar } }
	end,

	rarity = 1,
	atlas = 'MilanMod',
	pos = { x = 1, y = 1 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.current_round.hands_played == 0 then
				for i = 1, #context.full_hand do
					if context.full_hand[i]:get_id() == 14 then
						G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollar
						G.E_MANAGER:add_event(Event({
							func = (function()
								G.GAME.dollar_buffer = 0; return true
							end)
						}))
						return {
							dollars = card.ability.extra.dollar,
							colour = G.C.MONEY
						}
					end
				end
			end
		end
	end
}

-- Slot Machine
SMODS.Joker {
	key = 'slot_machine',

	loc_txt = {
		name = 'Slot Machine',
		text = {
			"If hand contains 3 {C:attention} 7s{},",
			"create {C:attention}3 {C:dark_edition}Negative {}Consumables."
		}
	},

	loc_vars = function(self, ifno_queue, card)
	end,

	rarity = 3,
	atlas = 'MilanMod',
	pos = { x = 2, y = 1 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local seven_count = 0
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i]:get_id() == 7 then
					seven_count = seven_count + 1
				end
			end
			if seven_count >= 3 then
				G.E_MANAGER:add_event(Event({
					func = function()
						for i = 1, 3 do
							local card
							local typeConsumable = pseudorandom(pseudoseed('slot_machine'), 1, 3)
							if (typeConsumable == 1) then
								card = create_card('Tarot', G.consumables, nil, nil, nil, true)
							end
							if (typeConsumable == 2) then
								card = create_card('Planet', G.consumables, nil, nil, nil, true)
							end
							if (typeConsumable == 3) then
								card = create_card('Spectral', G.consumables, nil, nil, nil, true)
							end
							card:set_edition('e_negative', true)
							card:add_to_deck()
							G.consumeables:emplace(card)
						end
						return true
					end
				}))
				return {
					message = "JACKPOT!"
				}
			end
		end
	end
}

-- The Deal
SMODS.Joker {
	key = 'the_deal',

	loc_txt = {
		name = 'The Deal',
		text = {
			"Go down to {C:blue}#1#{} Hand, gain {C:red}+#2# {}Discards."
		}
	},

	config = { extra = { hands = 1, discards = 5 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands, card.ability.extra.discards } }
	end,

	rarity = 2,
	atlas = 'MilanMod',
	pos = { x = 3, y = 1 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.setting_blind then
			G.E_MANAGER:add_event(Event({
				func = function()
					-- TODO: make ease_discard show each instance of adding mult or total when multiple copies
					ease_discard(card.ability.extra.discards)
					if G.GAME.current_round.hands_left > 1 then
						local hand_UI = G.HUD:get_UIE_by_ID('hand_UI_count')
						local col = G.C.RED
						local diff = (-G.GAME.current_round.hands_left + 1)
						G.GAME.current_round.hands_left = 1
						hand_UI.config.object:update()
						G.HUD:recalculate()
						
						attention_text({
							text = tostring(diff),
							scale = 0.8,
							hold = 0.7,
							cover = hand_UI.parent,
							cover_colour = col,
							align = 'cm',
						})
						play_sound('chips2')
					else
						return true
					end
					return true
				end
			}))
		end
	end

}