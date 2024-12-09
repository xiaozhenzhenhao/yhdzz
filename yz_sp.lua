local extension = Package:new("yz_sp")

extension.extensionName = "yhdzz"
Fk:loadTranslationTable{
    -- 翻译扩展包
    ["yz_sp"] = "约战sp",
   
  }
  Fk:loadTranslationTable{
    ["sp"] = "SP",
   
  }
-- sp狂三
-- sp时崎狂三		最恶精灵		3/3
-- 食时	锁定技，游戏开始时，你额外摸3张牌并将3张手牌放置在你的武将牌上，称为「时」。
-- 你对其他角色造成伤害后，你需将该角色区域内至多x张牌置于你的武将牌上，称为「时」。（x为该次伤害的伤害量）。
-- 摸牌阶段，你额外摸y张牌（y为你的「时」的数量的一半，向上取整）。
-- 你的回合内，每当你需使用或打出牌时，你需选择以下一项执行：
-- 		1、移去一张「时」；
-- 		2、弃置一张手牌；
-- 		3、失去一点体力。
-- 		若你的武将牌上没有「时」，你的回合外，非濒死状态下，你不能使用或打出手牌且受到的伤害+1(data.damage = data.damage + 1)。你最多拥有12张「时」。
		
-- 三番	每轮限一次，出牌阶段，你可以选择以下一项执行：
-- 		1、移去2张「时」，你令一名角色本回合非锁定技失效且不能使用或打出与这些「时」花色相同的牌。
-- 		2、移去4张「时」，你令一名角色回复2点体力。
-- 		3、移去7张「时」，你令一名角色休整一轮。
-- 		4、移去12张「时」，你令所有角色本回合内所有技能失效，弃置其区域内的所有牌，复原并重置武将牌，然后洗牌，所有角色回复体力至上限并摸4张牌。
--     若如此做，你结束出牌阶段，跳过弃牌阶段并翻面。
local yz_sp_kuangsan=General:new(extension,"sp__yz_sp_kuangsan","god",3,3,General.Female)
Fk:loadTranslationTable{
    ["sp__yz_sp_kuangsan"] = "SP狂三",
    ["#sp__yz_sp_kuangsan"] = "最恶精灵",
    ["designer:sp__yz_sp_kuangsan"] = "橘公司",
    ["cv:sp__yz_sp_kuangsan"] = "",
    ["illustrator:sp__yz_sp_kuangsan"] = "Tsunako",
    -- 
    ["@sp_time"]="时",
    ["yz_sp_kuangsan_eatTime"] = "食时",
    ["#yz_sp_kuangsan_eatTime_demage"] = "食时",
    ["#yz_sp_kuangsan_eatTime_gatcard"] = "食时",
    ["#yz_sp_kuangsan_eatTime_phase"] = "食时",
    ["#yz_sp_kuangsan_eatTime_demaged"]="食时",
    ["#yz_sp_kuangsan_eatTime_prohibit"]="食时",
    [":yz_sp_kuangsan_eatTime"] = "锁定技，游戏开始时，你额外摸3张牌并将3张手牌放置在你的武将牌上，称为「时」。<br>"..
                                  "你对其他角色造成伤害后，你需将该角色区域内至多x张牌置于你的武将牌上，称为「时」。（x为该次伤害的伤害量）。<br>"..
                                  "摸牌阶段，你额外摸y张牌（y为你的「时」的数量的一半，向上取整）。<br>"..
                                  "你的回合内，每当你需使用或打出牌时，你需选择以下一项执行：<br>"..
                                  "1、移去一张「时」<br>"..
                                  "2、弃置一张手牌；<br>"..
                                  "3、失去一点体力。<br>"..
                                  "若你的武将牌上没有「时」，你的回合外，非濒死状态下，你不能使用或打出手牌且受到的伤害+1。<br>"..
                                  "你最多拥有12张「时」。",
    ["yz_sp_kuangsan_eatTime_phase_1"]="移去一张「时」",
    ["yz_sp_kuangsan_eatTime_phase_2"]="弃置一张手牌",
    ["yz_sp_kuangsan_eatTime_phase_3"]="失去一点体力",
    ["yz_sp_kuangsan_sanfan"] = "三番",
    [":yz_sp_kuangsan_sanfan"] = "每轮限一次，出牌阶段，你可以选择以下一项执行：<br>"..
                                 "1、移去2张「时」，你令一名角色本回合非锁定技失效且不能使用<br>"..
                                 "2、移去4张「时」，你令一名角色回复2点体力。<br>"..
                                 "3、移去7张「时」，你令一名角色休整一轮。<br>"..
                                 "4、移去12张「时」，你令所有角色本回合内所有技能失效，弃置其区域内的所有牌，复原并重置武将牌，然后洗牌，所有角色回复体力至上限并摸4张牌。",
    ["cancel"]="取消",
    [":cancel"]="取消",
    ["yz_sp_kuangsan_two"]="二之弹",
    [":yz_sp_kuangsan_two"]="移去2张「时」，你令一名角色本回合非锁定技失效且不能使用或打出与这些「时」花色相同的牌。",
    ["yz_sp_kuangsan_foue"]="四之弹",
    [":yz_sp_kuangsan_foue"]="移去4张「时」，你令一名角色回复2点体力。<br>",
    ["yz_sp_kuangsan_seven"]="七之弹",
    [":yz_sp_kuangsan_seven"]="移去7张「时」，你令一名角色休整一轮。",
    ["yz_sp_kuangsan_twelve"]="十二之弹",
    [":yz_sp_kuangsan_twelve"]="移去12张「时」，你令所有角色本回合内所有技能失效，弃置其区域内的所有牌，复原并重置武将牌，然后洗牌，所有角色回复体力至上限并摸4张牌。",
   
  }
