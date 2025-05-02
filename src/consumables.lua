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
        G.hand.highlighted[1]:set_ability(G.P_CENTERS.m_mlnc_ice, nil, true)
        G.hand.highlighted[1]:juice_up()
        return {}
    end
}