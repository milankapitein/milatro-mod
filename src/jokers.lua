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

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult,
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
			"If hand contains exactly {C:attention}1 {}card",
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
	atlas = 'MilatroMod',
	pos = { x = 1, y = 0 },
	cost = 9,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
				chips = card.ability.extra.chips,
				card = card
			}
		end
		if context.before and #context.full_hand == 1 and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			card.ability.extra.mult = card.ability.extra.mult +
				card.ability.extra.mult_gain
			return {
				message = localize('k_upgrade_ex'),
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
	atlas = 'MilatroMod',
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
				Xmult = card.ability.extra.Xmult + spectral_used * card.ability.extra.Xmult_gain,
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
			"Gains {C:chips}+#1# {}Chips per {C:attention}discard{}",
			"{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)"
		}
	},

	config = { extra = { chips_gain = 4, chips = 0 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 3, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
		if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
			return {
				message = localize('k_upgrade_ex'),
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
			"equally likely, including {C:dark_edition}Negative{}"
		}
	},

	config = { extra = {} },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 4, y = 0 },
	cost = 9,

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
			"for each scoring {C:attention}Stone {}card",
			"{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)"
		}
	},

	config = { extra = { mult_gain = 3, mult = 0 } },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 5, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
		if context.individual and context.cardarea == G.play and context.other_card:get_id() < 0 and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
			return {
				message = localize('k_upgrade_ex'),
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
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return { vars = { card.ability.extra.repetitions + 1 } }
	end,

	rarity = 1,
	atlas = 'MilatroMod',
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
					repetitions = card.ability.extra.repetitions,
					card = context.self
				}
			end
		end
	end
}

-- Colorblindness
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
			"as the same suit"
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

	rarity = 1,
	atlas = 'MilatroMod',
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
			"in the leftmost position"
		}
	},

	config = { extra = { mult = 30 } },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild
		return { vars = { card.ability.extra.mult } }
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	cost = 5,
	pos = { x = 8, y = 0 },

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card == context.full_hand[1] and context.other_card.config.center.key == "m_wild" then
				return {
					mult = card.ability.extra.mult,
					card = card,
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
			"contains {V:2}Hearts {}and {V:4}Diamonds{}"
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
	atlas = 'MilatroMod',
	pos = { x = 9, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local suits = get_suits_count(context)
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
			"Retrigger all scoring {C:attention}8s{},",
			"{C:attention}6s{}, {C:attention}9s {}and {C:attention}Aces {}"
		}
	},

	config = { extra = { repetitions = 1 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions + 1 } }
	end,

	rarity = 2,
	atlas = 'MilatroMod',
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
			"If {C:attention}first hand{} of round contains",
			"a scoring {C:attention}Ace{}, earn {C:money}$#1#{}"
		}
	},

	config = { extra = { dollar = 5 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollar } }
	end,

	rarity = 1,
	atlas = 'MilatroMod',
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
			"If hand contains #1# {C:attention}7s{},",
			"create {C:attention}#2# {C:dark_edition}Negative {}Consumables"
		}
	},

	config = { extra = {seven_count = 3, consumables = 3}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return { vars = {card.ability.extra.seven_count, card.ability.extra.consumables}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 2, y = 1 },
	cost = 8,

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
			if seven_count >= card.ability.extra.seven_count then
				G.E_MANAGER:add_event(Event({
					func = function()
						for i = 1, card.ability.extra.consumables do
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
			"Go down to {C:blue}#1#{} Hand, gain {C:red}+#2# {}Discards"
		}
	},

	config = { extra = { hands = 1, discards = 5 } },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands, card.ability.extra.discards } }
	end,

	rarity = 2,
	atlas = 'MilatroMod',
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
					ease_discard(card.ability.extra.discards, false, true)
					if G.GAME.current_round.hands_left > 1 then
						local hand_UI = G.HUD:get_UIE_by_ID('hand_UI_count')
						local col = G.C.RED
						local diff = (-G.GAME.current_round.hands_left + 1)
						G.GAME.current_round.hands_left = 1
						hand_UI.config.object:update()
						attention_text({
							text = tostring(diff),
							scale = 0.8,
							hold = 0.7,
							cover = hand_UI.parent,
							cover_colour = col,
							align = 'cm',
						})
					end
					play_sound('chips2')
					G.HUD:recalculate()
					return true
				end
			}))
			return {
				message = "+5 Discards"
			}
		end
	end

}

-- Loan Shark
SMODS.Joker{
	key = 'loan_shark',

	loc_txt = {
		name = 'Loan Shark',
		text = {
			"This Joker gains {C:white,X:mult}X#1# {} Mult for",
			"each {C:money}$1{} below {C:money}0{}",
			"Go up to {C:red}-$#2#{} in debt",
			"{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
		}
	},

	config = { extra = { Xmult_gain = 0.5, debt = 5, Xmult = 1}},

	loc_vars = function(self, info_queue, card)
		if to_number(G.GAME.dollars) < to_number(0) then
			return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.debt, card.ability.extra.Xmult + math.abs(G.GAME.dollars) * card.ability.extra.Xmult_gain }}
		else
			return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.debt, card.ability.extra.Xmult }}
		end
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 4, y = 1 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	add_to_deck = function(self, card, from_debuff)
		G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local mult = 0
			if to_number(G.GAME.dollars) < to_number(0) then
				mult = card.ability.extra.Xmult + math.abs(to_number(G.GAME.dollars)) * card.ability.extra.Xmult_gain
			else
				mult = card.ability.extra.Xmult
			end
			return {
				Xmult = mult
			}
		end
	end
}

