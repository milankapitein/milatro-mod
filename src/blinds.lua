-- The Count
SMODS.Blind{
    key = 'the_count',
    loc_txt = {
        name = "The Count",
        text = {
            "The most frequent card",
            "in your deck is debuffed"
        }
    },

    discovered = true,
    unlocked = true,

    atlas = "MilatroBlinds",
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,

    boss = {min = 1, max = 10},
    boss_colour = HEX("389396"),


    recalc_debuff = function(self, card, from_blind)
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
		if card:get_id() == highestFreq then
			card:set_debuff(true)
			return true
		end
        return false
    end
}

-- The Illusion
SMODS.Blind{
    key = 'the_illusion',
    loc_txt = {
        name = "The Illusion",
        text = {
            "Picks a random,",
			"non-finisher Boss Blind"
        }
    },

    discovered = true,
    unlocked = true,

    atlas = "MilatroBlinds",
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,

    boss = {min = 3, max = 10},
    boss_colour = HEX("751e0b"),

	set_blind = function(self)
		local length = 0
		for k,v in pairs(G.P_BLINDS) do 
			if G.P_BLINDS[k].boss ~= nil and G.P_BLINDS[k].boss.showdown == nil then
				length = length + 1
			end
		end

		local selection = pseudorandom("illusion", 1, length)

		local count = 1
		for k,v in pairs(G.P_BLINDS) do
			if count == selection then
				G.GAME.blind:set_blind(G.P_BLINDS[k], false, false)
				return
			end
			count = count + 1
		end
	end
}

-- The Lower
SMODS.Blind{
	key = 'the_lower',
    loc_txt = {
        name = "The Lower",
        text = {
            "Played hand is considerd",
			"the hand below"
        }
    },

    discovered = true,
    unlocked = true,

    atlas = "MilatroBlinds",
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,

    boss = {min = 2, max = 10},
    boss_colour = HEX("27cfdb"),

	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		if text == "High Card" then return mult, hand_chips, false end
		for i = 1, #G.handlist do
			if text == G.handlist[i] then
				local new_hand = G.handlist[i + 1]
				return G.GAME.hands[new_hand].mult, G.GAME.hands[new_hand].chips, true
			end
		end	
		return mult, hand_chips, false
	end
}

-- The Wrecker
SMODS.Blind{
	key = 'the_wrecker',
    loc_txt = {
        name = "The Wrecker",
        text = {
            "After each hand, destroy a random",
			"Joker, card or consumable",
        }
    },

    discovered = true,
    unlocked = true,

    atlas = "MilatroBlinds",
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,

    boss = {min = 4, max = 10},
    boss_colour = HEX("16960f"),

	drawn_to_hand = function()
		if G.GAME.current_round.hands_played ~= 0 then
			local destructable_jokers = {}
			for i = 1, #G.jokers.cards do
				if not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
			end

			local val = pseudorandom("wrecker", 0, 10)
			if val < 4 and #G.consumeables.cards ~= 0 then -- consumable
				local consumable_to_destroy = #G.consumeables.cards > 0 and pseudorandom_element(G.consumeables.cards, pseudoseed('wrecker_co')) or nil
				G.E_MANAGER:add_event(Event({
					func = function()
						consumable_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
						return true
					end
				}))
			elseif val > 8 and #destructable_jokers ~= 0 then -- joker
				local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('wrecker_j')) or nil
				joker_to_destroy.getting_sliced = true
				G.E_MANAGER:add_event(Event({
					func = function()
						joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
						return true
					end
				}))
			else -- card
				local card_to_destroy = #G.hand.cards > 0 and pseudorandom_element(G.hand.cards, pseudoseed('wrecker_ca')) or nil
				G.E_MANAGER:add_event(Event({
					func = function()
						card_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
						return true
					end
				}))
			end
		end
	end
}

-- The Brain
SMODS.Blind{
	key = 'the_brain',
    loc_txt = {
        name = "The Brain",
        text = {
            "When Blind is selected,",
			"leftmost Joker is debuffed",
        }
    },

    discovered = true,
    unlocked = true,

    atlas = "MilatroBlinds",
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,

    boss = {min = 2, max = 10},
    boss_colour = HEX("7b29ab"),

	set_blind = function(self)
		if G.jokers.cards[1] then
			G.jokers.cards[1]:juice_up()
		end
	end,

	recalc_debuff = function(self, card, from_blind)
		return card == G.jokers.cards[1]
	end


	-- disable = function(self)
	-- 	if G.jokers.cards[1] then
	-- 		G.jokers.cards[1]:set_debuff(false)
	-- 	end
	-- end,

	-- defeat = function(self)
	-- 	if G.jokers.cards[1] then
	-- 		G.jokers.cards[1]:set_debuff(false)
	-- 	end
	-- end
}