-- Turbo Boost
SMODS.Voucher{
    key = "turbo_v",
    atlas = "MilatroMod",
    pos = { x = 0, y = 0},
    loc_txt = {
        name = "Turbo Boost",
        text = {
            "{C:attention}+1{} Booster pack",
            "available in the shop"
        }
    },

    cost = 10,

    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,

    redeem = function(self, card)
        SMODS.change_booster_limit(1)
    end
}

-- Nitro Boost
G.FUNCS.reroll_shop = function(e) 
  stop_use()
  G.CONTROLLER.locks.shop_reroll = true
  if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end
  if G.GAME.current_round.reroll_cost > 0 then 
    inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
    inc_career_stat('c_shop_rerolls', 1)
    ease_dollars(-G.GAME.current_round.reroll_cost)
  end
  G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
        local final_free = G.GAME.current_round.free_rerolls > 0
        G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
        G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1

        calculate_reroll_cost(final_free)
        for i = #G.shop_jokers.cards,1, -1 do
          local c = G.shop_jokers:remove_card(G.shop_jokers.cards[i])
          c:remove()
          c = nil
        end

        play_sound('coin2')
        play_sound('other1')

        if G.GAME.used_vouchers.v_mlnc_nitro_v and #G.shop_booster.cards < 1 then
          G.GAME.current_round.used_packs[1] = get_pack('shop_pack').key
          local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
          G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[1]], {bypass_discovery_center = true, bypass_discovery_ui = true})
          create_shop_card_ui(card, 'Booster', G.shop_booster)
          card.ability.booster_pos = 1
          card:start_materialize()
          G.shop_booster:emplace(card)
        end
        
        for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
          local new_shop_card = create_card_for_shop(G.shop_jokers)
          G.shop_jokers:emplace(new_shop_card)
          new_shop_card:juice_up()
        end
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.3,
      func = function()
      G.E_MANAGER:add_event(Event({
        func = function()
          G.CONTROLLER.interrupt.focus = false
          G.CONTROLLER.locks.shop_reroll = false
          G.CONTROLLER:recall_cardarea_focus('shop_jokers')
          for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({reroll_shop = true})
          end
          return true
        end
      }))
      return true
    end
  }))
  G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end

SMODS.Voucher{
    key = "nitro_v",
    atlas = "MilatroMod",
    pos = { x = 0, y = 0},
    loc_txt = {
        name = "Nitro Boost",
        text = {
            "Every reroll also restocks {C:attention}1{}",
            "Booster Pack, up to {C:attention}1{}"
        }
    },

    cost = 10,

    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,

    requires = {'v_mlnc_turbo_v' }
}

-- Reconstruction
SMODS.Voucher{
  key = "reconstruction",
  atlas = "MilatroMod",
  pos = { x = 0, y = 0 },
  loc_txt = {
    name = "Reconstruction",
    text = {
      "When {C:attention}Boss Blind{} is selected, reduce",
      "the scoring size to {C:mult}X1.75{} of {C:attention}Small Blind{}"
    }
  },

  cost = 10,

  unlocked = true,
  discovered = true,

  loc_vars = function(self, info_queue)
    return { vars = {} }
  end
}
-- Deconstruction
SMODS.Voucher{
  key = "deconstruction",
  atlas = "MilatroMod",
  pos = { x = 0, y = 0 },
  loc_txt = {
    name = "Deconstruction",
    text = {
      "When {C:attention}Boss Blind{} is selected, reduce",
      "the scoring size to {C:mult}X1.5{} of {C:attention}Small Blind{}"
    }
  },

  cost = 10,

  unlocked = true,
  discovered = true,

  loc_vars = function(self, info_queue)
    return { vars = {} }
  end,

  requires = {'v_mlnc_reconstruction'}
}