local yz_sp_kuangsan_eatTime=fk.CreateTriggerSkill{
    name="yz_sp_kuangsan_eatTime",
    frequency=Skill.Compulsory,
    events={fk.GameStart},
    can_trigger=function (self, event, target, player, data)
        return player:hasSkill(self.name)
               
    end,
    on_cost=function (self, event, target, player, data)
        local room =player.room
        local card =room:drawCards(player,3,self.name,"top",{"@sp_time"})
        player:addToPile("@sp_time",card,true,self.name)
    end,
}
local yz_sp_kuangsan_eatTime_demage=fk.CreateTriggerSkill{
    name="#yz_sp_kuangsan_eatTime_demage",
    frequency=Skill.Compulsory,
    events={fk.Damage},
    can_trigger=function (self, event, target, player, data)
        return player:hasSkill(self.name)
               and target==player
    end,
    on_cost=function (self, event, target, player, data)
        local room =player.room
        local shi=#player:getPile("@sp_time")
        local to=data.to
        local num=data.damage
        if data.damage == 1 and shi <12 then
            local cardId=room:askForCardsChosen(player,data.to,1,1,"he",self.name,"选择牌")
            player:addToPile("@sp_time",cardId,true,self.name) 
        elseif data.damage >1 and shi < 12-data.damage then
            local cardId=room:askForCardsChosen(player,data.to,data.damage,data.damage,"he",self.name,"选择牌")
            player:addToPile("@sp_time",cardId,true,self.name) 
        elseif data.damage >1 and shi>12-data.damage then
            local cardId=room:askForCardsChosen(player,data.to,12-shi,12-shi,"he",self.name,"选择牌")
            player:addToPile("@sp_time",cardId,true,self.name) 
        end
        return true
    end,
    on_use=function (self, event, target, player, data)

    end
    
}

