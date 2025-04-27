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

    boss = {min = 2, max = 10},
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

-- The Count
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
    boss_colour = HEX("389396"),

	set_blind = function(self)
		local length = 0
		for k,v in pairs(G.P_BLINDS) do 
			if G.P_BLINDS[k].boss ~= nil and G.P_BLINDS[k].boss.showdown == nil then
				length = length + 1
			end
		end

		sendTraceMessage(tostring(length), "illusion")
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