function Blind:set_blind(blind, reset, silent)
    if not reset then
        self.config.blind = blind or {}
        self.name = blind and blind.name or ''
        self.dollars = blind and blind.dollars or 0
        self.sound_pings = self.dollars + 2
        if G.GAME.modifiers.no_blind_reward and G.GAME.modifiers.no_blind_reward[self:get_type()] then self.dollars = 0 end
        self.debuff = blind and blind.debuff or {}
        self.pos = blind and blind.pos
        self.mult = blind and blind.mult or 0

        --added part
        if self:get_type() == 'Boss' then
          if G.GAME.used_vouchers.v_mlnc_deconstruction then
            self.mult = blind.mult * (3/4)
          elseif G.GAME.used_vouchers.v_mlnc_reconstruction then
        self.mult = blind.mult * (7/8)
          end
        end

        self.disabled = false
        self.discards_sub = nil
        self.hands_sub = nil
        self.boss = blind and not not blind.boss
        self.blind_set = false
        self.triggered = nil
        self.prepped = true
        self:set_text()

        G.GAME.last_blind = G.GAME.last_blind or {}
        G.GAME.last_blind.boss = self.boss
        G.GAME.last_blind.name = self.name

        if blind and blind.name then
            self:change_colour()
        else
            self:change_colour(G.C.BLACK)
        end

        self.chips = get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling
        self.chip_text = number_format(self.chips)

        if not blind then self.chips = 0 end

        G.GAME.current_round.dollars_to_be_earned = self.dollars > 0 and (string.rep(localize('$'), self.dollars)..'') or ('')
        G.HUD_blind.alignment.offset.y = -10
        G.HUD_blind:recalculate(false)

        if blind and blind.name and blind.name ~= '' then 
            self:alert_debuff(true)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.05,
                blockable = false,
                func = (function()
                        G.HUD_blind:get_UIE_by_ID("HUD_blind_name").states.visible = false
                        G.HUD_blind:get_UIE_by_ID("dollars_to_be_earned").parent.parent.states.visible = false
                        G.HUD_blind.alignment.offset.y = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        blockable = false,
                        func = (function()
                            G.HUD_blind:get_UIE_by_ID("HUD_blind_name").states.visible = true
                            G.HUD_blind:get_UIE_by_ID("dollars_to_be_earned").parent.parent.states.visible = true
                            G.HUD_blind:get_UIE_by_ID("dollars_to_be_earned").config.object:pop_in(0)
                            G.HUD_blind:get_UIE_by_ID("HUD_blind_name").config.object:pop_in(0)
                            G.HUD_blind:get_UIE_by_ID("HUD_blind_count"):juice_up()
                            self.children.animatedSprite:set_sprite_pos(self.config.blind.pos)
                            self.blind_set = true
                            G.ROOM.jiggle = G.ROOM.jiggle + 3
                            if not reset and not silent then
                                self:juice_up()
                                if blind then play_sound('chips1', math.random()*0.1 + 0.55, 0.42);play_sound('gold_seal', math.random()*0.1 + 1.85, 0.26)--play_sound('cancel')
                                end
                            end
                            return true
                        end)
                    }))
                    return true
                end)
            }))
        end


        self.config.h_popup_config ={align="tm", offset = {x=0,y=-0.1},parent = self}
    end

    if self.name == 'The Eye' and not reset then
        self.hands = {
            ["Flush Five"] = false,
            ["Flush House"] = false,
            ["Five of a Kind"] = false,
            ["Straight Flush"] = false,
            ["Four of a Kind"] = false,
            ["Full House"] = false,
            ["Flush"] = false,
            ["Straight"] = false,
            ["Three of a Kind"] = false,
            ["Two Pair"] = false,
            ["Pair"] = false,
            ["High Card"] = false,
        }
    end
    if self.name == 'The Mouth' and not reset then
        self.only_hand = false
    end
    if self.name == 'The Fish' and not reset then 
        self.prepped = nil
    end
    if self.name == 'The Water' and not reset then 
        self.discards_sub = G.GAME.current_round.discards_left
        ease_discard(-self.discards_sub)
    end
    if self.name == 'The Needle' and not reset then 
        self.hands_sub = G.GAME.round_resets.hands - 1
        ease_hands_played(-self.hands_sub)
    end
    if self.name == 'The Manacle' and not reset then
        G.hand:change_size(-1)
    end
    if self.name == 'Amber Acorn' and not reset and #G.jokers.cards > 0 then
        G.jokers:unhighlight_all()
        for k, v in ipairs(G.jokers.cards) do
            v:flip()
        end
        if #G.jokers.cards > 1 then 
            G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
                G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                delay(0.15)
                G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                delay(0.15)
                G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
                delay(0.5)
            return true end })) 
        end
    end

    --add new debuffs
    for _, v in ipairs(G.playing_cards) do
        self:debuff_card(v)
    end
    for _, v in ipairs(G.jokers.cards) do
        if not reset then self:debuff_card(v, true) end
    end

    G.ARGS.spin.real = (G.SETTINGS.reduced_motion and 0 or 1)*(self.config.blind.boss and (self.config.blind.boss.showdown and 0.5 or 0.25) or 0)
end