-- The Reaper
SMODS.Joker{
	key = 'the_reaper',

	loc_txt = {
		name = 'The Reaper',
		text = {
			"If the {C:attention}winning hand{} of round contains",
			"a {C:attention}Pair{}, {C:green,E:1}#1# in #2#{} chance",
			"to create a {C:tarot}Death Tarot{} card"
		}
	},

	config = {extra = {min = 1, odds = 2, last_hand = 0} },

	loc_vars = function(self, info_queue, card)
		card.ability.extra.min = (G.GAME and G.GAME.probabilities.normal or 1)
		info_queue[#info_queue+1] = G.P_CENTERS.c_death
		return { vars = {card.ability.extra.min, card.ability.extra.odds}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 5, y = 1 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.before then
			G.GAME.consumeable_buffer = #G.consumeables.cards
			card.ability.extra.last_hand = next(context.poker_hands['Pair'])
		end
		if context.end_of_round and not context.individual and not context.repetition and card.ability.extra.last_hand == 1 and G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not card.debuff then
			if pseudorandom('reaper') < G.GAME.probabilities.normal/card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_death')
						card:add_to_deck()
						G.consumeables:emplace(card)
						return true
					end
				}))
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				return{
					message = 'Death comes...'
				}
			else
				return{
					message = 'Death waits...'
				}
			end
		end
	end
}

-- Black Kitten
SMODS.Joker{
	key = 'black_kitten',

	loc_txt = {
		name = 'Black Kitten',
		text = {
			"This Joker gains {C:white,X:mult}X#1# {} Mult if a {C:attention}Lucky {}card",
			"{C:red}unsuccesfully {}triggers, loses {C:white,X:mult}X#2# {} Mult",
			"for a {C:green}succesful {}trigger",
			"{C:inactive}(Currently {C:white,X:mult}X#3# {C:inactive} Mult)"
		}
	},

	config = { extra = { Xmult_gain = 0.1, Xmult_loss = 0.1, Xmult = 1}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
		return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult_loss, card.ability.extra.Xmult}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 6, y = 1 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.extra.Xmult <= 1 then return end
			return {
				Xmult = card.ability.extra.Xmult,
			}
		end
		if context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card.ability.name == 'Lucky Card' and not context.other_card.lucky_trigger then
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
				return {
					message = '+X0.1',
					colour = G.C.Mult,
					card = card
				}
			end
			if context.other_card.lucky_trigger then
				if (card.ability.extra.Xmult < 1.1) then
					card.ability.extra.Xmult = 1
					return { 
						card = card
					}
				end
				card.ability.extra.Xmult = (card.ability.extra.Xmult - card.ability.extra.Xmult_loss) or 1
				return {
					message = '-X0.1',
					colour = G.C.Mult,
					card = card
				}
			end
		end
	end
}

-- Lumberjack
SMODS.Joker{
	key = 'lumberjack',

	loc_txt = {
		name = 'Lumberjack',
		text = {
			"Sell this Joker to remove",
			"all {C:attention}3s {}from full deck",
			"Earn {C:money}$#2# {}for each {C:attention}3 {}destroyed",
			"{C:inactive}(Currently {C:attention}#1# {C:inactive}cards to remove)"
		}
	},

	config = { extra = { three_count = 0, dollars = 1}},

	loc_vars = function(self, info_queue, card)
		card.ability.extra.three_count = 0
		if G.STAGE == G.STAGES.RUN then
			for k, v in pairs(G.playing_cards) do
				if v:get_id() == 3 then
					card.ability.extra.three_count = card.ability.extra.three_count + 1
				end
			end
		end
		return { vars = { card.ability.extra.three_count, card.ability.extra.dollars }}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 7, y = 1 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,

	calculate = function(self, card, context)
		if context.selling_self then
			local destroyed_cards = {}
			for k, v in pairs(G.playing_cards) do
                if v:get_id() == 3 then 
					destroyed_cards[#destroyed_cards+1] = v
				end
			end
			local no_destroyed_cards = #destroyed_cards
			for i = 1, #destroyed_cards do
				destroyed_cards[i]:remove()
			end
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars * no_destroyed_cards
			G.E_MANAGER:add_event(Event({
				func = (function()
					G.GAME.dollar_buffer = 0; return true
				end)
			}))
			return {
				dollars = card.ability.extra.dollars * no_destroyed_cards,
				colour = G.C.MONEY
			}
		end
	end
}

-- Clown Fiesta
SMODS.Joker{
	key = 'clown_fiesta',

	loc_txt = {
		name = 'Clown Fiesta',
		text = {
			"Sell this Joker to create {C:attention}#1#{}",
			"free {C:attention}Juggle Tags{}"
		}
	},

	config = { extra = {tags = 2} },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_TAGS.tag_juggle
		return { vars = {card.ability.extra.tags }}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 8, y = 1 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,

	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, card.ability.extra.tags do
				G.E_MANAGER:add_event(Event({
					func = (function()
						add_tag(Tag('tag_juggle'))
						play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
						play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
						return true
					end)
				}))	
			end
		end
	end
}

-- Force of Nature
SMODS.Joker{
	key = 'force_of_nature',

	loc_txt = {
		name = 'Force of Nature',
		text = {
			"Gains {C:white,X:mult}X#1#{} Mult for every",
			"{C:attention}Wild 4 {}in your {C:attention}full deck{}",
			"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
		}
	},

	config = { extra = { Xmult_gain = 1, Xmult = 1}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild
		card.ability.extra.Xmult = 1
		if G.STAGE == G.STAGES.RUN then
			for k, v in pairs(G.playing_cards) do
				if v:get_id() == 4 and v.ability.name == "Wild Card" then
					card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
				end
			end
		end
		return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 9, y = 1 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			for k, v in pairs(G.playing_cards) do
				if v:get_id() == 4 and v.ability.name == "Wild Card" then
					card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
				end
			end
			return {
				Xmult = card.ability.extra.Xmult
			}
		end
	end
}

-- Multitasking
SMODS.Joker{
	key = 'multitasking',

	loc_txt = {
		name = 'Multitasking',
		text = {
			"{C:mult}+#1# {}Mult on {C:attention}even{} hands",
			"{C:chips}+#2# {}Chips on {C:attention}odd{} hands",
			"{C:gold}$#3#{} on {C:attention}final{} hand of round"
		}
	},

	config = {extra = {mult = 5, chips = 60, dollars = 2}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.dollars}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 2 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local round_hand_played_on = G.GAME.current_round.hands_left + 1
			if round_hand_played_on == 1 then
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
			G.E_MANAGER:add_event(Event({
				func = (function()
					G.GAME.dollar_buffer = 0; return true
				end)
			}))
			return {
				dollars = card.ability.extra.dollars,
				colour = G.C.MONEY
			}
			elseif round_hand_played_on % 2 == 0 then
				return {
					mult = card.ability.extra.mult
				}
			else
				return {
					chips = card.ability.extra.chips
				}
			end
		end
	end
}

-- The Toilet
SMODS.Joker{
	key = 'the_toilet',

	loc_txt = {
		name = 'The Toilet',
		text = {
			"{C:green,E:1}#1# in #2#{} chance to upgrade level",
			"of {C:attention}poker hand {}containing {C:attention}Flush{}"
		}
	},

	config = { extra = { min = 1, odds = 2}},

	loc_vars = function(self, info_queue, card)
		card.ability.extra.min = (G.GAME and G.GAME.probabilities.normal or 1)
		return { vars = {card.ability.extra.min, card.ability.extra.odds}}
	end,
	
	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 1, y = 2 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before then
			if pseudorandom('toilet') < G.GAME.probabilities.normal/card.ability.extra.odds then
				local random_hand = pseudorandom('flush_hand', 1, 4)
				local flush_hand = ""
				if random_hand == 1 then flush_hand = G.handlist[1] elseif random_hand == 2 then flush_hand = G.handlist[2] elseif random_hand == 3 then flush_hand = G.handlist[4] else flush_hand = G.handlist[7] end
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(flush_hand, 'poker_hands'),chips = G.GAME.hands[flush_hand].chips, mult = G.GAME.hands[flush_hand].mult, level=G.GAME.hands[flush_hand].level})
				level_up_hand(context.blueprint_card or card, flush_hand, nil, 1)
				update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {handname=localize(context.scoring_name, 'poker_hands'),chips = G.GAME.hands[context.scoring_name].chips, mult = G.GAME.hands[context.scoring_name].mult, level=G.GAME.hands[context.scoring_name].level})
			end
		end
	end
}

