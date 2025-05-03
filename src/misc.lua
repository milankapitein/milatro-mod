-- Ice Enhancement
SMODS.Enhancement{
    key = "ice",

    loc_txt = {
        name = 'Ice',
        text = {
            "{C:white,X:chips}X#1#",
            "Enhancement gets removed after {C:attention}#2#{} triggers"}
    },

    config = { extra = {xchips = 1.5, triggers = 5}},
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
            card:set_ability(G.P_CENTERS.c_base, nil, true)
            return { 
                message = "Thawed!",
                card = card
            }
        end
    end
}