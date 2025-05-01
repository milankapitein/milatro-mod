-- Fortune Deck
SMODS.Back {
    name = "Fortune Deck",
    key = "fortune",
    atlas = "MilatroModDecks",
    pos = { x = 0, y = 0},
    loc_txt = {
        name = "Fortune Deck",
        text = {
            "Start in Ante 2. All",
            "cards are {C:attention,T:m_lucky}Lucky{} cards."
        }
    },

    unlocked = true,
    discovered = true,

    config = {},
    loc_vars = function(self, info_queue, center)
        return {vars = { }}
    end,

    apply = function()
        ease_ante(1)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + 1
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    G.playing_cards[i]:set_ability(G.P_CENTERS.m_lucky)
                end
                return true
            end
        }))
    end
}

-- Stacked Deck
SMODS.Back {
    name = "Stacked Deck",
    key = "stacked",
    atlas = "MilatroModDecks",
    pos = { x = 1, y = 0},
    loc_txt = {
        name = "Stacked Deck",
        text = {
            "Start a run with{C:attention} 2, 3, 4{} and {C:attention}5{}",
            "replaced with {C:attention}Jack, Queen,{}",
            "{C:attention}King{} and {C:attention}Ace{}."
        }
    },

    unlocked = true,
    discovered = true,

    config = {},
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,

    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = #G.playing_cards, 1, -1 do
                    if G.playing_cards[i]:get_id() <= 5 then
                        local card = G.playing_cards[i]
                        local suit_prefix = string.sub(card.base.suit, 1, 1) .. '_'
                        local rank_suffix = math.min(card.base.id + 9, 14)
                        if rank_suffix < 10 then
                            rank_suffix = tostring(rank_suffix)
                        elseif rank_suffix == 10 then
                            rank_suffix = 'T'
                        elseif rank_suffix == 11 then
                            rank_suffix = 'J'
                        elseif rank_suffix == 12 then
                            rank_suffix = 'Q'
                        elseif rank_suffix == 13 then
                            rank_suffix = 'K'
                        elseif rank_suffix == 14 then
                            rank_suffix = 'A'
                        end
                        card:set_base(G.P_CARDS[suit_prefix .. rank_suffix])
                    end
                end
                return true
            end
        }))
    end
}

-- Singularity Deck
SMODS.Back {
    name = "Singularity Deck",
    key = "singularity",
    atlas = "MilatroModDecks",
    pos = {x = 2, y = 0},

    loc_txt = {
        name = "Singularity Deck",
        text = {
            "Start with {C:spectral,T:c_black_hole}Black Hole{},", 
            "{C:planet,T:v_planet_merchant}Planet Merchant{} and",
            "after defeating {C:attention}Boss Blind{},",
            "create an {C:planet,T:tag_orbital}Orbital Tag{}"
        }
    },

    unlocked = true,
    discovered = true,

    config = { vouchers = {"v_planet_merchant"}},
    loc_vars = function(self, info_queue, center)
        return { vars = {}}
    end,

    apply = function ()
        G.E_MANAGER:add_event(Event({
            func = function()
                local card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_black_hole')
                card:add_to_deck()
                G.consumeables:emplace(card)
                return true
            end
        }))
    end,

    calculate = function(self, back, context)
        if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local tag = Tag('tag_orbital')
                    tag.ability.orbital_hand = G.handlist[pseudorandom('orbital_hand', 1, #G.handlist)] 
                    add_tag(tag)
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
}

-- Unboxing Deck
-- art idea: cardboard like vagabond with tape and this side up sticker. also maybe packaging label idk
SMODS.Back {
    name = "Unboxing Deck",
    key = "unboxing",
    atlas = "MilatroModDecks",
    pos = {x = 0, y = 0},

    loc_txt = {
        name = "Unboxing Deck",
        text = {
            "Start run with",
            "{C:attention,T:v_mlnc_turbo_v}Turbo Boost{}, {C:attention,T:v_mlnc_nitro_v}Nitro Boost{}",
            "and {T:j_hallucination,C:common,E:2}Hallucination{}"
        }
    },

    unlocked = true,
    discovered = true,

    config = { vouchers = {"v_mlnc_turbo_v", "v_mlnc_nitro_v"}},
    loc_vars = function(self, info_queue, center)
        return { vars = {}}
    end,

    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                local card = create_card(nil, G.jokers, nil, nil, nil, nil, 'j_hallucination')
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
                G.GAME.joker_buffer = 0
                return true
            end
        }))
    end
}

-- Savings Deck
SMODS.Back {
    name = "Savings Deck",
    key = "savings",
    atlas = "MilatroModDecks",
    pos = {x = 0, y = 0},

    loc_txt = {
        name = "Savings Deck",
        text = {
            "Start run with",
            "{C:money,T:v_seed_money}Seed Money{}, {C:money,T:v_money_tree}Money Tree{}",
            "and {T:c_hermit,C:tarot}Hermit{}. Extra {C:blue}hands{}",
            "earn no extra money"
        }
    },

    unlocked = true,
    discovered = true,

    config = { vouchers = {"v_seed_money", "v_money_tree"}},
    loc_vars = function(self, info_queue, center)
        return { vars = {}}
    end,

    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                local card = create_card(nil, G.consumables, nil, nil, nil, nil, 'c_hermit')
                card:add_to_deck()
                G.consumeables:emplace(card)
                return true
            end
        }))
    end,

    calculate = function(self, back, context)
        if context.end_of_round then
            G.GAME.current_round.hands_left = 0
        end
    end
}