-- Magic Hat
SMODS.Joker{
	key = 'magic_hat',

	loc_txt = {
		name = 'Magic Hat',
		text = {
			"Blue and purple {C:attention}seals {}",
			"can activate when played"
		}
	},

	loc_vars = function(self, info_queue)
		info_queue[#info_queue+1] = G.P_SEALS.Blue
		info_queue[#info_queue+1] = G.P_SEALS.Purple
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 2, y = 2 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	-- todo: fix granting items :)
	calculate = function(self, card, context)
		if context.before then
			G.GAME.consumeable_buffer = #G.consumeables.cards
		end
		if context.individual and context.cardarea == G.play and context.other_card.seal == 'Blue' and G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			local card_type = 'Planet'
			G.E_MANAGER:add_event(Event({
				func = (function()
					if G.GAME.last_hand_played then
						local _planet = 0
						for k, v in pairs(G.P_CENTER_POOLS.Planet) do
							if v.config.hand_type == G.GAME.last_hand_played then
								_planet = v.key
							end
						end
						local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
						card:add_to_deck()
						G.consumeables:emplace(card)
					end
					return true
				end)}))
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		elseif context.individual and context.cardarea == G.play and context.other_card.seal == 'Purple' and G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.E_MANAGER:add_event(Event({
                func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    return true
                end)}))
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		end
	end
}

-- Phalanx
function Card:set_debuff(should_debuff)
	if(next(SMODS.find_card('j_mlnc_phalanx'))) then
		local freq_ranks = {
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
			[13] = 0,
			[14] = 0,
		}
		for k, v in pairs(G.playing_cards) do
			if v:get_id() > 0 then
				freq_ranks[v:get_id()] = freq_ranks[v:get_id()] + 1
			end
		end
		local highestFreq = 14
		for i = 14, 2, -1 do
			if freq_ranks[i] > freq_ranks[highestFreq] then
				highestFreq = i
			end
		end
		if self:get_id() == highestFreq then
			self.debuff = false
			return
		end
	end

	-- code for original Card:set_debuff function. reference did not work so i copied it
	if self.ability.perishable and self.ability.perish_tally <= 0 then 
        if not self.debuff then
            self.debuff = true
            if self.area == G.jokers then self:remove_from_deck(true) end
        end
        return
    end
    if should_debuff ~= self.debuff then
        if self.area == G.jokers then if should_debuff then self:remove_from_deck(true) else self:add_to_deck(true) end end
        self.debuff = should_debuff
    end
end
SMODS.Joker{
	key = 'phalanx',

	loc_txt = {
		name = 'Phalanx',
		text = {
			"The {C:attention}card {}with highest frequency",
			"in your entire deck can",
			"no longer be {C:attention}debuffed{}"
		}
	},

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 3, y = 2 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,
}

-- Betrayal
SMODS.Joker{	
	key = 'betrayal',

	loc_txt = {
		name = 'Betrayal',
		text = {
			"When {C:attention}Blind {}is selected, earn",
			"{C:money}$#1# {}and {C:red}destroy {}a random Joker"
		}
	},

	config = { extra = { dollars = 20 }},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.dollars }}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 4, y = 2 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local destructable_jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
			end
			local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('betrayal')) or nil

			if joker_to_destroy and not (context.blueprint_card or self).getting_sliced then 
				joker_to_destroy.getting_sliced = true
				G.E_MANAGER:add_event(Event({func = function()
					joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
				return true end }))
			end
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
			G.E_MANAGER:add_event(Event({
				func = (function()
					G.GAME.dollar_buffer = 0; return true
				end)
			}))
			return {
				dollars = card.ability.extra.dollars,
				colour = G.C.MONEY
			}
		end
	end
}

