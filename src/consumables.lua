Use_tarot = function(flip_back, used_tarot)
    if not flip_back then
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() play_sound('tarot1'); used_tarot:juice_up(0.3, 0.5); return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            delay(0.2)
        end 
    else
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end 
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end

end

-- The Sword
SMODS.Consumable{
    key = 'the_sword',

    loc_txt = {
        name = 'The Sword',
        text = {
            "Turns one selected into",
            "an Ice card" }
    },

    object_type = "Consumable",
    set = 'Tarot',

    cost = 3,
    atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,

    config = { extra = {count = 1, enhancement = "m_mlnc_ice"}},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mlnc_ice
        return { vars = {
            card and card.ability.extra.count or self.config.extra.count,
            localize{type = 'name_text', set = 'Enhanced', key = self.config.extra.enhancement}}}
    end,

    can_use = function(self, card)
        return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.extra.count
    end,
    use = function(self, card, area, copier)
        Use_tarot(false, copier or card)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.highlighted[1]:set_ability(G.P_CENTERS.m_mlnc_ice);return true end }))
        Use_tarot(true, copier or card)
        return {}
    end
}

-- Necromancer
SMODS.Consumable{
    key = 'necromancer',

    loc_txt = {
        name = 'Necromancer',
        text = {
            "Create a random {C:spectral}Spectral{} card",
            "{C:inactive}(Must have room){}" }
    },

    object_type = "Consumable",
    set = 'Tarot',

    cost = 3,
    atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,

    can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
        play_sound('timpani')
        G.E_MANAGER:add_event(Event({
            func = function()
                local used_tarot = copier or card
                used_tarot:juice_up(0.3, 0.5)
                local made_card = create_card('Spectral', G.consumables, nil, nil, nil, nil)
                made_card:add_to_deck()
                G.consumeables:emplace(made_card)
                return true
            end
        }))
    end
}

-- Summon
SMODS.Consumable{
    key = 'summon',

    loc_txt = {
        name = 'Summon',
        text = {
            "Create up to {C:attention}#1# Jokers{},",
            "lose {C:red}-$#2#",
            "{C:inactive}(Must have Room)" }
    },

    object_type = "Consumable",
    set = 'Spectral',

    cost = 4,
    atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,

    config = { extra = {jokers = 5, money_loss = 10}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.jokers, card.ability.extra.money_loss}}
    end,

    can_use = function(self, card)
        return #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
    end,

    use = function(self, card, area, copier)
        local jokers_to_create = math.min(card.ability.extra.jokers, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
        G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
        play_sound('timpani')
        G.E_MANAGER:add_event(Event({
            func = function() 
                local used_tarot = copier or card
                used_tarot:juice_up(0.3, 0.5)
                for i = 1, jokers_to_create do
                    local other_card = create_card('Joker', G.jokers, nil, nil, nil, nil)
                    other_card:add_to_deck()
                    G.jokers:emplace(other_card)
                    other_card:start_materialize()
                    G.GAME.joker_buffer = 0
                end
                return true
            end})) 
        ease_dollars(-1 * card.ability.extra.money_loss, true)
    end
}

-- Burst (change name maybe)
SMODS.Consumable{
    key = 'burst',

    loc_txt = {
        name = "Burst",
        text = {
            "Create a random {C:attention}Tag{}"
        }
    },

    object_type = "Consumable",
    set = 'Spectral',

    cost = 4,
    atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local count = 0
        local random = pseudorandom(pseudoseed("burst"), 1, get_table_size(G.P_TAGS))
        for k in pairs(G.P_TAGS) do
            if count == random then
                local tag = Tag(k)
                if tag.name == "Orbital Tag" then
                    tag.ability.orbital_hand = G.handlist[pseudorandom('orbital_hand', 1, #G.handlist)]
                end
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(tag)
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end)
                }))
            end
            count = count + 1
        end
    end

}

-- Designer (also maybe change later)
SMODS.Consumable{
    key = 'designer',

    loc_txt = {
        name = "The Designer",
        text = {
            "Adds a random {C:attention}Enhancement{}",
            "to {C:attention}#1#{} random cards"
        }
    },

    config = { extra = 2},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra }}
    end,

    object_type = "Consumable",
    set = 'Tarot',

    cost = 4,
    atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,

    can_use = function(self, card)
        return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.extra
    end,

    use = function(self, card, area, copier)
        Use_tarot(false, copier or card)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.highlighted[i]:set_ability(pseudorandom_element(G.P_CENTER_POOLS["Enhanced"], pseudoseed("designer")));return true end }))
        end
        Use_tarot(true, copier or card)
    end
}
