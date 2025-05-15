-- Ice Enhancement
Thaw = function(card)
    if next(SMODS.find_card("j_mlnc_ice_age")) then
        card.ability.extra.xchips = card.ability.extra.xchips + SMODS.find_card("j_mlnc_ice_age")[1].ability.extra.xchip_gain
        card.ability.extra.triggers = card.ability.extra.max_triggers
        return {
            message = "Re-frozen!",
            card = card
        }
    else
        card:set_ability(G.P_CENTERS.c_base, nil, true)
        return { 
            message = "Thawed!",
            card = card
        }
    end
end

SMODS.Enhancement{
    key = "ice",

    loc_txt = {
        name = 'Ice Card',
        text = {
            "{C:white,X:chips}X#1#{} chips",
            "Enhancement gets removed",
            "after {C:attention}#2#{} triggers"}
    },

    config = { extra = {xchips = 1.5, triggers = 5, max_triggers = 5}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xchips, card.ability.extra.triggers}}
    end,

    atlas = 'MilatroModDecks',
	pos = { x = 0, y = 1 },

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if card.ability.extra.triggers > 0 then
                card.ability.extra.triggers = card.ability.extra.triggers - 1
                return {
                    xchips = card.ability.extra.xchips,
                }
            else
                return Thaw(card)
            end
        end
        if context.after and card.ability.extra.triggers <= 0 then
           return Thaw(card)
        end
    end
}

-- Wheel Tag
SMODS.Tag{
    key = 'wheel_skip',

    loc_txt = {
        name = 'Wheel Tag',
        text = {
            "Adds Foil, Holographic or",
            "Polychrome to {C:attention}#1#{} Jokers"
        }
    },

    config = { extra = 2},

    loc_vars = function(self, info_queue)
        return { vars = {self.config.extra }}
    end,

    atlas = 'MilatroModDecks',
	pos = { x = 0, y = 0 },

    discovered = true,
    min_ante = 3,

    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local temp_jonklers = {}
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].edition then
                    temp_jonklers[#temp_jonklers+1] = G.jokers.cards[i]
                end
            end
            if #temp_jonklers == 0 then return false end
            pseudoshuffle(temp_jonklers, pseudoseed('t_wheel'))
            for i = 1, math.min(tag.config.extra, #temp_jonklers) do
                temp_jonklers[i]:set_edition(poll_edition('wheel_of_fortune', nil, true, true))
            end
            tag:yep('+', G.C.BLUE, function()
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

-- Cleanse Tag
SMODS.Tag{
    key = 'cleanse',

    loc_txt = {
        name = 'Cleanse Tag',
        text = {
            "Removes {C:attention}Rental{}, {C:attention}Perishable{},",
            "{C:attention}Debuffed{}, {C:attention}Eternal{} and {C:attention}Pinned{} property",
            "from all Jokers"
        }
    },

    atlas = 'MilatroModDecks',
	pos = { x = 0, y = 0 },

    discovered = true,
    min_ante = 2,

    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local triggers = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.eternal then
                    G.jokers.cards[i].ability.eternal = false
                    triggers = triggers + 1
                end
                if G.jokers.cards[i].ability.rental then
                    G.jokers.cards[i].ability.rental = false
                    triggers = triggers + 1
                end
                if G.jokers.cards[i].pinned then
                    G.jokers.cards[i].pinned = false
                    triggers = triggers + 1
                end
                if G.jokers.cards[i].ability.perishable then
                    G.jokers.cards[i].ability.perishable = false
                    triggers = triggers + 1
                end
                if G.jokers.cards[i].debuff then
                    G.jokers.cards[i].debuff = false
                    triggers = triggers + 1
                end
            end
            if triggers == 0 then return false end
            tag:yep('+', G.C.BLUE, function()
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

-- Playing Tag
SMODS.Tag{
    key = 'playing',

    loc_txt = {
        name = 'Playing Tag',
        text = {
            "Next round, get {C:blue}+#1# hands{}",
            "and {C:red}+#1# discards"
        }
    },

    config = { extra = 3},

    loc_vars = function(self, info_queue)
        return { vars = {self.config.extra}}
    end,

    atlas = 'MilatroModDecks',
	pos = { x = 0, y = 0 },

    discovered = true,
    min_ante = 2,

    apply = function(self, tag, context)
		if context.type == "round_start_bonus" then
			tag:yep("+", G.C.BLUE, function()
				return true
			end)
			ease_hands_played(tag.config.extra)
			ease_discard(tag.config.extra)
			tag.triggered = true
			return true
		end
    end
}