-- The Landlords
SMODS.Joker{
	key = 'the_landlords',

	loc_txt = {
		name = 'The Landlords',
		text = {
			"{C:white,X:mult}X#1#{} Mult if played hand",
			"contains a {C:attention}Full House{}"
		}
	},

	config = { extra = {Xmult = 4}},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult }}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 5, y = 2 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands['Full House']) then
			return {
				Xmult = card.ability.extra.Xmult,
			}
		end
	end
}

-- Recursive Joker
SMODS.Joker{
	key = 'recursive_joker',

	loc_txt = {
		name = 'Recursive Joker',
		text = {
			"{C:mult}+#1# {}Mult per hand played",
			"{C:mult}-#2# {}Mult after defeating {C:attention}Boss Blind{}",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		}
	},

	config = { extra = { mult_gain = 4, mult_loss = 20, mult = 0}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult_loss, card.ability.extra.mult}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 7, y = 2 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
		if context.before and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
		end
		if context.end_of_round and G.GAME.blind.boss and not context.blueprint and context.main_eval then
			card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
			if card.ability.extra.mult < 0 then card.ability.extra.mult = 0 end
			return {
				message = "Falling..."
			}
		end
	end
}

-- Butterfly Effect
SMODS.current_mod.optional_features = { quantum_enhancements = true }

