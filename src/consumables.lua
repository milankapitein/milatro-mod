Use_tarot = function(flip_back)
    if not flip_back then
        --todo: add the move animation to the start of the tarot
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.4,func = function() play_sound('tarot1'); --[[ used_tarot:juice_up(0.3, 0.5); --]] return true end }))
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

    cost = 4,
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
        Use_tarot(false)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.highlighted[1]:set_ability(G.P_CENTERS.m_mlnc_ice);return true end }))
        Use_tarot(true)
        return {}
    end
}