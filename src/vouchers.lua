SMODS.Atlas {
	-- Key for code to find it with
	key = "MilatroMod",
	-- The name of the file, for the code to pull the atlas from
	path = "MilatroJokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

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

--reroll hook
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

-- Reconstruction
SMODS.Voucher{
  key = "reconstruction",
  atlas = "MilatroMod",
  pos = { x = 0, y = 0 },
  loc_txt = {
    name = "Reconstruction",
    text = {
      "Boss Blind size is 175%",
      "of small blind"
    }
  },

  cost = 10,

  unlocked = true,
  discovered = true,

  loc_vars = function(self, info_queue)
    return { vars = {} }
  end,

  redeem = function(self, card)
    for k,v in pairs(G.P_BLINDS) do
      if G.P_BLINDS[k].boss ~= nil then
        G.P_BLINDS[k].mult = G.P_BLINDS[k].mult * 0.875
      end
    end
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
      "Boss Blind size is 150%",
      "of small blind"
    }
  },

  cost = 10,

  unlocked = true,
  discovered = true,

  loc_vars = function(self, info_queue)
    return { vars = {} }
  end,

  redeem = function(self, card)
    for k,v in pairs(G.P_BLINDS) do
      if G.P_BLINDS[k].boss ~= nil then
        G.P_BLINDS[k].mult = G.P_BLINDS[k].mult * 0.85714285714
      end
    end
  end,

  requires = {'v_mlnc_reconstruction'}
}

local hook_start_run = Game.start_run
function Game:start_run(args)
  if G.GAME.used_vouchers.v_mlnc_deconstruction then
    for k,v in pairs(G.P_BLINDS) do
      if G.P_BLINDS[k].boss ~= nil then
        G.P_BLINDS[k].mult = G.P_BLINDS[k].mult * (1/0.85714285714) * (1/0.875)
      end
    end
  elseif G.GAME.used_vouchers.v_mlnc_reconstruction then
    for k,v in pairs(G.P_BLINDS) do
      if G.P_BLINDS[k].boss ~= nil then
        G.P_BLINDS[k].mult = G.P_BLINDS[k].mult * (1/0.875)
      end
    end
  end
  hook_start_run(self, args)
end

