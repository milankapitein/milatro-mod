-- Ice Enhancement
SMODS.Enhancement{
    key = "ice",

    loc_txt = {
        name = 'Ice',
        text = {
            "{C:white,X:chips}X#1#",
            "Enhancement gets removed after {C:attention}#2#{} triggers"}
    },

    config = { extra = {xchips = 1.5, triggers = 5, max_triggers = 5}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xchips, card.ability.extra.triggers}}
    end,

    atlas = 'MilatroMod',
	pos = { x = 0, y = 0 },

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.extra.triggers = card.ability.extra.triggers - 1
            return {
                xchips = card.ability.extra.xchips,
            }
        end
        if context.after and card.ability.extra.triggers == 0 then
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
    end
}