local yz_sp_kuangsan_eatTime_gatcard=fk.CreateTriggerSkill{
    name="#yz_sp_kuangsan_eatTime_gatcard",
    frequency=Skill.Compulsory,
    events={fk.TurnStart},
    can_trigger=function (self, event, target, player, data)
        return player:hasSkill(self.name)
               and target==player
               and  #player:getPile("@sp_time")>0
    end,
    on_use=function (self, event, target, player, data)
        local room=player.room
        local shi=#player:getPile("@sp_time")
        local getCardNum=shi//2
        local getCardNumEn=shi%2
        if getCardNumEn >0 then
            getCardNum=getCardNum+1
        end
        room:drawCards(player,getCardNum,self.name)
    end
}
local yz_sp_kuangsan_eatTime_phase=fk.CreateTriggerSkill{
    name="#yz_sp_kuangsan_eatTime_phase",
    frequency=Skill.Compulsory,
    events={fk.PreCardUse},
    can_trigger=function (self, event, target, player, data)
        return player:hasSkill(self.name)
               and target==player
               and player.phase == Player.Play
    end,
    on_cost=function (self, event, target, player, data)
        local room=player.room
        local choose={}
        if #player:getCardIds("h")>0 then
            choose={"yz_sp_kuangsan_eatTime_phase_1","yz_sp_kuangsan_eatTime_phase_2","yz_sp_kuangsan_eatTime_phase_3"}
        else
            choose={"yz_sp_kuangsan_eatTime_phase_1","yz_sp_kuangsan_eatTime_phase_3"}
        end
       
        local selected=room:askForChoice(player,choose,self.name,"选择一个效果",false,choose)
        self.cost_data = selected
        return true
    end,
    on_use=function (self, event, target, player, data)
        local room=player.room
        local selected=self.cost_data
        if selected=="yz_sp_kuangsan_eatTime_phase_1" then
            local flag={}
            flag.card_data ={{"@sp_time",player:getPile("@sp_time")}}
            local cardIds=room:askForCardsChosen(player,player,1,1,flag,self.name,"弃置一张【时】")
            room:throwCard(cardIds,self.name,player,player)
        elseif selected=="yz_sp_kuangsan_eatTime_phase_2" then
            local discard=room:askForDiscard(player,1,1,false,self.name,false,"","选择一张牌")
        elseif selected=="yz_sp_kuangsan_eatTime_phase_3" then
            room:loseHp(player,1,self.name)
        end
    end
}
local yz_sp_kuangsan_eatTime_demaged=fk.CreateTriggerSkill{
    name="#yz_sp_kuangsan_eatTime_demaged",
    frequency=Skill.Compulsory,
    events={fk.Damaged},
    can_trigger=function (self, event, target, player, data)
        return player:hasSkill(self.name)
               and target~=player
               and #player:getPile("@sp_time") == 0
    end,
    on_use=function (self, event, target, player, data)
        data.damage=data.damage+1
    end
}
-- local yz_sp_kuangsan_eatTime_prohibit=fk.CreateProhibitSkill{
--     name="#yz_sp_kuangsan_eatTime_prohibit",
--     frequency=Skill.Compulsory,
--     prohibit_use=function (self, player, card)
--         return player:hasSkill(self.name)
--                and not player.dying
--                and not player.phase == Player.Play
--     end
-- }
local yz_sp_kuangsan_sanfan=fk.CreateTriggerSkill{
    name="yz_sp_kuangsan_sanfan",
    events={fk.EventPhaseStart},
    can_trigger=function (self, event, target, player, data)
        return player:hasSkill(self.name)
               and target==player
               and player.phase == Player.Play
               and player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
               and #player:getPile("@sp_time")>=2
      end,
    on_cost=function (self, event, target, player, data)
        local room=player.room
        local shi=#player:getPile("@sp_time")
        local choose={"yz_sp_kuangsan_two","cancel"}
        if shi ==4 then
            choose={"yz_sp_kuangsan_two","yz_sp_kuangsan_foue","cancel"}
        elseif shi >=7 and shi <12 then
            choose={"yz_sp_kuangsan_two","yz_sp_kuangsan_foue","yz_sp_kuangsan_seven","cancel"}
        elseif shi ==12 then   
            choose={"yz_sp_kuangsan_two","yz_sp_kuangsan_foue","yz_sp_kuangsan_seven","yz_sp_kuangsan_twelve","cancel"}
        end
        local selected=room:askForChoice(player,choose,self.name,"选择一个效果",true,choose)
        if selected =="cancel" then
            return false
        end
        self.cost_data = selected
        return true
    end,
    on_use=function (self, event, target, player, data)
        local room=player.room
        local selected=self.cost_data
        local flag={}
        flag.card_data ={{"@sp_time",player:getPile("@sp_time")}}
        local alivePlayersIds=table.map(room:getAlivePlayers(), Util.IdMapper)
        if selected=="yz_sp_kuangsan_two" then
            local cardIds=room:askForCardsChosen(player,player,2,2,flag,self.name,"二之弹消耗【时】*2")
            room:throwCard(cardIds,self.name,player,player)
            local toId =room:askForChoosePlayers(player,alivePlayersIds,1,1,"",self.name,false,false)
            room:addPlayerMark(room:getPlayerById(toId[1]), MarkEnum.UncompulsoryInvalidity .. "-turn")
        elseif selected=="yz_sp_kuangsan_foue" then
            local cardIds=room:askForCardsChosen(player,player,4,4,flag,self.name,"四之弹消耗【时】*4")
            room:throwCard(cardIds,self.name,player,player)
            local toId =room:askForChoosePlayers(player,alivePlayersIds,1,1,"",self.name,false,false)
            room:recover{
                who = room:getPlayerById(toId[1]) ,
                num = 1,
                recoverBy = player,
                skillName = self.name
            }
        elseif selected=="yz_sp_kuangsan_seven" then
            local cardIds=room:askForCardsChosen(player,player,7,7,flag,self.name,"七之弹消耗【时】*7")
            room:throwCard(cardIds,self.name,player,player)
            local toId =room:askForChoosePlayers(player,alivePlayersIds,1,1,"",self.name,false,false)
            room:setPlayerRest(room:getPlayerById(toId[1]),1)

        elseif selected=="yz_sp_kuangsan_twelve" then
            local cardIds=room:askForCardsChosen(player,player,12,12,flag,self.name,"十二之弹消耗【时】*12")
            room:throwCard(cardIds,self.name,player,player)
            for index, alivePlayersId in ipairs(alivePlayersIds) do
                local alivePlayers=room:getPlayerById(alivePlayersId)
                -- room:invalidateSkill(alivePlayers, self.name, "-turn")
                alivePlayers:onAllSkillLose()
                -- 弃牌
                alivePlayers:throwAllCards("hej")
                alivePlayers:setChainState(false)
                room:recover{
                    who = alivePlayers,
                    num = alivePlayers.maxHp,
                    recoverBy = player,
                    skillName = self.name
                }
                alivePlayers:drawCards(4,self.name,"top")
            end
               -- 洗牌
                room:shuffleDrawPile()
        end
    end
}
yz_sp_kuangsan_eatTime:addRelatedSkill(yz_sp_kuangsan_eatTime_demage)
yz_sp_kuangsan_eatTime:addRelatedSkill(yz_sp_kuangsan_eatTime_gatcard)
yz_sp_kuangsan_eatTime:addRelatedSkill(yz_sp_kuangsan_eatTime_phase)
yz_sp_kuangsan_eatTime:addRelatedSkill(yz_sp_kuangsan_eatTime_demaged)
-- yz_sp_kuangsan_eatTime:addRelatedSkill(yz_sp_kuangsan_eatTime_prohibit)
yz_sp_kuangsan:addSkill(yz_sp_kuangsan_eatTime)
yz_sp_kuangsan:addSkill(yz_sp_kuangsan_sanfan)
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- SP五河士道


return extension