SMODS.Joker{
	key = 'butterfly_effect',

	loc_txt = {
		name = 'Butterfly Effect',
		text = {
			"{C:attention}Wild Cards{} have the ",
			"additional effect of {C:attention}#1#s{}",
			"Enhancement changes at ",
			"the end of each round"
		}
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild
		return { vars = {G.GAME.current_round.butterfly_card.enhancement}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 8, y = 2 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	calculate = function(self, card, context)
		if context.check_enhancement then
			if context.other_card.ability.name == "Wild Card" then
				if G.GAME.current_round.butterfly_card.enhancement == "Lucky Card" then
					return {
						m_lucky = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Glass Card" then
					return {
						m_glass = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Mult Card" then
					return {
						m_mult = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Bonus Card" then
					return {
						m_bonus = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Stone Card" then
					return {
						m_stone = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Steel Card" then
					return {
						m_steel = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Gold Card" then
					return {
						m_gold = true
					}
				elseif G.GAME.current_round.butterfly_card.enhancement == "Ice Card" then
					return {
						m_mlnc_ice = true
					}
				end
			end
		end
	end
}

-- How Hungry
SMODS.Joker{
	key = 'how_hungry',

	loc_txt = {
		name = 'How Hungry',
		text = {
			"If hand contains both a",
			"scoring {C:attention}7 {}and {C:attention}9{},",
			"destroy {C:attention}all {}scoring {C:attention}9{} and earn {C:money}$#1#{}"
		}
	},

	config = { extra = {dollars = 6, contains7 = false, to_destroy = {}, money_granted = false}},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 9, y = 2 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			card.ability.extra.to_destroy = {}
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i]:get_id() == 7 then
					card.ability.extra.contains7 = true
				end
			end
		end

		if context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card:get_id() == 9 and card.ability.extra.contains7 then
				if not contains(card.ability.extra.to_destroy, context.other_card) then
					card.ability.extra.to_destroy[#card.ability.extra.to_destroy + 1] = context.other_card
				end
			end
		end

		if context.destroying_card and not context.blueprint then
			if not card.ability.extra.money_granted and contains(card.ability.extra.to_destroy, context.destroying_card) then
				card.ability.extra.money_granted = true
				ease_dollars(card.ability.extra.dollars)
			end
			return contains(card.ability.extra.to_destroy, context.destroying_card)
		end

		if context.after and not context.blueprint then
			card.ability.extra.to_destroy = nil
			card.ability.extra.money_granted = false
		end
	end
}

-- Toast
SMODS.Joker{
	key = 'toast',

	-- its -50 just so that in collection it doesnt display as the holy toast
	config = {extra = { Xmult = 5, actual_rounds = 0, count = -50}},

	loc_vars = function(self, info_queue, card)
		if card.ability.extra.count == card.ability.extra.actual_rounds then
			return {
				vars = {card.ability.extra.Xmult},
				key = self.key .. '_alt',
			}
		else
			return {
				vars = {},
				key = self.key,
			}
		end
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 6, y = 2 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	add_to_deck = function(self, card, from_debuff)
		if card.ability.extra.actual_rounds == 0 then
			card.ability.extra.actual_rounds = pseudorandom("toast", 3, 6)
			card.ability.extra.count = 0
		end
	end,

	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.count == card.ability.extra.actual_rounds then
			return {
				Xmult = card.ability.extra.Xmult
			}
		end
		if context.end_of_round and context.main_eval and card.ability.extra.count < card.ability.extra.actual_rounds and not context.blueprint then
			card.ability.extra.count = card.ability.extra.count + 1
			if card.ability.extra.count == card.ability.extra.actual_rounds then
				return {
					message = "Blessed!"
				}
			end
		end
	end
}

-- Impending Doom
local hook_new_boss = get_new_boss
function get_new_boss()
	if (next(SMODS.find_card('j_mlnc_impending_doom'))) and (G.GAME.round_resets.ante % 8) ~= 0 then 
		for k,v in pairs(G.P_BLINDS) do
			if G.P_BLINDS[k].name == "bl_mlnc_the_cover" then
				return k
			end
		end
	 end
    return hook_new_boss()
end
SMODS.Joker{
	key = 'impending_doom',

	loc_txt = {
		name = 'Impending Doom',
		text = {
			"{C:white,X:mult}X#1#{} Mult,",
			"All non-finisher boss blinds ",
			"are {C:attention}the Cover"
		}
	},

	config = {extra = {Xmult = 3}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_BLINDS.bl_mlnc_the_cover
		return { vars = { card.ability.extra.Xmult } }
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	perishable_compat = false, 

	add_to_deck = function(self, card, from_debuff)
		get_new_boss()
		G.from_boss_tag = true
		G.FUNCS.reroll_boss()
	end,

	remove_from_deck = function(self, card, from_debuff)
		get_new_boss()
		G.from_boss_tag = true
		G.FUNCS.reroll_boss()
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult = card.ability.extra.Xmult,
			}
		end
		if context.end_of_round and context.main_eval and card.ability.extra.count < card.ability.extra.actual_rounds and not context.blueprint then
			card.ability.extra.count = card.ability.extra.count + 1
			if card.ability.extra.count == card.ability.extra.actual_rounds then
				return {
					message = "Blessed!"
				}
			end
		end
	end
}

--Bluffing
SMODS.Joker{
	key = 'bluffing',

	loc_txt = {
		name = 'Bluffing',
		text = {
			"Played hand is considered",
			"the hand above it",
			"{C:inactive}(Ex: Flush -> Full House){}"
		}
	},

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 9,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and not context.blueprint then
			for i = 1, #G.handlist do
				if context.scoring_name == G.handlist[i] then
					local new_hand = G.handlist[i - 1]
					return {
						mult_mod = G.GAME.hands[new_hand].mult - G.GAME.hands[G.handlist[i]].mult,
						chip_mod = G.GAME.hands[new_hand].chips - G.GAME.hands[G.handlist[i]].chips,
						message = "Bluffed"
					}
				end
			end
		end
	end
}

--You're The Joker
SMODS.Joker{
	key = 'youre_the_joker',

	loc_txt = {
		name = 'You\'re the Joker',
		text = {
			"Selling any item has a",
			"{C:green}#1# in #2#{} odds to",
			"create a {C:tarot}Fool{}"
		}
	},

	config = { extra = { base = 1, odds = 3, lock = false}},

	loc_vars = function(self, info_queue, card)
		card.ability.extra.base = (G.GAME and G.GAME.probabilities.normal or 1)
		info_queue[#info_queue+1] = G.P_CENTERS.c_fool
		return { vars = {card.ability.extra.base, card.ability.extra.odds}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.selling_self then
			card.ability.extra.lock = true -- jank solution cause adding not context.selling_self to the other if statement still made it make a fool????
		end
		if context.selling_card and not card.ability.extra.lock then
			if pseudorandom('youre_the_joker') < G.GAME.probabilities.normal/card.ability.extra.odds and 
			(#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit or (#G.consumeables.cards +  G.GAME.consumeable_buffer <= G.consumeables.config.card_limit and context.card.ability.set ~= "Joker")) then
			-- is negative consumable at limit check 
			if context.card.edition ~= nil and context.card.edition.negative and context.card.ability.set ~= "Joker" and #G.consumeables.cards + G.GAME.consumeable_buffer == G.consumeables.config.card_limit then
				return
			end
			G.GAME.consumeable_buffer =  G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_fool')
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end
			}))
			return{
				message = "HAHA!"
			}
			end
		end
	end
}

--Backpack
function get_backpack_count()
	local count = 0
	if G.consumeables == nil then
		return count
	else
		for k, v in pairs(G.consumeables.cards) do
			if (v ~= nil) and (v.edition == nil or not v.edition.negative) then count = count + 1 end
		end
	end
	return count
end
SMODS.Joker{
	key = 'backpack',

	loc_txt = {
		name = 'Backpack',
		text = {
			"{C:mult}+#1#{} Mult for each filled",
			"consumable slot",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},

	config = { extra = {mult_gain = 10, mult = 0}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult_gain * get_backpack_count()}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function (self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult_gain * get_backpack_count()
			}
		end
	end

}

--Expanding Joker
SMODS.Joker{
	key = 'expanding_joker',

	loc_txt = {
		name = 'Expanding Joker',
		text = {
			"{C:mult}+#1#{} Mult for each card",
			"in deck over standard deck size",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},

	config = { extra = { mult_gain = 1, mult = 0}},

	loc_vars = function(self, info_queue, card)
		local mult = 0
		if G.playing_cards == nil then mult = 0 
		else
		mult = #G.playing_cards - G.GAME.starting_deck_size
		end
		if mult < 0 then mult = 0 end
		return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult_gain*mult}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 2, y = 3 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local mult = #G.playing_cards - G.GAME.starting_deck_size
			if mult < 0 then mult = 0 end
			return {
				mult = mult
			}
		end
	end
}

--Snack Joker
SMODS.Joker{
	key = 'snack_joker',

	loc_txt = {
		name = 'Snack Joker',
		text = {
			"{C:chips}+#1#{} Chips when any",
			"consumable is used",
			"{C:inactive}(Currently {C:chips}#2#{C:inactive} Chips)"

		}
	},

	config = { extra = {chip_gain = 2, chip = 0}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.chip_gain, card.ability.extra.chip} }
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	perishable_compat = false,

	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint then
			card.ability.extra.chip = card.ability.extra.chip_gain + card.ability.extra.chip
			return {
				message = localize('k_upgrade_ex'),
				card = card
			}
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chip
			}
		end
	end
}

-- Cupid Arrow
SMODS.Joker{
	key = 'cupid_arrow',

	loc_txt = {
		name = 'Cupid Arrow',
		text = {
			"If hand contains only {V:2}Hearts{},",
			"create a {C:tarot}Lovers{}"
		}
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_lovers
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
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local suits = get_suits_count(context)
			if suits['Diamonds'] == 0 and suits['Clubs'] == 0 and suits['Spades'] == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_lovers')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end
				}))
				return {
					message = "LOVE"
				}
			end
		end
	end
}

-- Hit the Gym
SMODS.Joker{
	key = 'hit_the_gym',

	loc_txt = {
		name = 'Hit the Gym',
		text = {
			"If hand contains a scoring {C:attention}Jack{},",
			"create a {C:tarot}Strength{}"
		}
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_strength
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 9,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local contains_jack = false
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i]:get_id() == 11 then contains_jack = true end
			end
			if contains_jack and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_strength')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end
				}))
				return {
					message = "Gains"
				}
			end
		end
	end
}

-- Gremlin Joker
SMODS.Joker{
	key = 'gremlin_joker',

	loc_txt = {
		name = 'Gremlin Joker',
		text = {
			"{C:green}#2# in #1#{} chance for {C:mult}+#4#{} Mult",
			"{C:green}#3# in #1#{} chance for {C:mult}#5#{} Mult",
			"Odds cannot be changed"
		}
	},

	config = { extra = { max = 5, good_chance = 4, bad_chance = 1, p_mult = 25, m_mult = -20}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.max, card.ability.extra.good_chance, card.ability.extra.bad_chance, card.ability.extra.p_mult, card.ability.extra.m_mult}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 5,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			if pseudorandom("gremlin", 1, card.ability.extra.max) <= 1 then
				return {
					mult = card.ability.extra.m_mult
				}
			else
				return {
					mult = card.ability.extra.p_mult
				}
			end
		end
	end,
}

-- Forbidden Fruit
SMODS.Joker{
	key = 'forbidden_fruit',

	loc_txt = {
		name = 'Forbidden Fruit',
		text = {
			"Playing a {C:attention}#1# {}of",
			"{V:1}#2#{} fills all consumable slots",
			"with {C:tarot}Judgements{}",
			"Card changes each round"
		}
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_judgement
		return { vars = {localize(G.GAME.current_round.idol_card.rank, 'ranks'), localize(G.GAME.current_round.idol_card.suit, 'suits_plural'), colours = { G.C.SUITS[G.GAME.current_round.idol_card.suit] }}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	calculate = function (self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then	
			if context.other_card:get_id() == G.GAME.current_round.idol_card.id and context.other_card:is_suit(G.GAME.current_round.idol_card.suit) 
			and #G.consumeables.cards < G.consumeables.config.card_limit then
				for i = 1, (G.consumeables.config.card_limit - #G.consumeables.cards) do
					G.E_MANAGER:add_event(Event({
						func = function()
							card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_judgement')
							card:add_to_deck()
							G.consumeables:emplace(card)
							return true
						end
					}))
				end
				return {
					message = "Judged...",
					card = card
				}
			end
		end
	end
}

-- Five Day Stay
SMODS.Joker{
	key = 'five_day_stay',

	loc_txt = {
		name = 'Five Day Stay',
		text = {
			"Gains {C:white,X:mult}X#1#{} Mult for",
			"each scored {C:attention}5{}",
			"This Joker stops scaling after {C:attention}#2#{} rounds",
			"{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
		}
	},

	config = { extra = {mult_gain = 0.1, rounds = 5, xmult = 1}},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_gain, card.ability.extra.rounds, card.ability.extra.xmult }}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	perishable_compat = false,

	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and card.ability.extra.rounds > 0 and not context.individual and not context.repetition then
			card.ability.extra.rounds = card.ability.extra.rounds - 1
			return {
				message = "-1 round"
			}
		end
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 5 and card.ability.extra.rounds > 0 and not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.mult_gain
			return {
				message = localize('k_upgrade_ex'),
				card = card
			}
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}

-- Pear
SMODS.Joker{
	key = 'pear',

	loc_txt = {
		name = 'Pear',
		text = {
			"Gains {C:chips}+#1#{} chips if hand is a {C:attention}Pair{}",
			"{C:chips}-#1#{} chips does not contain a {C:attention}Pair{}",
			"{C:inactive}(Currently {C:chips}#2#{C:inactive} chips)"
		}
	},

	config = { extra = { chip_change = 5, chips = 50}},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chip_change, card.ability.extra.chips}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.before then
			if context.scoring_name == 'Pair' then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_change
				return {
					message = localize('k_upgrade_ex'),
					card = card
				}
			elseif not next(context.poker_hands['Pair']) then
				card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_change
				return {
					message = localize{type='variable',key='a_chips_minus',vars={ card.ability.extra.chip_change}},
                    colour = G.C.CHIPS
				}
			end
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}

-- Lootbox
SMODS.Joker{
	key = 'lootbox',

	loc_txt = {
		name = 'Lootbox',
		text = {
			"Create {C:attention}#1#{} random {C:attention}Tag#3#{}",
			"when this Joker is sold",
			"Increases by {C:attention}#2#{} every round this",
			"Joker is held"
		}
	},

	config = { extra = { count = 0, gain = 1}},

	loc_vars = function(self, info_queue, card)
		local text = ''
		if card.ability.extra.count >= 2 then
			text = 's'
		end
		return { vars = {card.ability.extra.count, card.ability.extra.gain, text}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	eternal_compat = false,
	perishable_compat = false,

	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
			card.ability.extra.count = card.ability.extra.count + card.ability.extra.gain
			return {
				message = localize('k_upgrade_ex')
			}
		end
		if context.selling_self then
			local len = get_table_size(G.P_TAGS)
			for i = 1, card.ability.extra.count do
				local count = 1
				local random = pseudorandom(pseudoseed("lootbox"), 1, len)
				for k in pairs(G.P_TAGS) do
					if count == random then
						local tag = Tag(k)
						if tag.name == "Orbital Tag" then
							tag.ability.orbital_hand = G.handlist[pseudorandom('orbital_hand', 1, #G.handlist)] 
						end
						G.E_MANAGER:add_event(Event({
						func = (function()
							add_tag(tag)
							play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
							play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
							return true
						end)
						}))	
					end
					count = count + 1
				end	
			end
		end
	end
}

-- Elemental Destroyer
SMODS.Joker{
	key = 'elemental_destroyer',

	loc_txt = {
		name = 'Elemental Destroyer',
		text = {
			"Changes {C:attention}#1#{} card in {C:attention}first hand{}",
			"of round to a {C:attention}Wild Card{}"
		}
	},

	config = { extra = 1},
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_wild
		return { vars = {card.ability.extra}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.before and G.GAME.current_round.hands_played == 0 then
			for i = 1, card.ability.extra do
				local random_card = pseudorandom("elemental_destroyer", 1, #context.full_hand)
				context.full_hand[random_card]:set_ability(G.P_CENTERS.m_wild, nil, true)
				return {
					message = "Destroyed",
					card = card
				}
			end
		end
	end
}

-- All Seeing Eye
SMODS.Joker{
	key = 'all_seeing_eye',

	loc_txt = {
		name = 'All Seeing Eye',
		text = {
			"If hand contains exactly {C:attention}#1#{}",
			"{C:attention}#2#s{}, create a {C:spectral}Soul{}",
			"Rank changes each round"
		}
	},

	config = { extra = { req_cards = 5}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_soul
		return { vars = {card.ability.extra.req_cards, G.GAME.current_round.eye_rank.name}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 10,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local count = 0
			for i = 1, card.ability.extra.req_cards do 
				if G.GAME.current_round.eye_rank.id == context.full_hand[i]:get_id() then count = count + 1 end
			end	
			if count == card.ability.extra.req_cards and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_soul')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end
				}))
				return {
					message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral
				}
			end
		end
	end
}

-- Strike
SMODS.Joker{
	key = 'strike',

	loc_txt = {
		name = 'Strike',
		text = {
			"This Joker gains {C:mult}+#1#{} Mult",
			"if hand contains only scoring {C:attention}face cards{}",
			"Resets if a {C:attention}non-face card{} is scored",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},

	config = { extra = {mult_gain = 3, mult = 0}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult}}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.before then
			local nonface = false
			for i = 1, #context.scoring_hand do
				if not context.scoring_hand[i]:is_face() then nonface = true end
				if nonface then
					card.ability.extra.mult = 0
					return {
						message = localize('k_reset')
					}
				else
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
					return {
						message = localize('k_upgrade_ex')
					}
				end
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
	end

}

-- Ritual
SMODS.Joker{
	key = 'ritual',

	loc_txt = {
		name = 'Ritual',
		text = {
			"When {C:attention}boss blind{} is defeated,",
			"create a random {C:spectral}Spectral{} card"
		}
	},

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.end_of_round and G.GAME.blind.boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.individual and not context.repetition then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					card = create_card('Spectral', G.consumables, nil, nil, nil, nil)
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end
			}))
			return {
				message = localize('k_plus_spectral'), 
				colour = G.C.SECONDARY_SET.Spectral
			}
		end 
	end
}

-- Mult Money
SMODS.Joker{
	key = 'mult_money',

	loc_txt = {
		name = 'Mult Money',
		text = {
			"If hand contains {C:attention}#1# Mult{}",
			"cards, gain {C:money}$#2#"
		}
	},

	config = { extra = {mult_cards = 2, dollars= 5}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_mult
		return { vars = {card.ability.extra.mult_cards, card.ability.extra.dollars}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local mult_count = 0
			for i = 1, #context.full_hand do
				if context.full_hand[i].config.center.key == "m_mult" then mult_count = mult_count + 1 end
			end
			if mult_count >= card.ability.extra.mult_cards then
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
				G.E_MANAGER:add_event(Event({
					func = (function()
						G.GAME.dollar_buffer = 0; return true
					end)
				}))
				return {
					dollars = card.ability.extra.dollars,
					colour = G.C.MONEY
				}
			end
		end
	end,
}

-- Bonus Bonus
SMODS.Joker{
	key = 'bonus_bonus',

	loc_txt = {
		name = 'Bonus Bonus',
		text = {
			"{C:attention}Bonus{} cards have a",
			"{C:green}#1# in #2#{} chance of giving",
			"{C:white,X:chips}X#3#{} chips"
		}
	},

	config = {extra = {min = 1, max = 5, xchips = 2}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
		return {vars = {(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.max, card.ability.extra.xchips}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 3, y = 3 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i].config.center.key == "m_bonus" and pseudorandom('bonusbonus') < G.GAME.probabilities.normal/card.ability.extra.max then
					return {
						xchips = card.ability.extra.xchips,
						card = card
					}
				end
			end
		end
	end
}

-- Frozen Joker
SMODS.Joker{
	key = 'frozen_joker',

	loc_txt = {
		name = 'Frozen Joker',
		text = {
			"All {C:attention}Enhanced {}cards are",
			"turned into {C:attention}Ice {}cards"
		}
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_mlnc_ice
		return { vars = {}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 7,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	calculate = function(self, card, context)
		if context.before then
			local count = 0
			for i = 1, #context.scoring_hand do
				--this currently resets buffed ice cards from ice age. maybe get rid of "resetting" ice cards or just on buffed ice cards
				if context.scoring_hand[i].config.center.key ~= "c_base" then
					count = count + 1
					context.scoring_hand[i]:set_ability(G.P_CENTERS.m_mlnc_ice, nil, true)
				end
			end
			if count > 0 then
				return {
					message = "Frozen!",
					card = card
				}
			end
		end
	end
}

-- Ice Age
SMODS.Joker{
	key = 'ice_age',

	loc_txt = {
		name = 'Ice Age',
		text = {
			"{C:attention}Ice {}cards never thaw",
			"When triggers hit {C:attention}#1#{},",
			"The card gains {C:white,X:chips}X#2#{} chips"
		}
	},

	config = { extra = {triggers = 0, xchip_gain = 0.25 }},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_mlnc_ice
		return { vars = { card.ability.extra.triggers, card.ability.extra.xchip_gain}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = false,

	--check misc.lua for joker logic
}

-- Shiny Hunting
SMODS.Joker{
	key = 'shiny_hunting',

	loc_txt = {
		name = 'Shiny Hunting',
		text = {
			"Sell this Joker to add {C:edition}Foil{},",
			"{C:edition}Holographic{} or {C:edition}Polychrome{}",
			"to all cards in hand"
		}
	},

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 1, y = 3 },
	cost = 9,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, #G.hand.cards do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					G.hand.cards[i]:set_edition(poll_edition('shiny_hunting', nil, true, true), true)
				return true end }))
			end
		end
	end
}

-- Encore
SMODS.Joker{
	key = 'encore',

	loc_txt = {
		name = 'Encore',
		text = {
			"If played hand is the same as",
			"previous played hand, earn {C:gold}$#1#{}"
		}
	},

	config = { extra = { dollars = 3, prev_hand = ''}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.dollars }}
	end,

	rarity = 1,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.before then
			if card.ability.extra.prev_hand == context.scoring_name then
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
				G.E_MANAGER:add_event(Event({
					func = (function()
						G.GAME.dollar_buffer = 0; return true
					end)
				}))
				return {
					dollars = card.ability.extra.dollars,
					colour = G.C.MONEY
				}
			end
		end
		if context.after then
			card.ability.extra.prev_hand = context.scoring_name
		end
	end
}

-- World Record Pace
SMODS.Joker{
	key = 'world_record_pace',

	loc_txt = {
		name = 'World Record Pace',
		text = {
			"When skipping a {C:attention}Blind{}, gain extra",
			"{C:attention}Tags{} equal to the amount of {C:attention}Blinds{} skipped",
			"{C:inactive}(Currently {C:attention}#1#{C:inactive} skipped)"
		}
	},

	loc_vars = function(self, info_queue, card)
		return { vars = {G.GAME.skips }}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 4, y = 3 },
	cost = 8,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.skip_blind then
			for i = 1, G.GAME.skips do
				local count = 1
				local random = pseudorandom(pseudoseed("worldrecordpace"), 1, get_table_size(G.P_TAGS))
				for k in pairs(G.P_TAGS) do
					if count == random then
						local tag = Tag(k)
						if tag.name == "Orbital Tag" then
							tag.ability.orbital_hand = G.handlist[pseudorandom('orbital_hand', 1, #G.handlist)] 
						end
						G.E_MANAGER:add_event(Event({
						func = (function()
							add_tag(tag)
							play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
							play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
							return true
						end)
						}))	
					end
					count = count + 1
				end
			end
			local thunk1 = pseudorandom('wrp_time', -15, 20)
			local thunk2 = pseudorandom('wrp_time', 0, 99)
			local plus = ''
			if thunk1 > 0 then plus = '+' end
			return {
				message = plus..tostring(thunk1).."."..tostring(thunk2),
				card = card
			}
		end
	end
}

-- Binary
SMODS.Joker{
	key = 'binary',

	loc_txt = {
		name = 'Binary',
		text = {
			"{C:white,X:mult}X#1#{} Mult if played hand",
			"contains exactly {C:attention}#2#{} unique {C:attention}suits"
		}
	},

	config = { extra = {xmult = 3, suits = 2}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.xmult, card.ability.extra.suits}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			local suits = get_suits_count(context)
			local count = 0
			if suits["Clubs"] > 0 then count = count + 1 end
			if suits["Hearts"] > 0 then count = count + 1 end
			if suits["Diamonds"] > 0 then count = count + 1 end
			if suits["Spades"] > 0 then count = count + 1 end
			if count == card.ability.extra.suits then
				return {
					Xmult = card.ability.extra.xmult
				}
			end
		end
	end
}

-- Manifesto
SMODS.Joker{
	key = 'manifesto',

	loc_txt = {
		name = 'Manifesto',
		text = {
			"{C:white,X:mult}X#1#{} Mult",
			"This Joker is always {C:attention}Pinned"
		}
	},

	config = { extra = 2},

	loc_vars = function(self, info_queue, card)
		if card.pinned == true then
			for i = 1, #info_queue do
				info_queue[i] = nil
			end
		else
			info_queue[#info_queue+1] = {key = 'pinned_left', set = 'Other'}
		end
		return { vars = {card.ability.extra}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 6,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	add_to_deck = function(self, card, from_debuff)
		card.pinned = true
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra
			}
		end
	end
}

-- Jack of All Trades
get_played_count = function()
	local count = 0
	for i = 1, #G.handlist do
		if 	G.GAME.hands[G.handlist[i]].played > 0 then count = count + 1 end
	end
	return count
end

SMODS.Joker{
	key = 'jack_of_all_trades',

	loc_txt = {
		name = 'Jack of all Trades',
		text = {
			"{C:white,X:mult}X#1#{} Mult for each",
			"unique Poker Hand played this run",
			"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
		}
	},

	config = { extra = {xmult_gain = 0.25, xmult = 1}},

	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult + card.ability.extra.xmult_gain * get_played_count()}}
	end,

	rarity = 3,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 9,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * get_played_count()
			}
		end
	end
}

-- Coin Flip
SMODS.Joker{
	key = 'coin_flip',

	loc_txt = {
		name = 'Coin Flip',
		text = {
			"Played cards with a {C:gold}Gold Seal{} have a",
			"{C:green}#1# in #2#{} chance to retrigger {C:attention}#3#{} times"
		}
	},

	config = { extra = {max = 2, retriggers = 2}},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS.Gold
		return { vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.max, card.ability.extra.retriggers}}
	end,

	rarity = 2,
	atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
	cost = 4,

	unlocked = true,
	discovered = true,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card.seal == 'Gold' then
			if pseudorandom('coinflip') < (G.GAME and G.GAME.probabilities.normal)/card.ability.extra.max then
				return {
                    message = localize('k_again_ex'),
					repetitions = card.ability.extra.retriggers
				}
			end
		end
	end
}