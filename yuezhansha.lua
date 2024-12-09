
local extension = Package:new("yuezhansha")
local U = require "packages/utility/utility"
extension.extensionName = "yhdzz"

Fk:loadTranslationTable{
  -- 翻译扩展包
  ["yuezhansha"] = "约战杀",
 
}

-- 角色    
-- 角色名统一  yz_+角色拼音 ，在角色上分注释加上角色中文名称以及作者（谁写的）
-- 构造函数，不可随意调用。
-- @param package Package @ 武将所属包
-- @param name string @ 武将名字
-- @param kingdom string @ 武将所属势力
-- @param hp integer @ 武将初始体力
-- @param maxHp integer @ 武将初始最大体力
-- @param gender Gender @ 武将性别   General.Male（男性），General.Female（女性） ,General.Agender(无性别)，General.Bigender（双性别）

-- data.to是id，data.tos是id表 

-- 技能  命名方式   yz_角色名_技能名
-- 1. fk.CreateTriggerSkill方法
--    name 技能名字
--    anim_type（动画技能类型): control（控制）、masochism（受虐？）、defensive（守势/防御）、drawcard（摸牌）
--    events（技能触发事件）: DrawNCards(绘卡/发牌？)
--    on_use 本技能使用者触发事件方法  function(self, event, target, player, data) 

-- 牌的花色  黑桃spade,红桃heart,方片diamond,梅花club

-- table.map(room:getOtherPlayers(player), Util.IdMapper)
-------------------------------------------------------------------------------------------------------------------------------------
-- 折纸鸢一  @星鸿
local zz_tianyi = fk.CreateDistanceSkill{
  name = "tianyi",
  frequency = Skill.Compulsory,
  correct_func = function(self, from, to)
    if from:hasSkill(self) then
      return -999
    end
  end,
}
local zz_paoguan = fk.CreateTriggerSkill{
  name = "paoguan",
  events = {fk.Damage},
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and data.card
    and data.to ~= player and not data.to.dead and not data.to:isAllNude()
  end,
  on_cost = function(self, event, target, player, data)
    return target.room:askForSkillInvoke(player, self.name, data, "#zz_paoguan-invoke::" .. data.to.id)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = data.to
    local cid = room:askForCardChosen(player, to, "hej", self.name)
    room:throwCard({cid}, self.name, to, player)
    local card = Fk:getCardById(cid)
    if card.type == Card.TypeBasic then
      player:drawCards(1)
    end
  end,
}
local zz_rilun = fk.CreateActiveSkill{
  name = "rilun",
  frequency = Skill.Limited,
  can_use = function(self, player)
    return player:usedSkillTimes(self.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askForSkillnvoke(player, self.name, nil, {cid})
  end,
  on_use = function(self, room, effect)
    local player = room:getPlayerById(effect.from)
    local targets = room:getOtherPlayers(player, true)
    room:doIndicate(effect.from, table.map(targets, Util.IdMapper))
    table.forEach(targets, function(p)
      if not p.dead then room:damage{ from = player, to = p, damage = 1, skillName = self.name } end
    end)
  end,
}
local yuanyizhezhi = General:new(extension,"yuanyizhezhi","god",3,4,General.Female)
yuanyizhezhi:addSkill(zz_tianyi)
yuanyizhezhi:addSkill(zz_paoguan)
yuanyizhezhi:addSkill(zz_rilun)
Fk:loadTranslationTable{
  ["yuanyizhezhi"] = "鸢一折纸",
  ["#yuanyizhezhi"] = "天使",
  ["designer:yuanyizhezhi"] = "橘公司",
  ["cv:yuanyizhezhi"] = "富樫美铃",
  ["illustrator:yuanyizhezhi"] = "Tsunako",
  ["tianyi"] = "天翼",
  [":tianyi"] = "锁定技，你计算与其他角色的距离始终为1",
  ["paoguan"] = "炮冠",
  [":paoguan"] = "当你对一名其他角色造成伤害后，你可弃置其区域里的一张牌，如果这张牌是基本牌，你摸一张牌。",
  ["#zz_paoguan-invoke"] = "炮冠:你弃置 %dest 区域里的一张牌",
  ["rilun"] = "日轮",
  [":rilun"] = "限定技：出牌阶段，你可以弃置所有牌，对所有其他角色各造成一点伤害。"
}
-- ----------------------------------------------------------------------------------------------------------------------------------
-- 本条二亚  @贞酱
local yz_erya = General:new(extension, "yz_erya", "god", 4,4,General.Female)
-- 二亚信息翻译
Fk:loadTranslationTable{
  ["yz_erya"] = "本条二亚",
  ["#yz_erya"] = "老阿姨",
  ["designer:yz_erya"] = "贞酱",
  ["cv:yz_erya"] = "不知道",
  ["illustrator:yz_erya"] = "不是我",
}
-- 创建技能

-- 添加技能
-- erya:addSkill()
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 时崎狂三 
-- 时影	你的准备阶段，你可以进行一次判定，若结果为:
-- 		黑色，则你将本次判定牌置于武将牌上,称为「影」，然后你可以重复此流程；
-- 		红色，你获得此判定牌。
-- 		你的出牌阶段内，你可以移去任意数量的「影」并获得x点攻击距离,本回合内你的下一次【杀】可以额外选择至多x-1名角色为目标，
--    若你选择的目标数量不大于x－3，则你令此【杀】造成的伤害＋1且不可被【闪】响应(x为你弃置的「影」的数量) ，
--    此【杀】结算结束后，你可以从弃牌堆获得一张本回合弃置的「影」牌。
		
-- 倒流	限定技，当你的武将牌上「影」数量不小于十二时，你可以移去12枚「影」，
-- 若如此做，你令一名角色体力上限+1，然后将体力恢复至上限，并将手牌摸至体力上限，然后你对一名角色造成三点伤害。

local yz_kuangsan=General:new(extension,"yz_kuangsan","god",3,4,General.Female)
Fk:loadTranslationTable{
  ["yz_kuangsan"] = "时崎狂三",
  ["#yz_kuangsan"] = "梦魇",
  ["designer:yz_kuangsan"] = "好多人都设了，当时人挺多的",
  ["cv:yz_kuangsan"] = "不知道",
  ["illustrator:yz_kuangsan"] = "不是我",
  -- 技能翻译
  ["yz_kuangsan_shiying"]="时影",
  ["#yz_kuangsan_shiying_init"]="时影",
  ["#yz_kuangsan_shiying_distance"]="时影",
  ["#yz_kuangsan_shiying_dan"]="时影",
  ["#yz_kuangsan_shiying_sha"]="时影",
  [":yz_kuangsan_shiying"]="你的准备阶段，你可以进行一次判定，若结果为:<br>"..
                           "黑色，则你将本次判定牌置于武将牌上,称为「影」，然后你可以重复此流程；<br>"..
                           "红色，你获得此判定牌。<br>"..
                           "你的出牌阶段内，你可以移去任意数量的「影」并获得x点攻击距离,本回合内你的下一次【杀】可以额外选择至多x-1名角色为目标，"..
                           "若你选择的目标数量不大于x－3，则你令此【杀】造成的伤害＋1且不可被【闪】响应(x为你弃置的「影」的数量) ，"..
                           "此【杀】结算结束后，你可以从弃牌堆获得一张本回合弃置的「影」牌。",
  ["@yz_shiying"]="影",
  ["@yz_dan"]="弹",
  ["@@yz_dan"]="拥有【弹】时可额外选择的目标",
  ["@yz_sha"]="喰",
  ["@@yz_sha"]="攻击距离",
  ["yz_kuangsan_daoliu"]="倒流",
  [":yz_kuangsan_daoliu"]="限定技，当你的武将牌上「影」数量不小于十二时，你可以移去12枚「影」，"..
                          "若如此做，你令一名角色体力上限+1，然后将体力恢复至上限，并将手牌摸至体力上限，然后你对一名角色造成三点伤害。",
}
local yz_kuangsan_shiying_init=fk.CreateTriggerSkill{
    name="#yz_kuangsan_shiying_init",
    events={fk.TurnStart},
    can_trigger=function (self, event, target, player, data)
      return player:hasSkill(self.name)
             and target == player
    end,
    on_use=function (self, event, target, player, data)
      local room=player.room
      while true do
        local judge = {
          who = player,
          reason = self.name,
          pattern = ".",
        }
        room:judge(judge)
        if judge.card and judge.card.color == Card.Black  then
          player:addToPile("@yz_shiying",judge.card,true,self.name)
        else
          room:obtainCard(player,judge.card,true)
          break
        end
      end
    end
}
local yz_kuangsan_shiying=fk.CreateActiveSkill{
  name="yz_kuangsan_shiying",
  can_use=function (self, player, card, extra_data)
    return player:hasSkill(self.name)
           and player.phase == Player.Play 
           and #player:getPile("@yz_shiying")>0
  end,
  on_use=function (self, room, data)
    local from=room:getPlayerById(data.from)
    local ying=#from:getPile("@yz_shiying")
    local flag={}
    flag.card_data ={{"@yz_shiying",from:getPile("@yz_shiying")}}
    local discardYing= room:askForCardsChosen(from,from,1,ying,flag,self.name,"弃置任意数量的【影】")
    room:throwCard(discardYing,self.name,from,from)
    room:addPlayerMark(from,"@yz_dan",#discardYing)
    room:addPlayerMark(from,"@yz_sha",#discardYing)
  end
}
-- 清除【弹】的标记
local yz_kuangsan_shiying_dan=fk.CreateTriggerSkill{
  name="#yz_kuangsan_shiying_dan",
  refresh_events={fk.AfterTurnEnd},
  can_refresh=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and player:getMark("@yz_dan")>0
  end,
  on_refresh=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_dan",0)
  end
}
-- 根据杀数量增加攻击距离
local yz_kuangsan_shiying_distance=fk.CreateDistanceSkill{
  name = "#yz_kuangsan_shiying_distance",
  correct_func = function(self, from, to)
    local dan=from:getMark("yz_sha")
    if from:hasSkill(self) and dan>0 then
      return -dan
    end
  end,
}
-- 有杀时强化杀
local yz_kuangsan_shiying_sha=fk.CreateTriggerSkill{
  name="#yz_kuangsan_shiying_sha",
  events={fk.AfterCardTargetDeclared},
  can_trigger=function (self, event, target, player, data)
    -- local room=player.room
    -- local otherPlayersIds=table.map(room:getOtherPlayers(player), Util.IdMapper)
    return player:hasSkill(self.name)
           and target==player
          --  and #otherPlayersIds > 1
           and data.card.trueName=="slash"
           and player:getMark("@yz_dan")> 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local otherPlayers = room:getOtherPlayers(player)
    local otherPlayersIds={}
    local sha=player:getMark("@yz_sha")
    for index, otherPlayer in ipairs(otherPlayers) do
      if otherPlayer.id ~= data.tos[1][1]  then
        table.insert(otherPlayersIds,otherPlayer.id)
      end
    end
    if #otherPlayersIds>0 then
      local extraPlayerId=room:askForChoosePlayers(player,otherPlayersIds,1,sha-1,"可选择额外目标"..sha,self.name,true)
      self.cost_data = extraPlayerId
    else
      self.cost_data=1
   end
    return true
  end,
  on_use=function (self, event, target, player, data)
    -- "若你选择的目标数量不大于x－3，则你令此【杀】造成的伤害＋1且不可被【闪】响应(x为你弃置的「影」的数量) ，"
    local room = player.room
    local dan=player:getMark("@yz_dan")
    local targetNum=self.cost_data
    -- 选择了额外目标 且额外目标 < [弹]-3   伤害+1 ，不可响应
    if targetNum ~=1 and #targetNum < dan-3 then
      data.additionalDamage = (data.additionalDamage or 0) + 1
      data.disresponsiveList = table.map(targetNum, Util.IdMapper)
    -- 选择了额外目标 数量为 ：【喰】-1 ，对这些目标造成伤害
    elseif targetNum ~=1 and #targetNum >= dan-3 then
      for index, value in ipairs(targetNum) do
        table.insert(data.tos,{value})
      end
    -- 拥有【弹】，但没有选择目标
    elseif targetNum == 1 then
      data.additionalDamage = (data.additionalDamage or 0) + 1
      table.insert(data.disresponsiveList,data.tos[1][1])
    end
    room:setPlayerMark(player,"@yz_dan",0)
    local card =room:drawCards(player,1,self.name,"top",{"@yz_ying"})
    player:addToPile("@yz_ying",card,true,self.name)
end
}
local yz_kuangsan_daoliu=fk.CreateTriggerSkill{
  name="yz_kuangsan_daoliu",
  frequency=Skill.Limited,
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and #player:getPile("@yz_shiying")>=12
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local flag={}
    flag.card_data ={{"@yz_shiying",player:getPile("@yz_shiying")}}
    local discardYing= room:askForCardsChosen(player,player,12,12,flag,self.name,"弃置任意数量的【影】")
    return true
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    local allPlayers = room:getAlivePlayers()
    local toId=room:askForChoosePlayers(player,allPlayers,1,1,"【The world】",self.name,true)
    local to=room:getPlayerById(toId[1])
    local toCardsNum=#to:getCardIds()
    -- 若如此做，你令一名角色体力上限+1，然后将体力恢复至上限，并将手牌摸至体力上限，然后你对一名角色造成三点伤害。
    to.maxHp=to.maxHp+1
    local maxHP=to.maxHp
    room:recover{
        who =to ,
        num = maxHP,
        recoverBy = player,
        skillName = self.name
    }
    if toCardsNum < maxHP then
      room:drawCards(to,maxHP-toCardsNum,self.name,"top")
    end
    local lostHpToId=room:askForChoosePlayers(player,allPlayers,1,1,"【西内！】",self.name,true)
    local lostHpTo=room:getPlayerById(lostHpToId[1])
    room:damage({
        from = player,
        to = lostHpTo,
        damage = 3,
        damageType = fk.NormalDamage,
        skillName = self.name
    })
  end
}
yz_kuangsan_shiying:addRelatedSkill(yz_kuangsan_shiying_init)
yz_kuangsan_shiying:addRelatedSkill(yz_kuangsan_shiying_dan)
yz_kuangsan_shiying:addRelatedSkill(yz_kuangsan_shiying_distance)
yz_kuangsan_shiying:addRelatedSkill(yz_kuangsan_shiying_sha)
yz_kuangsan:addSkill(yz_kuangsan_daoliu)
yz_kuangsan:addSkill(yz_kuangsan_shiying)
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 四系乃
-- 双生	出牌阶段，你可以失去一点体力，若如此做，你令一名角色回复一点体力。 
local yz_siminai=General:new(extension,"yz_siminai","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_siminai"] = "氷芽川四糸乃",
  ["#yz_siminai"] = "隐居者",
  ["designer:yz_siminai"] = "好多人都设了，当时人挺多的",
  ["cv:yz_siminai"] = "不知道",
  ["illustrator:yz_siminai"] = "不是我",
  -- 技能翻译
  ["yz_siminai_shuangsheng"]="双生",
  [":yz_siminai_shuangsheng"]="出牌阶段，你可以失去一点体力，若如此做，你令一名角色回复一点体力。",
  ["yz_siminai_shuangsheng_choose"]="选择一名玩家回复一点体力",

  ["yz_siminai_bingjie"]="冰洁",
  [":yz_siminai_bingjie"]="出牌阶段限一次，若你的武将牌正面朝上，你可以弃置两张牌并将其中一张交给一名角色，随后翻面，若如此做，你回复一点体力并选择一项：1、令一名未以此法翻面过的其他角色角色翻面；摸两张牌并跳过本回合的弃牌阶段。",
  ["yz_siminai_bingjie_turnover"]="选择一名未翻面角色翻面",
  ["yz_siminai_bingjie_getcards"]="获得两张牌并跳过弃牌阶段",

  ["yz_siminai_dongkai"]="冻铠",
  [":yz_siminai_dongkai"]="锁定技，当你成为其他角色使用普通【杀】、【决斗】、【南蛮入侵】、【万箭齐发】的目标时，若你的武将牌背面朝上，取消之。当你受到火属性伤害时，若你的武将牌背面朝上，此伤害+1。",
}
local yz_siminai_shuangsheng=fk.CreateTriggerSkill{
  name="yz_siminai_shuangsheng",
  events={fk.EventPhaseStart },
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player.phase == Player.Play
           and player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    room:loseHp(player,1,self.name)
    local AllPlayers=room:getAlivePlayers()
    local playersId={}
    for index, Players in ipairs(AllPlayers) do
      table.insert(playersId,Players.id)
    end
    local targetsId =  room:askForChoosePlayers(player,playersId,1,1,"yz_siminai_shuangsheng_choose",self.name,false,false)
    if #targetsId then
      room:recover{
        who = room:getPlayerById(targetsId[1]) ,
        num = 1,
        recoverBy = player,
        skillName = self.name
      }
    end
  end
}
-- 冰洁	出牌阶段限一次，若你的武将牌正面朝上，你可以弃置两张牌并将其中一张交给一名角色，随后翻面，若如此做，你回复一点体力并选择一项：
		-- 1、令一名未以此法翻面过的其他角色角色翻面；
		-- 2、摸两张牌并跳过本回合的弃牌阶段。
local yz_siminai_bingjie=fk.CreateTriggerSkill{
  name="yz_siminai_bingjie",
  events={fk.EventPhaseStart},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and player.phase == Player.Play
           and player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
           and #player:getCardIds("he") > 2
  end,
  -- priority=0,
  on_use =function (self, event, target, player, data)
    local room = player.room
    if player.faceup then
      local cardIds=  room:askForCardsChosen(player,player,2,2,"he",self.name)
      local flag={}
      flag.card_data ={{"one",cardIds}}
      local sendCardId= room:askForCardsChosen(player,player,1,1,flag,self.name)
      local otherPlayersIds=table.map(room:getOtherPlayers(player), Util.IdMapper)
      local toId =room:askForChoosePlayers(player,otherPlayersIds,1,1,"",self.name,false,false)
      local to= room:getPlayerById(toId[1])
      room:throwCard(cardIds,self.name,player,player)
      room:obtainCard(to,sendCardId,true,event,player.id,self.name)
      -- local throwCardId=sendCardId[1]
      -- dbg()
      -- table.remove(cardIds,sendCardId[1])
      player:turnOver()
      room:recover{
        who = player ,
        num = 1,
        recoverBy = player,
        skillName = self.name
      }
      local choose={"yz_siminai_bingjie_turnover","yz_siminai_bingjie_getcards"}
      local selected=room:askForChoice(player,choose,self.name,"",false,choose)
      if selected == "yz_siminai_bingjie_turnover" then
        local bingjie={}
        local otherPlayers=room:getOtherPlayers(player)
        for index, otherPlayer in ipairs(otherPlayers) do
          if otherPlayer:getMark("yz_siminai_bingjie_mark") == 0 then
            table.insert(bingjie,otherPlayer.id)
          end
        end
      local turnPlayerId= room:askForChoosePlayers(player,bingjie,1,1,"",self.name,false,false)
      room:getPlayerById(turnPlayerId[1]):turnOver()
      elseif selected == "yz_siminai_bingjie_getcards" then 
          player:drawCards(2)
          -- 跳过弃牌阶段
          player:skip(Player.Discard)
          -- room:askForDiscard(player,0,0,false,self.name,false,".","",true)
          return true
      end
    end
  end
}
-- 冻铠	锁定技，当你成为其他角色使用普通【杀】、【决斗】、【南蛮入侵】、【万箭齐发】的目标时，若你的武将牌背面朝上，取消之。
-- 当你受到火属性伤害时，若你的武将牌背面朝上，此伤害+1。
local yz_siminai_dongkai=fk.CreateTriggerSkill{
  name="yz_siminai_dongkai",
  frequency = Skill.Compulsory,
  events={fk.TargetConfirmed},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) 
           and target ~= player
          --  and player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
           and (data.card.name == "slash" or data.card.name=="duel" 
           or data.card.name=="savage_assault" or data.card.name=="archery_attack")         
  end,
  on_use =function (self, event, target, player, data)
    if not player.faceup  then
      -- table.insert(data.nullifiedTargets,player.id) 
      AimGroup:cancelTarget(data, player.id)
    end
  end
}
local  yz_siminai_dongkai_fire=fk.CreateTriggerSkill{
  name="#yz_siminai_dongkai_fire",
  frequency = Skill.Compulsory,
  events={fk.DamageInflicted},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
           and target == player
           and data.damageType== fk.FireDamage
  end,
  on_use =function (self, event, target, player, data)
    if not player.faceup  then
      data.damage=data.damage+1
    end
  end
}
yz_siminai_dongkai:addRelatedSkill(yz_siminai_dongkai_fire)
yz_siminai:addSkill(yz_siminai_dongkai)
yz_siminai:addSkill(yz_siminai_bingjie)
yz_siminai:addSkill(yz_siminai_shuangsheng)
-- --------------------------------------------------------------------------------------------------------------------------------
-- 五河琴里 @贞酱
local yz_qinli=General:new(extension,"yz_qinli","god",3,3,General.Female)
Fk:loadTranslationTable{
  -- 名称
  ["yz_qinli"] = "五河琴里",
  -- 称号
  ["#yz_qinli"] = "炎魔",
  -- 设计
  ["designer:yz_qinli"] = "贞酱",
  -- 配音
  ["cv:yz_qinli"] = "不知道",
  -- 画师
  ["illustrator:yz_qinli"] = "不是我",

  ["yz_qinli_yanmo"] = "炎魔",
  [":yz_qinli_yanmo"] = "锁定技，你造成的伤害全部视为火焰伤害。",
  ["#yz_qinlii_msg"] = " %to 【炎魔】造成伤害为火元素伤害 ",

  ["yz_qinli_pohuai"] = "破坏",
  [":yz_qinli_pohuai"] = "破坏	锁定技，当你使用牌指定唯一目标时：1、若该目标与你距离为1且你拥有技能【灼炮】，你失去技能【灼炮】并获得技能【炽斧】；2、若该目标与你的距离大于1且你拥有技能【炽斧】，你失去技能【炽斧】并获得技能【灼炮】。",
  ["#yz_qinli_pohuai_fu"] = " %to 【破坏】切换技能为【炽斧】",
  ["#yz_qinli_pohuai_pao"] = " %to 【破坏】切换技能为【灼炮】",

  ["yz_qinli_chifu"] = "炽斧",
  [":yz_qinli_chifu"] = "锁定技：你的【杀】、【决斗】和【火攻】无视防具且不能被响应。每回合限一次，当你使用火【杀】和【火攻】造成伤害时，你可以选择回复一点体力或摸两张牌。",
  ["yz_qinli_chifu_choose_tip"]="炽斧造成伤害后选择",
  ["yz_qinli_chifu_choose_hp"]="回复1血",
  ["yz_qinli_chifu_choose_card"]="获得两张牌",
  -- ["#yz_qinli_chifu"] = " %to 【破坏】切换技能为【炽斧】",

  ["yz_qinli_zhuopao"] = "灼炮",
  [":yz_qinli_zhuopao"] = "锁定技：当你使用牌指定非唯一目标时，每回合限一次，你可以在此牌结算完成后获得之，若如此做，你失去一点体力。你使用的【火】杀和【火攻】可以额外指定一个目标。",
  -- ["#yz_qinli_chifu"] = " %to 【破坏】切换技能为【炽斧】",


}
-- 技能  炎魔  平A变火元素伤害
local yz_qinli_yanmo=fk.CreateTriggerSkill{
  name="yz_qinli_yanmo",
  anim_type = "defensive",
  frequency = Skill.Compulsory, -- 锁定技
  events={fk.PreDamage},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) and target==player and data.to~= player and data.card
  end,
  on_use =function (self, event, target, player, data)
    local msg={}
    local room=player.room
    data.damageType=fk.FireDamage

      -- 额外一次伤害
      --  room:damage({
      --   from = player,
      --   to = data.to,
      --   damage = 0,
      --   damageType = fk.FireDamage,
      --   skillName = self.name
      -- })
      
 
      room:notifySkillInvoked(player,"yz_qinli_yanmo","offensive",target)
  end
}
-- 破坏	锁定技，当你使用牌指定唯一目标时：1、若该目标与你距离为1且你拥有技能【灼炮】，你失去技能【灼炮】并获得技能【炽斧】；
--                                      2、若该目标与你的距离大于1且你拥有技能【炽斧】，你失去技能【炽斧】并获得技能【灼炮】。
local yz_qinli_pohuai=fk.CreateTriggerSkill{
  name="yz_qinli_pohuai",
  anim_type = "offensive",
  frequency=Skill.Compulsory,
  events = {fk.TargetSpecified},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) and target==player
  end,
  on_use =function (self, event, target, player, data)
    local room=player.room
    -- dbg()
    if data.tos and #data.tos[1]==1 and data.tos[1][1] ~= data.from then
      local player2=room:getPlayerById(data.tos[1][1])
      if player:distanceTo(player2,"both",true) == 1 and player:hasSkill("yz_qinli_zhuopao") then
           room:handleAddLoseSkills(player, "-yz_qinli_zhuopao", "yz_qinli_pohuai", true)

          --  room:notifySkillInvoked(player,"yz_qinli_chifu","fire",player2)
           room:handleAddLoseSkills(player, "yz_qinli_chifu", "yz_qinli_pohuai", true)
           print("失去炮，获得斧")
      elseif player:distanceTo(player2,"both",true) > 1 and player:hasSkill("yz_qinli_chifu") then
            room:handleAddLoseSkills(player, "-yz_qinli_chifu", "yz_qinli_pohuai", true)
            room:handleAddLoseSkills(player, "yz_qinli_zhuopao", "yz_qinli_pohuai", true)
            print("失去斧，获得炮")
      end
    end
  end
  
}
-- 炽斧	锁定技：你的【杀】、【决斗】和【火攻】无视防具且不能被响应。
-- 每回合限一次，当你使用火【杀】和【火攻】造成伤害时，你可以选择回复一点体力或摸两张牌。
-- local yz_qinli_chifu_plus=fk.CreateTriggerSkill{
--   name="yz_qinli_chifu_plus",
--   frequency=Skill.Compulsory,
--   -- events={fk.AfterPhaseEnd},
--   can_trigger=function (self, event, target, player, data)
--     return player:hasSkill(self.name) 
--     and target ==player 
--     and (data.card.name == "fire__slash" or data.card.name =="fire_attack" and data.card.name == "duel")
--   end,
--   on_use= function (self, event, target, player, data)
--     data.disresponsive = true
--   end
  
-- }
local yz_qinli_chifu=fk.CreateTriggerSkill{
  name="yz_qinli_chifu",
  frequency=Skill.Compulsory,
  events={fk.DamageCaused},
  can_use =function (self,player)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
  end,
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
    and target==player 
    and (data.card.name == "fire__slash" or data.card.name =="fire_attack")
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    print("使用炽斧")
    -- dbg()
    local choose={"yz_qinli_chifu_choose_hp","yz_qinli_chifu_choose_card"}
    local choices = room:askForChoice(player,choose,self.name,"yz_qinli_chifu_choose_tip",false,choose)
    if choices=="yz_qinli_chifu_choose_hp" then
      room:recover{
        who = player ,
        num = 1,
        recoverBy = player,
        skillName = "yz_qinli_chifu"
      }
    else
      player:drawCards(2)
    end
  end
}


-- 灼炮	锁定技：当你使用牌指定非唯一目标时，每回合限一次，你可以在此牌结算完成后获得之，若如此做，你失去一点体力。
-- 你使用的【火】杀和【火攻】可以额外指定一个目标。
local yz_qinli_zhuopao=fk.CreateTargetModSkill{
  name="yz_qinli_zhuopao",
  frequency=Skill.Compulsory,
  events = {fk.TargetSpecifying},
  can_use =function (self,player)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
  end,
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) and target==player and (data.card.name == "fire__slash" or data.card.name =="fire_attack")
  end,
  on_use =function (self, event, target, player, data)
    local room = player.room
    local tos = TargetGroup:getRealTargets(data.tos)
    local targets = table.map(table.filter(room.alive_players, function(p)
      return p ~= player and not table.contains(tos, p.id) end), Util.IdMapper)
    targets = room:askForChoosePlayers(player, targets, 1, 1, "额外选择一个目标", "yz_qinli_zhuopao", true)
    if #targets > 0 then
      room:damage{
        from = player,
        to = room:getPlayerById(targets[1]),
        damage = 1,
        skillName = "yz_qinli_zhuopao",
      }
    end
  end
}
-- yz_qinli_chifu:addRelatedSkill(yz_qinli_chifu_plus)

yz_qinli:addSkill(yz_qinli_yanmo)
yz_qinli:addSkill(yz_qinli_pohuai)
yz_qinli:addSkill(yz_qinli_chifu)
yz_qinli:addSkill(yz_qinli_zhuopao)
-------------------------------------------------------------------------------------------------------------------------------------
-- 星宫六喰（can）
-- 闭锁	当你成为其他角色使用基本牌或锦囊牌的的目标后，你可以失去一点体力，令此牌对你无效，然后你令该角色的技能失效直到其下回合开始。
-- 封解	每回合限一次，当你使用【杀】造成伤害后，你可以令其获得一枚「封」标记，除你和其以外的角色对拥有「封」标记的角色造成伤害时，你令该伤害-1。
-- 当拥有「封」标记造成伤害后或回复体力后，你移除该角色武将牌上的「封」标记。你的出牌阶段，你可以场上的「封」标记。

local yz_liucan=General:new(extension,"yz_liucan","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_liucan"] = "星宫六喰",
  ["#yz_liucan"] = "钥之天使",
  ["designer:yz_liucan"] = "好多人都设了，当时人挺多的",
  ["cv:yz_liucan"] = "不知道",
  ["illustrator:yz_liucan"] = "不是我",
  -- 技能翻译
  ["@yz_liucan_feng"]="封",
  ["yz_liucan_bisuo"]="闭锁",
  ["#yz_liucan_bisuo_skill"]="闭锁·锁",
  ["#yz_liucan_bisuo_lostMark"]="闭锁·释",
  [":yz_liucan_bisuo"]="当你成为其他角色使用基本牌或锦囊牌的的目标后，你可以失去一点体力，令此牌对你无效，然后你令该角色的技能失效直到其下回合开始。",
  ["@yz_liucan_jie"]="解",
  ["yz_liucan_fengjie"]="封解",
  ["#yz_liucan_fengjie_damaged"]="封解·伤",
  ["#yz_liucan_fengjie_lost_jie"]="封解·释",
  [":yz_liucan_fengjie"]="每回合限一次，当你使用【杀】造成伤害后，你可以令其获得一枚「解」标记，"..
                         "除你和其以外的角色对拥有「解」标记的角色造成伤害时，你令该伤害-1。<br>"..
                         "当拥有「解」标记造成伤害后或回复体力后，你移除该角色武将牌上的「解」标记。"
}
local yz_liucan_bisuo=fk.CreateTriggerSkill{
  name="yz_liucan_bisuo",
  events={fk.TargetConfirmed},
  can_trigger=function (self, event, target, player, data)
     return player:hasSkill(self.name)
            and target == player
            and data.from ~=data.to
            and (data.card.type == Card.TypeTrick or data.card.type == Card.TypeBasic)
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    local from=room:getPlayerById(data.from)
    room:loseHp(player,1,self.name)
    room:addPlayerMark(from,"@yz_liucan_feng")
    AimGroup:cancelTarget(data, player.id)
  end
}
-- 创建技能失效技能
local yz_liucan_bisuo_skill = fk.CreateInvaliditySkill {
  name = "#yz_liucan_bisuo_skill",
  invalidity_func = function(self, from, skill)
    return
      from:getMark("@yz_liucan_feng") ~= 0 
      and skill:isPlayerSkill(from)
  end
}
-- 刷新【封】
local yz_liucan_bisuo_lostMark=fk.CreateTriggerSkill{
  name="#yz_liucan_bisuo_lostMark",
  refresh_events={fk.TurnStart},
can_refresh=function (self, event, target, player, data)
  return player:hasSkill(self.name)
         and target:getMark("@yz_liucan_feng")>0
end,
on_refresh=function (self, event, target, player, data)
  local room=player.room
  room:setPlayerMark(target,"@yz_liucan_feng",0)
end
}
local yz_liucan_fengjie=fk.CreateTriggerSkill{
  name="yz_liucan_fengjie",
  events={fk.Damage},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==target
           and data.card.trueName=="slash"
           and player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    local to=data.to
    room:addPlayerMark(to,"@yz_liucan_jie",1)
  end
}
-- "除你和其以外的角色对拥有「解」标记的角色造成伤害时，你令该伤害-1。
local yz_liucan_fengjie_damaged=fk.CreateTriggerSkill{
  name="#yz_liucan_fengjie_damaged",
  events={fk.DamageCaused},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ~=player
           and data.to:getMark("@yz_liucan_jie") > 0

  end,
  on_use=function (self, event, target, player, data)
    data.damage=data.damage-1
  end
}
-- "当拥有「解」标记造成伤害后或回复体力后，你移除该角色武将牌上的「解」标记。
local yz_liucan_fengjie_lost_jie=fk.CreateTriggerSkill{
  name="#yz_liucan_fengjie_lost_jie",
  events={fk.Damage,fk.HpRecover },
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ~=player
           and target:getMark("@yz_liucan_jie") > 0

  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(target,"@yz_liucan_jie",0)
  end
}
yz_liucan_fengjie:addRelatedSkill(yz_liucan_fengjie_damaged)
yz_liucan_fengjie:addRelatedSkill(yz_liucan_fengjie_lost_jie)
yz_liucan_bisuo:addRelatedSkill(yz_liucan_bisuo_skill)
yz_liucan_bisuo:addRelatedSkill(yz_liucan_bisuo_lostMark)
yz_liucan:addSkill(yz_liucan_bisuo)
yz_liucan:addSkill(yz_liucan_fengjie)

-------------------------------------------------------------------------------------------------------------------------------------
-- 镜野七罪
-- 赝造	当你使用基本牌或非延时性锦囊牌指定目标后，你可以失去一点体力或弃一张牌，若如此做，其他角色不能使用或打出牌响应你使用的牌。
-- 万化	每轮限一次，你可以选择一名角色，然后你声明其武将牌上的一个技能（限定技、觉醒技、主公技除外），你可以选择一项：
-- 		1、直到你的下回合开始时，你视为拥有此技能，且性别和势力视为与其相同；
-- 		2、失去一点体力并弃置2张不同颜色的牌，若如此做，你的下个回合开始时，你获得此技能。
-- 		背水：失去一点体力上限。
local yz_qizui=General:new(extension,"yz_qizui","god",2,3,General.Female)
Fk:loadTranslationTable{
  ["yz_qizui"] = "镜野七罪",
  ["#yz_qizui"] = "七罪大魔王是巫女",
  ["designer:yz_qizui"] = "好多人都设了，当时人挺多的",
  ["cv:yz_qizui"] = "不知道",
  ["illustrator:yz_qizui"] = "不是我",
  -- 技能翻译
  ["yz_qizui_yanzao"]="赝造",
  [":yz_qizui_yanzao"]="当你使用基本牌或非延时性锦囊牌指定目标后，你可以失去一点体力或弃一张牌，若如此做，其他角色不能使用或打出牌响应你使用的牌。",
  ["yz_qizui_yanzao_lostHp"]="失去一点体力",
  ["yz_qizui_yanzao_lostCard"]="弃一张牌",
  ["yz_qizui_wanhua"]="万化",
  [":yz_qizui_wanhau"]="每轮限一次，你可以选择一名角色，然后你声明其武将牌上的一个技能（限定技、觉醒技、主公技除外），你可以选择一项：<br>"..
                       "1、直到你的下回合开始时，你视为拥有此技能，且性别和势力视为与其相同；<br>"..
                       "2、失去一点体力并弃置2张不同颜色的牌，若如此做，你的下个回合开始时，你获得此技能。",
  ["yz_qizui_wanhau_choose1"]="其一",
  [":yz_qizui_wanhau_choose1"]="直下回合开始时，你视为拥有此技能，且性别和势力视为与其相同",
  ["yz_qizui_wanhau_choose2"]="其二",
  [":yz_qizui_wanhau_choose2"]="失去一点体力并弃置2张不同颜色的牌，你的下个回合开始时，你获得此技能。",
  ["@yz_qizui_wanhau_skill-turn"]="技",
  ["@yz_qizui_beishui"]="不要啊！",
  ["@yz_qizui_help"]="救命QAQ",
  ["yz_qizui_beishui"]="背水",   
  [":yz_qizui_beishui"]="失去一点体力上限。",
  ["cancel"]="取消"
}
local yz_qizui_yanzao=fk.CreateTriggerSkill{
  name="yz_qizui_yanzao",
  events={fk.TargetSpecified},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and player.hp>0
           and #player:getCardIds()>0
           and (data.card.type == Card.TypeBasic 
           or 
           ( data.card.type == Card.TypeTrick  and data.card.sub_type ~= Card.SubtypeDelayedTrick))
  end,
  on_cost =function (self, event, target, player, data)
    local room=player.room
    local choose={"yz_qizui_yanzao_lostHp","yz_qizui_yanzao_lostCard","Cancel"}
    local selected = room:askForChoice(player,choose,self.name,"yz_qizui_yanzao",false,choose)
    if selected=="yz_qizui_yanzao_lostHp" then
      room:loseHp(player,1,self.name)
      self.cost_data=1
      return true
    elseif selected=="yz_qizui_yanzao_lostCard" then
      local discard=room:askForDiscard(player,1,1,true,self.name,false)
      self.cost_data=2
      return true
    else
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    data.disresponsive=true
  end
}
local yz_qizui_wanhua=fk.CreateActiveSkill{
  name="yz_qizui_wanhua",
  can_use=function (self, player, card, extra_data)
   return player:hasSkill(self.name)
          and player:usedSkillTimes(self.name, Player.HistoryRound) == 0
        
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, to_select, selected)
    return #selected == 0 and to_select ~= Self.id
  end,
  target_num=1,
  on_use=function (self, room, data)
    local from=room:getPlayerById(data.from)
    local target = room:getPlayerById(data.tos[1])
    local skills = Fk.generals[target.general]:getSkillNameList()
    local choose={}
    local fromNum=#from:getCardIds()
    if fromNum>=2  then
      choose={"yz_qizui_wanhau_choose1","yz_qizui_wanhau_choose2","cancel"}
    elseif fromNum==0 or from.hp<2  then
      choose={"yz_qizui_wanhau_choose1","cancel"}
    end
    local selected=room:askForChoice(from,choose,self.name,"选择一个效果",true,choose)
    if selected=="yz_qizui_wanhau_choose1" then
    elseif selected=="yz_qizui_wanhau_choose2" then
      room:loseHp(from,1,self.name)
      if fromNum>=2 then
        local discard=room:askForDiscard(from,2,2,true,self.name,false)
      elseif fromNum==1 then
        local discard=room:askForDiscard(from,1,1,true,self.name,false)
      end
      -- 获得技能代码
      if Fk.generals[target.deputyGeneral] then
        table.insertTableIfNeed(skills, Fk.generals[target.deputyGeneral]:getSkillNameList())
      end
      skills = table.filter(skills, function(skill_name)
        local skill = Fk.skills[skill_name]
        return not from:hasSkill(skill, true) and (#skill.attachedKingdom == 0 or table.contains(skill.attachedKingdom, from.kingdom))
      end)
      if #skills > 0 then
        local skill = room:askForChoice(from, skills, self.name, self.name, true)
        room:setPlayerMark(from, "@yz_qizui_wanhau_skill-turn", skill)
        room:handleAddLoseSkills(from, skill, nil, true, false)
      end
    end
  end

}
local yz_qizui_beishui=fk.CreateTriggerSkill{
    name="yz_qizui_beishui",
    -- frequency=Skill.Limited,
    events={fk.GameStart},
    can_trigger=function (self, event, target, player, data)
      return player:hasSkill(self.name)
    end,
    on_cost=function (self, event, target, player, data)
      local room=player.room
      room:changeMaxHp(player,-1)
    end
}

yz_qizui:addSkill(yz_qizui_yanzao)
yz_qizui:addSkill(yz_qizui_wanhua)
yz_qizui:addSkill(yz_qizui_beishui)
-------------------------------------------------------------------------------------------------------------------------------------
-- 分离	锁定技，游戏开始时，或每局游戏限一次，你死亡时，你选择你未选择过的一项：
-- 		1、用八舞耶俱矢替换你的武将牌；
-- 		2、用八舞夕弦替换你的武将牌。
-- 		然后你将你的体力回复至体力上限复原并重置你的武将牌。

-- 创建共有技能【分离】
Fk:loadTranslationTable{
  -- 技能翻译
  ["yz_bawu_fenli"]="分离",
  [":yz_bawu_fenli"]="锁定技，游戏开始时，或每局游戏限一次，你死亡时，你选择你未选择过的一项: \n 1、用八舞耶俱矢替换你的武将牌\n2、用八舞夕弦替换你的武将牌。\n然后你将你的体力回复至体力上限复原并重置你的武将牌",
  ["yz_bawu_fenli_choose_xixuan"]="是否替换为夕弦",
  ["yz_bawu_fenli_choose_yejushi"]="是否替换为耶俱矢",
  ["yz_bawu_fenli_choose_Cancel"]="取消",
  ["#yz_bawu_fenli_dy"] = "分离"
}

local yz_bawu_fenli=fk.CreateTriggerSkill{
  name="yz_bawu_fenli",
  frequency=Skill.Compulsory,
  events={fk.GameStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
  end,
  can_use =function (self,player)
    local room =player.room
    return player:usedSkillTimes(self.name, Player.HistoryGame) == 0
  end,
  on_use =function (self, event, target, player, data)
    local room = player.room
    local hero= player.general
    -- print(hero)
    if hero == "yz_yejushi" then
      local choose={"yz_bawu_fenli_choose_xixuan","yz_bawu_fenli_choose_Cancel"}
      local choices = room:askForChoice(player,choose,self.name,"yz_bawu_fenli",false,choose)
      if choices =="yz_bawu_fenli_choose_xixuan" then
        room:changeHero(player, "yz_xixuan")
      end
    elseif hero == "yz_xixuan" then
      local choose={"yz_bawu_fenli_choose_yejushi","yz_bawu_fenli_choose_Cancel"}
      local choices = room:askForChoice(player,choose,self.name,"yz_bawu_fenli",false,choose)
      if choices =="yz_bawu_fenli_choose_yejushi" then
        room:changeHero(player, "yz_yejushi")
      end
    elseif hero == "yz_jejushi_xixuan" then
      local choose={"yz_bawu_fenli_choose_xixuan","yz_bawu_fenli_choose_yejushi"}
      local choices = room:askForChoice(player,choose,self.name,"yz_bawu_fenli",false,choose)
        -- print(choices)
      if choices == "yz_bawu_fenli_choose_xixuan" then
        -- print("替换位夕弦")
        room:changeHero(player, "yz_xixuan")
      else
        -- print("替换位耶俱矢")
        room:changeHero(player, "yz_yejushi")
      end
      
    end
  end
}
local yz_bawu_fenli_dy=fk.CreateTriggerSkill{
  name="#yz_bawu_fenli_dy",
  -- frequency=Skill.Compulsory,
  frequency = Skill.Limited,
  events={fk.EnterDying},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)  and target == player and player:usedSkillTimes(self.name, Player.HistoryGame) == 0
  end,
  on_use =function (self, event, target, player, data)
    local room = player.room
    local hero= player.general
    print(player:usedSkillTimes(self.name, Player.HistoryGame))
    if hero =="yz_yejushi" then
      room:changeHero(player, "yz_xixuan",true,false,true)
    else
      room:changeHero(player, "yz_yejushi",true,false,true)
     
    end
  end
}
yz_bawu_fenli:addRelatedSkill(yz_bawu_fenli_dy)
-- 八舞耶俱矢
-- 贯穿	锁定技，当你使用【杀】造成伤害后，你对其下家造成x点伤害。（X为此【杀】造成的伤害数）
-- 自傲	当你使用【杀】对目标角色造成伤害时，你可以令其选择一项：
-- 		1、令此伤害+1，然后其可以获得你一张手牌；
-- 		2、你弃置其一张手牌。
local yz_yejushi=General:new(extension,"yz_yejushi","god",2,2,General.Female)
Fk:loadTranslationTable{
  ["yz_yejushi"] = "八舞耶俱矢",
  ["#yz_yejushi"] = "本宫绝不会输",
  ["designer:yz_yejushi"] = "好多人都设了，当时人挺多的",
  ["cv:yz_yejushi"] = "不知道",
  ["illustrator:yz_yejushi"] = "不是我",
  -- 技能翻译
  ["yz_yejushi_guanchaun"] ="贯穿",
  [":yz_yejushi_guanchaun"]="锁定技，当你使用【杀】造成伤害后，你对其下家造成x点伤害。（X为此【杀】造成的伤害数）",

  ["yz_yejushi_ziao"] ="自傲",
  [":yz_yejushi_ziao"]="当你使用【杀】对目标角色造成伤害时，你可以令其选择一项：1、令此伤害+1，然后其可以获得你一张手牌；2、你弃置其一张手牌。",
  ["yz_yejushi_ziao_choose_1"]="受到伤害+1，获得其一张手牌",
  ["yz_yejushi_ziao_choose_2"]="弃置其一张手牌",
  }
-- 创建技能

-- 贯穿	锁定技，当你使用【杀】造成伤害后，你对其下家造成x点伤害。（X为此【杀】造成的伤害数）
local yz_yejushi_guanchaun=fk.CreateTriggerSkill{
  name="yz_yejushi_guanchaun",
  frequency = Skill.Compulsory,
  events={fk.Damage},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) 
    and target == player 
    and data.card ~= nil
    and data.card.name == "slash"
  end,
  on_use =function (self, event, target, player, data)
    print("触发贯穿")
    local room =player.room
    if data.to:getNextAlive(true,1,false) and data.to:getNextAlive(true,1,false) ~=player then
      local nextPlay = data.to:getNextAlive(true,1,false)
      -- 额外一次伤害
       room:damage({
        from = player,
        to = nextPlay,
        damage = data.damage,
        damageType = fk.Damage,
        skillName = self.name
      })
    end
    
  end
}
-- 自傲	当你使用【杀】对目标角色造成伤害时，你可以令其选择一项：
-- 		1、令此伤害+1，然后其可以获得你一张手牌；
-- 		2、你弃置其一张手牌。
local yz_yejushi_ziao =fk.CreateTriggerSkill{
  name="yz_yejushi_ziao",
  -- frequency = Skill.Frequent,
  events={fk.DamageCaused},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) 
    and target == player 
    and data.card ~= nil
    and data.card.name == "slash"
    and #player:getCardIds("he") > 1
  end,
  on_use =function (self, event, target, player, data)
    print("触发自傲")
    local room=player.room
    local choose={"yz_yejushi_ziao_choose_1","yz_yejushi_ziao_choose_2"}
    local choices = room:askForChoice(data.to,choose,self.name,"yz_yejushi_ziao",false,choose)
    if choices=="yz_yejushi_ziao_choose_1" then
      local cardId=  room:askForCardChosen(data.to,player,"he",self.name)
      room:obtainCard(data.to,cardId,true)
      data.damage= data.damage+1
    elseif choices =="yz_yejushi_ziao_choose_2"  then
      -- room:askForDiscard(data.to,1,1,true,self.name,false,".","yz_yejushi_ziao_choose_2",true,true)
      local cardId=  room:askForCardChosen(player,data.to,"he",self.name)
      room:throwCard(cardId,self.name,player,data.to)
    end
  end
}

-- 八舞耶俱矢 添加技能
yz_yejushi:addSkill(yz_bawu_fenli)
yz_yejushi:addSkill(yz_yejushi_guanchaun)
yz_yejushi:addSkill(yz_yejushi_ziao)
-------------------------------------------------------------------------------------------------------------------------------------
-- 八舞夕弦	
-- 束缚	每当你受到一点伤害或失去一点体力后，你可以选择一名角色，其计算与其它角色的距离+1。
-- 手足	锁定技，回合开始时，你失去一点体力。当你使用【杀】造成伤害后，你回复X点体力（X为此【杀】造成的伤害数）
-- 疾驰	出牌阶段你使用【杀】的次数上限+1。你进入濒死状态时，可以视为对一名玩家使用一张无距离限制的【杀】。
local yz_xixuan=General:new(extension,"yz_xixuan","god",2,2,General.Female)
Fk:loadTranslationTable{
  ["yz_xixuan"] = "八舞夕弦",
  ["#yz_xixuan"] = "飓风骑士",
  ["designer:yz_xixuan"] = "好多人都设了，当时人挺多的",
  ["cv:yz_xixuan"] = "不知道",
  ["illustrator:yz_xixuan"] = "不是我",
  -- 技能翻译
  ["yz_xixuan_shufu"]="束缚",
  [":yz_xixuan_shufu"]="每当你受到一点伤害或失去一点体力后，你可以选择一名角色，其计算与其它角色的距离+1",
  ["yz_xixuan_shufu_choose"]="选择一名玩家",

  ["@yz_xixuan_shufu_mark"] ="束",

  ["yz_xixuan_shouzu"]="手足",
  [":yz_xixuan_shouzu"]="锁定技，回合开始时，你失去一点体力。当你使用【杀】造成伤害后，你回复X点体力（X为此【杀】造成的伤害数）",
  ["#yz_xixuan_shouzu_sha"]="手足",
   
  ["yz_xixuan_jichi"]= "疾驰",
  [":yz_xixuan_jichi"]= "出牌阶段你使用【杀】的次数上限+1。你进入濒死状态时，可以视为对一名玩家使用一张无距离限制的【杀】",
  ["#yz_xixuan_jichi_sha"] = "疾驰"
}
-- 创建技能
-- 计算距离+1未测试
-- 束缚	每当你受到一点伤害或失去一点体力后，你可以选择一名角色，其计算与其它角色的距离+1。
local yz_xixuan_shufu=fk.CreateTriggerSkill{
  name="yz_xixuan_shufu",
  events={fk.Damaged,fk.HpLost},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
    and target == player
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    local OtherPlayer=room:getOtherPlayers(player,true,false)
    local targets={}
    for index, value in ipairs(OtherPlayer) do
      table.insert(targets,value.id)
    end
    local targetId=room:askForChoosePlayers(player,targets,1,1,"yz_xixuan_shufu_choose",self.name,true,true)
    if #targetId ~=0 then
      local targetPlay=room:getPlayerById(targetId[1])
      room:addPlayerMark(targetPlay,"@yz_xixuan_shufu_mark",1)
      print(player:distanceTo(targetPlay))
    end
  end
}
local yz_xixuan_shufu_target=fk.CreateDistanceSkill{
  name="#yz_xixuan_shufu_target",
  correct_func = function(self, from, to)
    local markNum=from:getMark("@yz_xixuan_shufu_mark")
    if markNum>0 then
      return markNum
    end
  end,
}
yz_xixuan_shufu:addRelatedSkill(yz_xixuan_shufu_target)
-- 手足	锁定技，回合开始时，你失去一点体力。当你使用【杀】造成伤害后，你回复X点体力（X为此【杀】造成的伤害数）
local yz_xixuan_shouzu=fk.CreateTriggerSkill{
  name="yz_xixuan_shouzu",
  frequency=Skill.Compulsory,
  events={fk.TurnStart},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
          --  and target ~= player
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    room:loseHp(player,1)
    -- room:damage({
    --   from = player,
    --   to = player,
    --   damage = 1,
    --   damageType = fk.Damage,
    --   skillName = self.name
    -- })
  end
}
local yz_xixuan_shouzu_sha=fk.CreateTriggerSkill{
  name="#yz_xixuan_shouzu_sha",
  frequency=Skill.Compulsory,
  events={fk.Damage},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and data.card ~=nil
           and data.card.trueName == "slash"
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    room:recover{
      who = player ,
      num = data.damage,
      recoverBy = player,
      skillName = "yz_xixuan_shouzu"
    }
  end
}
-- 疾驰	出牌阶段你使用【杀】的次数上限+1。你进入濒死状态时，可以视为对一名玩家使用一张无距离限制的【杀】。
-- 濒死出牌？理解不能
local yz_xixuan_jichi_sha=fk.CreateTargetModSkill{
  name = "#yz_xixuan_jichi_sha",
  frequency = Skill.Compulsory,
  bypass_times = function(self, player, skill, scope)
    if player:hasSkill(self) and skill.trueName == "slash_skill"
      and scope == Player.HistoryPhase and  player:usedCardTimes("slash",Player.HistoryTurn)<2 then
      return true
    end
  end,
}
local yz_xixuan_jichi=fk.CreateTriggerSkill{
  -- player:inMyAttackRange(p)
  name="yz_xixuan_jichi",
  events={fk.EnterDying},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
  end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    local otherPlayers=table.map(room:getOtherPlayers(player), Util.IdMapper)
    local targetId= room:askForChoosePlayers(player,otherPlayers,1,1,"",self.name,false,false)
    if #targetId ==1 then
      local card=Fk:cloneCard("slash")
      local targetPlayer=room:getPlayerById(targetId[1])
      local cardUseEvent={from = player.id,tos={{targetPlayer.id}},card=card}
      room:useCard(cardUseEvent)
    end
  end

}
yz_xixuan_jichi:addRelatedSkill(yz_xixuan_jichi_sha)
-- 添加技能
yz_xixuan:addSkill(yz_bawu_fenli)
yz_xixuan:addSkill(yz_xixuan_shufu)
yz_xixuan:addSkill(yz_xixuan_shouzu)
yz_xixuan:addSkill(yz_xixuan_jichi)
-- -------------------------------------------------------------------------------------------------------------------------------------
-- 耶俱矢＆夕弦
local yz_jejushi_xixuan=General:new(extension,"yz_jejushi_xixuan","god",2,2,General.Female)
Fk:loadTranslationTable{
  ["yz_jejushi_xixuan"] = "耶俱矢＆夕弦",
  ["#yz_jejushi_xixuan"] = "八舞之名",
  ["designer:yz_jejushi_xixuan"] = "好多人都设了，当时人挺多的",
  ["cv:yz_jejushi_xixuan"] = "不知道",
  ["illustrator:yz_jejushi_xixuan"] = "不是我",
}
yz_jejushi_xixuan:addSkill(yz_bawu_fenli)
--------------------------------------------------------------------------------------------------------------------------------------
-- 风侍八舞
---------------------------------------------------------------------------------------------------------------------------------------
-- 诱宵美九
local yz_meijiu=General:new(extension,"yz_meijiu","god",2,3,General.Female)
Fk:loadTranslationTable{
  ["yz_meijiu"] = "诱宵美九",
  ["#yz_meijiu"] = "破军歌姬",
  ["designer:yz_meijiu"] = "好多人都设了，当时人挺多的",
  ["cv:yz_meijiu"] = "不知道",
  ["illustrator:yz_meijiu"] = "不是我",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 夜刀神十香
-- 鏖杀	当你使用【杀】选择目标后，你可以令一名距离为1的角色也成为此【杀】的目标。当你使用【杀】指定唯一目标后，若该角色与你距离为1，你可以令此【杀】造成的伤害+1。
-- 王胃	锁定技，当你成为一名角色使用【杀】和【桃】的目标后，该角色选择一项：1.弃置一张牌；2.令此牌对你无效。
local yz_shixiang=General:new(extension,"yz_shixiang","god",4,4,General.Female)
Fk:loadTranslationTable{
  ["yz_shixiang"] = "夜刀神十香",
  ["#yz_shixiang"] = "公主",
  ["designer:yz_shixiang"] = "好多人都设了，当时人挺多的",
  ["cv:yz_shixiang"] = "不知道",
  ["illustrator:yz_shixiang"] = "不是我",
  -- 技能翻译
  ["yz_shixiang_aosha"] = "鏖杀",
  [":yz_shixiang_aosha"] = "当你使用【杀】选择目标后，你可以令一名距离为1的角色也成为此【杀】的目标。<br>"..
                           "当你使用【杀】指定唯一目标后，若该角色与你距离为1，你可以令此【杀】造成的伤害+1。",
  ["yz_shixiang_aosha_choose"] ="选择一名额外玩家",

  ["yz_shixiang_wangwei"]="王胃",
  [":yz_shixiang_wangwei"]="锁定技，当你成为一名角色使用【杀】和【桃】的目标后，该角色选择一项：1.弃置一张牌；2.令此牌对你无效。",
  ["yz_shixiang_wangwei_choose1"]="弃置一张牌",
  ["yz_shixiang_wangwei_choose2"]="令此无效",
}
-- 创建技能
-- 鏖杀  未完整测试
local yz_shixiang_aosha=fk.CreateTriggerSkill{
  name="yz_shixiang_aosha",
  events={fk.TargetSpecified},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) and target==player and data.card.name=="slash" 
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    local playerList=room:getOtherPlayers(player,true,false)
    local targets={}
    for index, value in ipairs(playerList) do
      if player:distanceTo(room:getPlayerById(value.id)) == 1 and data.tos[1][1] ~= value.id then
        table.insert(targets,value.id)
      end
    end
    local targetPlay=  room:askForChoosePlayers(player,targets,1,1,"yz_shixiang_aosha_choose",self.name,true,false)
    if #targetPlay == 0 and player:distanceTo(room:getPlayerById(data.tos[1][1]))==1  then
     data.damage=data.damage+1
    elseif #targetPlay ~= 0  then
     room:damage({
      from = player,
      to = room:getPlayerById(targetPlay[1]),
      damage = 1,
      damageType = fk.Damage,
      skillName = self.name
    })
    end
  end
}
-- 王胃	锁定技，当你成为一名角色使用【杀】和【桃】的目标后，该角色选择一项：1.弃置一张牌；2.令此牌对你无效。
local yz_shixiang_wangwei=fk.CreateTriggerSkill{
  name="yz_shixiang_wangwei",
  frequency=Skill.Compulsory,
  events={fk.TargetConfirmed},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) 
           and target == player
           and (data.card.name == "slash" or data.card.name=="peach")         
  end,
  on_use= function (self, event, target, player, data)
    local room = player.room
    local to=room:getPlayerById(data.from)
    local choose ={"yz_shixiang_wangwei_choose1","yz_shixiang_wangwei_choose2"}
    local selected = room:askForChoice(to,choose,self.name,"yz_shixiang_wangwei",false,choose)
    if selected == "yz_shixiang_wangwei_choose1" and  #to:getCardIds("he") > 1 then
      room:askForDiscard(to,1,1,true,self.name,false)
    -- elseif selected == "yz_shixiang_wangwei_choose2" then
    else
      -- table.insert(data.nullifiedTargets,player.id) 
      AimGroup:cancelTarget(data, player.id)
    end
  end
}
yz_shixiang:addSkill(yz_shixiang_aosha)
yz_shixiang:addSkill(yz_shixiang_wangwei)
-------------------------------------------------------------------------------------------------------------------------------------
-- 五河士道  4血
local yz_wuheshidao=General:new(extension,"yz_wuheshidao","qun",4,4,General.Male)
Fk:loadTranslationTable{
  -- 名称
  ["yz_wuheshidao"] = "五河士道",
  -- 称号
  ["#yz_wuheshidao"] = "后宫王",
  -- 设计
  ["designer:yz_wuheshidao"] = "贞酱",
  -- 配音
  ["cv:yz_wuheshidao"] = "岛崎信长",
  -- 画师
  ["illustrator:yz_wuheshidao"] = "不是我",
  -- 技能
  ["yz_wuheshidao_fengyin"] = "封印",
  [":yz_wuheshidao_fengyin"] = "牌阶段仅限一次，弃置一张牌选择一名女性角色，该角色本回合无法使用技能",
  ["#yz_wuheshidao_fengyin_result"] = " 发动技能【封印】封印了  %to 的技能",

  ["yz_wuheshidao_jianren"] = "坚韧",
  [":yz_wuheshidao_jianren"] = "(锁定技)进入濒死状态时进行判定，锦囊牌回复一点体力摸一张牌",
  ["#yz_wuheshidao_jianren_success"] = " %to 【坚韧】判定成功，回复血量并获得一张牌",
  ["#yz_wuheshidao_jianren_fail"] = " %to 【坚韧】判定失败"
}
-- 创建技能
-- 封印   尚不确定封印技能是否生效
local yz_wuheshidao_fengyin=fk.CreateActiveSkill{
  name="yz_wuheshidao_fengyin",
  can_use =function (self,player)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
  end,
  card_filter = function(self, to_select, selected)
    return #selected < 1 and Fk:currentRoom():getCardArea(to_select) == Player.Hand and not Self:prohibitDiscard(Fk:getCardById(to_select))
  end,
  target_filter = function(self, to_select, selected)
    if #selected < 1 and to_select ~= Self.id then
      local target = Fk:currentRoom():getPlayerById(to_select)
      return target:isFemale()
    end
  end,
  target_num=1,
  card_num = 1,
  on_use =function (self, room,use)
    local msg={}
    local player1=room:getPlayerById(use.from)
     -- 弃牌
    room:throwCard(use.cards, self.name, player1, player1)
    if use.tos[1] ~= nil then
      local player2 = room:getPlayerById(use.tos[1])
      -- 禁用技能
      room:addPlayerMark(player2, MarkEnum.UncompulsoryInvalidity .. "-turn")
      -- 技能释放动画
      local targets = room:getAlivePlayers()
      room:doIndicate(use.from, table.map(targets, Util.IdMapper))
      -- 中了技能的特效
      room:notifySkillInvoked(player1,"yz_wuheshidao_fengyin","special",player2)
      msg.type="#yz_wuheshidao_fengyin_result"
      msg.to={player1.id}
      player1.room:sendLog(msg)
    end
  end
}
-- 创建技能 坚韧:(锁定技)进入濒死状态时进行判定，锦囊牌回复一点体力摸一张牌  
local yz_wuheshidao_jianren=fk.CreateTriggerSkill{
  name="yz_wuheshidao_jianren",
  anim_type = "defensive",
  frequency = Skill.Compulsory,
  events={fk.EnterDying},
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) 
  end,
  on_use = function(self, event, target, player, data)
    local msg={}
    local room = player.room
    while true do
      local judge = {
        who = player,
        reason = self.name,
        pattern = ".",
      }
      room:judge(judge)
      if judge.card and judge.card.type == Card.TypeTrick  then
        msg.type="#yz_wuheshidao_jianren_success"
        msg.to={player.id}
        player.room:sendLog(msg)
        room:recover{
          who = player ,
          num = 1,
          recoverBy = player,
          skillName = "yz_wuheshidao_jianren"
        }
        player:drawCards(1)
        break
      else
        msg.type="#yz_wuheshidao_jianren_fail"
        msg.to={player.id}
        player.room:sendLog(msg)
        break
      end
    end
  end,
}
yz_wuheshidao:addSkill(yz_wuheshidao_jianren)
yz_wuheshidao:addSkill(yz_wuheshidao_fengyin)
-- -----------------------------------------------------------------------------------------------------------------------------------
-- 士织   @贞酱
local yz_shizhi=General:new(extension,"yz_shizhi","qun",3,3,General.Bigender)
-- 士织信息翻译
Fk:loadTranslationTable{
  -- 名称
  ["yz_shizhi"] = "究极侍女",
  -- 称号
  ["#yz_shizhi"] = "香香香",
  -- 设计
  ["designer:yz_shizhi"] = "贞酱",
  -- 配音
  ["cv:yz_shizhi"] = "不知道",
  -- 画师
  ["illustrator:yz_shizhi"] = "不是我",
  ["yz_shizhi_liaoli"] = "料理",
  [":yz_shizhi_liaoli"] = "每轮限一次，出牌阶段，你可以把一张手牌当作[五谷丰登]对任意名角色使用。若你选择的角色数不少于x(x为场上角色数)，在此[五谷丰登]结算结束后你可以令这些角色各回复一点体力。",
  ["#yz_shizhi_liaoli_result"] = " %to 发动技能【料理】判定效果，全体血量+1",
}
-- 创建技能 视为技  把任意一张牌视为五谷丰登
-- 1.视为技能版
local yz_shizhi_liaoli=fk.CreateViewAsSkill{
  name = "yz_shizhi_liaoli",
  pattern = ".",
  can_use=function (self,player)
    return player:usedSkillTimes(self.name, Player.HistoryPhase)== 0
  end,
  before_use =function (self, player, use)
    local room = player.room
    local targets=room:askForChoosePlayers(player,table.map(room:getAlivePlayers(),function (p) return p.id end),1,#(room.alive_players),"yz_shizhi_liaoli",self.name,true)
    use.tos={}
    if #targets == 0 then
      table.insert(use.tos,{player.id})
    else
      for index, pid in ipairs(targets) do
      table.insert(use.tos,{pid})
   end
    end
  end,
  card_filter = function (self,to_select,selected)
    if #selected ==1 then return false end
    local _c = Fk:getCardById(to_select)   
    local c
    c=Fk:cloneCard("amazing_grace")
    return true
  end,
  view_as = function (self, cards)
    if #cards ~= 1 then
      return nil
    end
    local _c = Fk:getCardById(cards[1])
    local c
    c=Fk:cloneCard("amazing_grace")
    c.skillName = self.name
    c:addSubcard(cards[1])
    return c
  end,
  enabled_at_play =function (self, player)
    return player:usedSkillTimes(self.name,Player.HistoryPhase) == 0
  end,
  after_use = function (self, player, use)
    local msg = {}
    local room = player.room
    if #use.tos == #room.alive_players then
      for index,playerList in ipairs(use.tos) do
        for index, player in ipairs(playerList) do
          -- room:notifySkillInvoked(room:getPlayerById(player),"yz_wuheshidao_fengyin","special")
          room:recover{
          who =room:getPlayerById(player) ,
          num = 1,
          recoverBy = player,
          skillName = "yz_shizhi_liaoli"
          }
        end
      end
    end
   msg.type = "#yz_shizhi_liaoli_result"
   msg.to={player.id}
   player.room:sendLog(msg)
  end
}
-- 添加技能
yz_shizhi:addSkill(yz_shizhi_liaoli)

-------------------------------------------------------------------------------------------------------------------------------------
-- 尼别科尔
local yz_nibie=General:new(extension,"yz_nibie","god",2,2,General.Female)
Fk:loadTranslationTable{
  -- 名称
  ["yz_nibie"] = "尼别科尔",
  -- 称号
  ["#yz_nibie"] = "量产杂鱼",
  -- 设计
  ["designer:yz_nibie"] = "贞酱",
  -- 配音
  ["cv:yz_nibie"] = "不知道",
  -- 画师
  ["illustrator:yz_nibie"] = "不是我",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 崇宫澪
local yz_ling=General:new(extension,"yz_ling","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_ling"] = "崇宫澪",
  ["#yz_ling"] = "始源精灵",
  ["designer:yz_ling"] = "好多人都设了，当时人挺多的",
  ["cv:yz_ling"] = "不知道",
  ["illustrator:yz_ling"] = "不是我",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 凛弥  (妈妈)
local yz_linmi=General:new(extension,"yz_linmi","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_linmi"] = "园神凛祢",
  ["#yz_linmi"] = "支配者",
  ["designer:yz_linmi"] = "好多人都设了，当时人挺多的",
  ["cv:yz_linmi"] = "不知道",
  ["illustrator:yz_linmi"] = "不是我",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 凛绪 （女儿）
local yz_linxu=General:new(extension,"yz_linxu","god",4,7,General.Female)
Fk:loadTranslationTable{
  ["yz_linxu"] = "园神凛绪",
  ["#yz_linxu"] = "无以为继的乌托邦",
  ["designer:yz_linxu"] = "好多人都设了，当时人挺多的",
  ["cv:yz_linxu"] = "不知道",
  ["illustrator:yz_linxu"] = "不是我",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 鞠亚&鞠奈
-- 一体	锁定技，游戏开始时，你选择一项：
-- 		1、用或守鞠亚替换你的武将牌；
-- 		2、用或守鞠奈替换你的武将牌。
-- 		当你造成伤害后，你用或守鞠奈替换你的武将牌。当你受到伤害后，你用或守鞠亚替换你的武将牌。
local  yz_juya_junai_yiti=fk.CreateTriggerSkill{
  name="yz_juya_junai_yiti",
  events ={fk.GameStart,fk.Damage,fk.Damaged},
  frequency=Skill.Compulsory,
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    if event == fk.GameStart then
      local choose={"yz_juya_junai_yiti_choose_juya","yz_juya_junai_yiti_choose_junai"}
      local selected=room:askForChoice(player,choose,self.name,"",false,choose)
      if selected=="yz_juya_junai_yiti_choose_juya" then
        room:changeHero(player, "yz_juya")
      elseif selected=="yz_juya_junai_yiti_choose_junai" then
        room:changeHero(player, "yz_junai")
      end
    elseif event == fk.Damage then
      local hero= player.general
      if hero=="yz_juya" then
        room:changeHero(player, "yz_junai")
      end
    elseif event == fk.Damaged then
      local hero= player.general
      if hero=="yz_junai" then
        room:changeHero(player, "yz_juya")
      end
    end
  end
}

local yz_juya_junai=General:new(extension,"yz_juya_junai","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_juya_junai"] = "鞠亚&鞠奈",
  ["#yz_juya_junai"] = "或守植入",
  ["designer:yz_juya_junai"] = "好多人都设了，当时人挺多的",
  ["cv:yz_juya_junai"] = "不知道",
  ["illustrator:yz_juya_junai"] = "不是我",
  -- 技能翻译
  ["yz_juya_junai_yiti"]="一体",
  [":yz_juya_junai_yiti"]="锁定技，游戏开始时，你选择一项：<br>"..
                          "1、用或守鞠亚替换你的武将牌；<br>"..
                          "2、用或守鞠奈替换你的武将牌。<br>"..
                          "当你造成伤害后，你用或守鞠奈替换你的武将牌。当你受到伤害后，你用或守鞠亚替换你的武将牌。",
  ["yz_juya_junai_yiti_choose_juya"]="选择或守鞠亚",
  ["yz_juya_junai_yiti_choose_junai"]="选择或守鞠奈",
}
yz_juya_junai:addSkill(yz_juya_junai_yiti)
-------------------------------------------------------------------------------------------------------------------------------------
-- 或守鞠亚
-- 释爱	出牌阶段，你可以弃置一张【桃】，视为对一名其他角色使用了一张【桃】。你使用【桃】的回复值+1。
-- 荐选	你可以与一名其它角色拼点，没赢的角色选择一项：
-- 		1.赢的角色回复一点体力；
-- 		2.赢的角色对没赢的角色造成一点伤害；
-- 		3.赢的角色获得拼点的两张牌；
-- 		4.弃置两张牌。

local yz_juya=General:new(extension,"yz_juya","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_juya"] = "或守鞠亚",
  ["#yz_juya"] = "绝处逢生",
  ["designer:yz_juya"] = "好多人都设了，当时人挺多的",
  ["cv:yz_juya"] = "不知道",
  ["illustrator:yz_juya"] = "不是我",
  -- 技能翻译
  ["yz_juya_shiai"]="释爱",
  [":yz_juya_shiai"]="出牌阶段，你可以弃置一张【桃】，视为对一名其他角色回复2体力。"..
                     "随后获得技能【爱你的桃桃】使你对自己使用的【桃】的回复值+1。",
  ["@yz_juya_love"]="❤",
  ["#yz_juya_shiai_ai"]="爱你的桃桃",
  ["yz_juya_jianxuan"]="荐选",
  [":yz_juya_jianxuan"]="你可以与一名其它角色拼点，没赢的角色选择一项：<br>"..
                        "1.赢的角色回复一点体力；<br>"..
                        "2.赢的角色对没赢的角色造成一点伤害；<br>"..
                        "3.赢的角色获得拼点的两张牌；<br>"..
                        "4.弃置两张牌。",
  ["yz_juya_jianxuan_1"]="赢家回复一点体力",
  ["#yz_juya_jianxuan_1_result"] = " %to 拼点胜利，回复一点体力！",
  ["yz_juya_jianxuan_2"]="受到赢家一点伤害",
  ["#yz_juya_jianxuan_2_result"] = " %to 受到赢家一点伤害！",
  ["yz_juya_jianxuan_3"]="赢家获得拼点的两张牌",
  ["#yz_juya_jianxuan_3_result"] = " %to 获得拼点的两张牌！",
  ["yz_juya_jianxuan_4"]="弃置两张牌",
  ["yz_juya_jianxuan_4_result"]="%to 弃置两张牌!",
}
local yz_juya_shiai=fk.CreateTriggerSkill{
  name="yz_juya_shiai",
   events={fk.EventPhaseStart},
  can_trigger=function (self, event, target, player, data)
    local peach= player:getCardIds()
    local peachNum=0
    for index, cid in ipairs(peach) do
      local card=Fk:getCardById(cid)
      if card.trueName == "peach" then
        peachNum=peachNum+1
      end
    end
    return player:hasSkill(self.name)
           and target==player
           and player.phase == Player.Play
           and peachNum > 0
           and player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
          
  end,
  on_use =function (self, event, target, player, data)
    local room=player.room   
    local discard = room:askForDiscard(player, 1, 1, false, self.name, true, "peach", "选中一张桃" )
    -- local card =Fk:getCardById(discard[1])
    -- 选人
    local alivePlayersIds=table.map(room:getAlivePlayers(), Util.IdMapper)
    local toId =room:askForChoosePlayers(player,alivePlayersIds,1,1,"",self.name,false,false)
    local to =room:getPlayerById(toId[1])
    room:addPlayerMark(player,"@yz_juya_love",1)
    room:recover{
      who =to ,
      num = 2,
      recoverBy = player,
      skillName = "yz_juya_shiai"
    }
    -- local cardUseEvent={who = to,num=2,recoverBy=player,skillName=self.name,card=card}
    -- room:useCard(cardUseEvent)
    -- room:throwCard()
  end
}
local yz_juya_shiai_ai=fk.CreateTriggerSkill{
  name="#yz_juya_shiai_ai",
  events={fk.CardUsing},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and data.card.name == "peach"
           and player:getMark("@yz_juya_love")>0
  end,
  on_use=function (self, event, target, player, data)
    data.additionalRecover = (data.additionalRecover or 0) + 1
  end

}
-- local yz_juya_shiai_ai=fk.CreateTargetModSkill{
--   name="#yz_juya_shiai_ai",

-- }
local yz_juya_jianxuan=fk.CreateActiveSkill{
  name="yz_juya_jianxuan",
  can_use =function (self, player, card, extra_data)
      return player:usedSkillTimes(self.name, Player.HistoryPhase)== 0
  end,
  target_filter = function(self, to_select, selected)
    local target = Fk:currentRoom():getPlayerById(to_select)
    if #selected < 1 and to_select ~= Self.id and #target:getCardIds()>0 then
      return true
    end
  end,
  target_num=1,
  on_use =function (self, room, effect)
    local from = room:getPlayerById(effect.from)
    local to =room:getPlayerById(effect.tos[1])
    local pindian = from:pindian({to}, self.name)
    local winner = pindian.results[to.id].winner
    local loser= to
    local msg={}
    if winner ~= nil then
       if winner.id == to.id then
          loser=from
        end
      local choose={"yz_juya_jianxuan_1","yz_juya_jianxuan_2","yz_juya_jianxuan_3","yz_juya_jianxuan_4"}
      local selected=room:askForChoice(loser,choose,self.name,"选择一个效果",false,choose)
      if selected=="yz_juya_jianxuan_1" then
        room:recover{
          who =winner ,
          num = 1,
          recoverBy = winner,
          skillName = self.name
        }
        msg.type = "#yz_juya_jianxuan_1_result"
        msg.to = { winner.id }
        from.room:sendLog(msg)
      elseif selected=="yz_juya_jianxuan_2" then
        room:damage({
            from = winner,
            to = loser,
            damage = 1,
            damageType =  fk.NormalDamage,
            skillName = self.name
        })
        -- local cardUseEvent={from=winner,to=loser,damage=1,card=nil}
        -- room:useCard(cardUseEvent)
        msg.type = "#yz_juya_jianxuan_2_result"
        msg.to = { loser.id }
        from.room:sendLog(msg)
      elseif selected=="yz_juya_jianxuan_3" then
        room:obtainCard(winner,pindian.fromCard,true)
        room:obtainCard(winner,pindian.results[to.id].toCard,true)
        msg.type = "#yz_juya_jianxuan_3_result"
        msg.to = { winner.id }
        from.room:sendLog(msg)
      elseif selected=="yz_juya_jianxuan_4" then
        local loserCardNum=#loser:getCardIds()
        if loserCardNum >0  and loserCardNum < 2 then
         local disCard=room:askForDiscard(loser,loserCardNum,loserCardNum,true,self.name,false,"","拼点失败")
        elseif loserCardNum >= 2  then
        local disCard=room:askForDiscard(loser,2,2,true,self.name,false,"","拼点失败")
       end
       msg.type = "#yz_juya_jianxuan_4_result"
        msg.to = { loser.id }
        from.room:sendLog(msg)
      end
    end
  end
}
yz_juya:addSkill(yz_juya_jianxuan)
yz_juya_shiai:addRelatedSkill(yz_juya_shiai_ai)
yz_juya:addSkill(yz_juya_shiai)
yz_juya:addSkill(yz_juya_junai_yiti)
-------------------------------------------------------------------------------------------------------------------------------------
-- 或守鞠奈	
-- 湮灭	当你造成伤害后，若其因此进入濒死状态，你令除你和其以外的角色不能对其使用【桃】直到此次濒死结算结束。
-- 反叛	出牌阶段限一次，你的【杀】可以额外指定一名体力值大于你的角色为目标。
local yz_junai=General:new(extension,"yz_junai","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_junai"] = "或守鞠奈",
  ["#yz_junai"] = "身魂如寄	",
  ["designer:yz_junai"] = "好多人都设了，当时人挺多的",
  ["cv:yz_junai"] = "不知道",
  ["illustrator:yz_junai"] = "不是我",
  -- 技能翻译
  ["yz_junai_yanmie"]="湮灭",
  ["#yz_junai_yanmie_jiu"]="湮灭",
  ["@yz_junai_yanmie_mark"]="湮灭",
  [":yz_junai_yanmie"]="当你造成伤害后，若其因此进入濒死状态，你令除你和其以外的角色不能对其使用【桃】直到此次濒死结算结束。",
  ["yz_junai_fanpan"]="反叛",
  [":yz_junai_fanpan"]="出牌阶段限一次，你的【杀】可以额外指定一名体力值大于你的角色为目标。",
}
-- 当你造成伤害后，若其因此进入濒死状态，你令除你和其以外的角色不能对其使用【桃】直到此次濒死结算结束。
-- 可以用取消目标做
local yz_junai_yanmie=fk.CreateTriggerSkill{
  name="yz_junai_yanmie",
  -- events={fk.Damage},
  -- can_trigger=function (self, event, target, player, data)
  --   return player:hasSkill(self.name)
  --          and target == player
  --         --  and data.to.dying
  -- end,
  -- on_use =function (self, event, target, player, data)
  --   local room =player.room
  --   local to =data.to
  --   if to.dying then
  --     room:setPlayerMark(data.to,"@yz_junai_yanmie_mark",1)
  --   end
  -- end,
  refresh_events = {fk.EnterDying},
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(self) and player.phase ~= Player.NotActive and table.contains(player.player_skills, self)
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:notifySkillInvoked(player, self.name)
    player:broadcastSkillInvoke(self.name)
  end,
}
local yz_junai_yanmie_peach=fk.CreateProhibitSkill{
  name = "#yz_junai_yanmie_prohibit",
  prohibit_use = function(self, player, card)
    if card.name == "peach" and not player.dying then
      return table.find(Fk:currentRoom().alive_players, function(p)
        return p.phase ~= Player.NotActive and p:hasSkill(yz_junai_yanmie) and p ~= player and table.contains(p.player_skills, yz_junai_yanmie)
      end)
    end
  end,
}
local yz_junai_fanpan=fk.CreateTriggerSkill{
  name="yz_junai_fanpan",
  events={fk.AfterCardTargetDeclared},
  can_trigger=function (self, event, target, player, data)
    local room=player.room
    local otherPlayersIds=table.map(room:getOtherPlayers(player), Util.IdMapper)
    return player:hasSkill(self.name)
           and target==player
           and #otherPlayersIds > 1
           and player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
           and data.card.trueName=="slash"
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local otherPlayers = room:getOtherPlayers(player)
    local otherPlayersIds={}
    for index, otherPlayer in ipairs(otherPlayers) do
      if otherPlayer.id ~= data.tos[1][1] and player.hp<otherPlayer.hp then
        table.insert(otherPlayersIds,otherPlayer.id)
      end
    end
    if #otherPlayersIds>0 then
      local extraPlayerId=room:askForChoosePlayers(player,otherPlayersIds,1,1,"选择一名额外目标",self.name,true)
      self.cost_data = extraPlayerId[1]
      return true
   end
  end,
  on_use=function (self, event, target, player, data)
       table.insert(data.tos,{self.cost_data})
  end
}
yz_junai:addSkill(yz_junai_fanpan)
yz_junai_yanmie:addRelatedSkill(yz_junai_yanmie_peach)
yz_junai:addSkill(yz_junai_yanmie)
yz_junai:addSkill(yz_juya_junai_yiti)
-------------------------------------------------------------------------------------------------------------------------------------
-- 万由里
local yz_wanyouli=General:new(extension,"yz_wanyouli","god",2,2,General.Female)
Fk:loadTranslationTable{
  ["yz_wanyouli"] = "万由里",
  ["#yz_wanyouli"] = "金毛败犬	",
  ["designer:yz_wanyouli"] = "好多人都设了，当时人挺多的",
  ["cv:yz_wanyouli"] = "不知道",
  ["illustrator:yz_wanyouli"] = "不是我",
}

-- 同人精灵----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- 忆纭梦
local yz_yunmeng=General:new(extension,"yz_yunmeng","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_yunmeng"] = "忆纭梦",
  ["#yz_yunmeng"] = "迷之造物主	",
  ["designer:yz_yunmeng"] = "Discc",
  ["cv:yz_yunmeng"] = "ai配的",
  ["illustrator:yz_yunmeng"] = "纸盒佬",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 镜优
-- 铠骨	锁定技，非濒死状态时，当你成为【桃】的目标时，取消之。
-- 每当你受到一点伤害或失去一点体力后，你令你的手牌上限+1并把牌堆顶的一张牌放置在你的武将牌上，称为“铠”。
-- 当你进入濒死状态时，若你有至少x张“铠”，你需移去x张“铠”并将你的体力值调整至1点，否则你需移去所有“铠”。（x为你此前已进入濒死状态的次数+1）
-- 瘴毒	任意角色回合开始时，你可以将一张“铠”交给当前回合的角色，并令其选择一项：
-- 		1、将区域内与此牌不同类型的牌各一张交给你；
-- 		2、失去一点体力，本回合无法使用或打出与那张牌颜色相同的牌；
-- 		3、跳过本回合的出牌阶段和弃牌阶段。
-- 入梦	出牌阶段限一次，你可以选择一项：
-- 		1、用任意张手牌替换等量的“铠”；
-- 		2、将至多两张手牌置于你的武将牌上，称为“铠”。
local yz_jingyou=General:new(extension,"yz_jingyou","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_jingyou"] = "镜优",
  ["#yz_jingyou"] = "穷凶极恶的野兽",
  ["designer:yz_jingyou"] = "咱家的某狸",
  ["cv:yz_jingyou"] = "果子狸",
  ["illustrator:yz_jingyou"] = "想不起来谁画的了",
  -- 技能翻译
  ["yz_jingyou_kaigu"]="铠骨",
  [":yz_jingyou_kaigu"]="锁定技，非濒死状态时，当你成为【桃】的目标时，取消之。<br>"..
                        "每当你受到一点伤害或失去一点体力后，你令你的手牌上限+1"..
                        "并把牌堆顶的一张牌放置在你的武将牌上，称为“铠”。"..
                        "当你进入濒死状态时，若你有至少x张“铠”，<br>"..
                        "你需移去x张“铠”并将你的体力值调整至1点，否则你需移去所有“铠”。（x为你此前已进入濒死状态的次数+1）",
  ["#yz_jingyou_kaigu_dying"]="铠骨",
  ["#yz_jingyou_kaigu_lostHP"]="铠骨",
  ["#yz_jingyou_kaigu_maxcards"] ="铠骨",
  ["@yz_jingyou_kai"]= "铠",
  ["yz_jingyou_kai_dis"]="丢弃凯",
  ["@yz_jingyou_kai_cards"]= "牌",
  ["@yz_jingyou_kai_yuan"]= "怨",

  ["yz_jingyou_tandu"]="瘴毒",
  [":yz_jingyou_tandu"]="任意角色回合开始时，你可以将一张“铠”交给当前回合的角色，并令其选择一项：<br>"..
                        "1、送三张牌给镜优；<br>"..
                        "2、送一张牌给镜优，武将牌翻面<br>"..
                        "3、跳过本回合的出牌阶段和弃牌阶段。",
  ["yz_jingyou_tandu_card"]="选择三张牌给镜优",
  ["yz_jingyou_tandu_hp"]="选择一张牌给镜优，武将牌翻面",
  ["yz_jingyou_tandu_skip"]="跳过本回合的出牌阶段和弃牌阶段。",

  ["yz_jingyou_rumeng"]="入梦",
  [":yz_jingyou_rumeng"]="出牌阶段限一次，你可以选择一项：<br>"..
                         "1、用任意张手牌替换等量的“铠”；<br>".."2、将至多两张手牌置于你的武将牌上，称为“铠”。",
  ["yz_jingyou_rumeng_1"]="使用手牌与[铠]交换",
  ["yz_jingyou_rumeng_2"]="至多两张手牌替换[铠]",
}
-- 取消桃目标
local yz_jingyou_kaigu=fk.CreateTriggerSkill{
  name="yz_jingyou_kaigu",
  events={fk.TargetConfirmed},
  frequency=Skill.Compulsory,
  can_trigger=function (self, event, target, player, data)
    return player.dying == false
           and player:hasSkill(self.name)
           and data.card.trueName == "peach"
          --  and target == player
  end,
  on_use =function (self, event, target, player, data)
    AimGroup:cancelTarget(data, player.id)
  end
}
-- 失去体力时获得凯
local yz_jingyou_kaigu_lostHP=fk.CreateTriggerSkill{
  name="#yz_jingyou_kaigu_lostHP",
  events={fk.Damaged,fk.HpLost},
  frequency=Skill.Compulsory,
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) and target ==player
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    -- room:addPlayerMark(player,"@yz_jingyou_kai",1)
    local card =room:drawCards(player,1,self.name,"top",{"@yz_jingyou_kai"})
    player:addToPile("@yz_jingyou_kai",card,true,self.name)
    -- print(#player:getPile("@yz_jingyou_kai")) 
    room:addPlayerMark(player,"@yz_jingyou_kai_cards",1)
  end
}
-- 根据凯增加手牌上限
local yz_jingyou_kaigu_maxcards = fk.CreateMaxCardsSkill{
  name = "#yz_jingyou_kaigu_maxcards",
  correct_func = function(self, player)
    return player:getMark("@yz_jingyou_kai_cards")
  end,
}
-- 濒死时
local yz_jingyou_kaigu_dying=fk.CreateTriggerSkill{
  name="#yz_jingyou_kaigu_dying",
  events={fk.EnterDying},
  frequency=Skill.Compulsory,
  can_trigger =function (self, event, target, player, data)
    return  player:hasSkill(self.name)
            and target == player
  end,
  on_use =function (self, event, target, player, data)
    local room=player.room
    room:addPlayerMark(player,"@yz_jingyou_kai_yuan",1)
    local kai = #player:getPile("@yz_jingyou_kai")
    local yuan =player:getMark("@yz_jingyou_kai_yuan")
    if kai > yuan  then
      local num=kai-yuan-1
      local flag={}
      flag.card_data ={{"@yz_jingyou_kai",player:getPile("@yz_jingyou_kai")}}
      local Discard=room:askForCardsChosen(player,player,yuan,yuan,flag,self.name,"yz_jingyou_kai_dis")
      room:throwCard(Discard,self.name,player,player)
      room:changeHp(player,1)
    end
  end
}
-- 瘴毒	任意角色回合开始时，你可以将一张“铠”交给当前回合的角色，并令其选择一项：
-- 		1、送三张牌给镜优；
-- 		2、送一张牌给镜优，武将牌翻面；
-- 		3、跳过本回合的出牌阶段和弃牌阶段。
local yz_jingyou_tandu=fk.CreateTriggerSkill{
  name="yz_jingyou_tandu",
  events={fk.TurnStart},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and #player:getPile("@yz_jingyou_kai")>0
  end,
 on_use =function (self, event, target, player, data)
    local room=player.room
    -- 选牌
    local flag={}
    flag.card_data ={{"@yz_jingyou_kai",player:getPile("@yz_jingyou_kai")}}
    local cardIds=room:askForCardsChosen(player,player,1,1,flag,self.name,"yz_jingyou_kai_dis")
    -- 选人
    local otherPlayersIds=table.map(room:getAlivePlayers(), Util.IdMapper)
    local toId =room:askForChoosePlayers(player,otherPlayersIds,1,1,"",self.name,false,false)
    -- 获得人
    local to= room:getPlayerById(toId[1])
    -- 获得牌
    room:obtainCard(to,cardIds,true,event,player.id,self.name)
    -- 选择效果
    local choose={"yz_jingyou_tandu_card","yz_jingyou_tandu_hp","yz_jingyou_tandu_skip"}
    local selected=room:askForChoice(to,choose,self.name,"",false,choose)
    local card=Fk:getCardById(cardIds[1])
    -- player.getCardIds("h")
    if selected=="yz_jingyou_tandu_card" then
    -- 送三张牌给镜优
    local toCardNum= #to:getCardIds("he")
      if toCardNum>3 then
        local cardIds=room:askForCardsChosen(to,to,3,3,"he",self.name,"yz_jingyou_kai_dis")
        room:obtainCard(player,cardIds,true,event,player.id,self.name)
      else
        local cardIds=room:askForCardsChosen(to,to,toCardNum,toCardNum,"he",self.name,"yz_jingyou_kai_dis")
        room:obtainCard(player,cardIds,true,event,player.id,self.name)
      end
    elseif selected=="yz_jingyou_tandu_hp" then
      -- 送一张牌给镜优，武将牌翻面；
      local cardIds=room:askForCardsChosen(player,player,1,1,"he",self.name,"yz_jingyou_kai_dis")
      room:obtainCard(player,cardIds,true,event,player.id,self.name)
      to:turnOver()
    elseif selected=="yz_jingyou_tandu_skip" then
      -- 跳过本回合的出牌阶段和弃牌阶段。
      player:skip(Player.Play)
      player:skip(Player.Discard)
    end
 end
}
-- 入梦	出牌阶段限一次，你可以选择一项：
-- 		1、用任意张手牌替换等量的“铠”；
-- 		2、将至多两张手牌置于你的武将牌上，称为“铠”。
local yz_jingyou_rumeng=fk.CreateTriggerSkill{
  name="yz_jingyou_rumeng",
  events={fk.EventPhaseStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and player.phase == Player.Play
           and player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
           and #player:getCardIds("he")>0
           and #player:getPile("@yz_jingyou_kai")>0
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    local playerCardNum=#player:getCardIds("he")
    local kaiNum= #player:getPile("@yz_jingyou_kai")
     -- 凯区
     local flag={}
     flag.card_data ={{"@yz_jingyou_kai",player:getPile("@yz_jingyou_kai")}}
     -- 选择效果
     local choose={"yz_jingyou_rumeng_1","yz_jingyou_rumeng_2"}
     local selected=room:askForChoice(player,choose,self.name,"",false,choose)
     if selected=="yz_jingyou_rumeng_1" then
      local playerCards=room:askForCard(player,1,kaiNum,true,self.name,false)
      player:addToPile("@yz_jingyou_kai",playerCards,true,self.name)
      local cardIds=room:askForCardsChosen(player,player,#playerCards,#playerCards,flag,self.name,"选择凯")
      room:obtainCard(player,cardIds,true,event,player.id,self.name)
    elseif selected=="yz_jingyou_rumeng_2" then
      local playerCards=room:askForCard(player,1,2,true,self.name,false)
      player:addToPile("@yz_jingyou_kai",playerCards,true,self.name)
     end
  end
}

yz_jingyou_kaigu:addRelatedSkill(yz_jingyou_kaigu_lostHP)
yz_jingyou_kaigu:addRelatedSkill(yz_jingyou_kaigu_maxcards)
yz_jingyou_kaigu:addRelatedSkill(yz_jingyou_kaigu_dying)
yz_jingyou:addSkill(yz_jingyou_kaigu)
yz_jingyou:addSkill(yz_jingyou_tandu)
yz_jingyou:addSkill(yz_jingyou_rumeng)
-------------------------------------------------------------------------------------------------------------------------------------
-- 八云命
local yz_ming=General:new(extension,"yz_ming","god",2,2,General.Female)
Fk:loadTranslationTable{
  ["yz_ming"] = "八云命",
  ["#yz_ming"] = "侍神女巫",
  ["designer:yz_ming"] = "学姐",
  ["cv:yz_ming"] = "学姐亲自配",
  ["illustrator:yz_ming"] = "不是我",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 真夜
-- 勇猛	当你使用【杀】指定一名角色为目标后，你可以进行一次判定，若结果为♠️，其不能使用【闪】响应此【杀】。
local yz_zhenye=General:new(extension,"yz_zhenye","god",6,6,General.Female)
Fk:loadTranslationTable{
  ["yz_zhenye"] = "饕神真夜",
  ["#yz_zhenye"] = "饕餮",
  ["designer:yz_zhenye"] = "社恐",
  ["cv:yz_zhenye"] = "Ai配的",
  ["illustrator:yz_zhenye"] = "表情包卡面，无语",
  -- 技能翻译
  ["yz_zhenye_yongmeng"]="勇猛",
  [":yz_zhenye_yongmeng"]="当你使用【杀】指定一名角色为目标后，你可以进行一次判定，若结果为♠️，其不能使用【闪】响应此【杀】。"

}
local yz_zhenye_yongmeng=fk.CreateTriggerSkill{
  name="yz_zhenye_yongmeng",
  events={fk.TargetSpecified},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and data.card.name == "slash"
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    while true do
      local judge = {
        who = player,
        reason = self.name,
        pattern = ".",
      }
      room:judge(judge)
      if judge.card and judge.card.suit == Card.Spade then
        data.disresponsive = true
        break
      else 
        break
      end
    end
  end
}
yz_zhenye:addSkill(yz_zhenye_yongmeng)
-------------------------------------------------------------------------------------------------------------------------------------
-- 白鸟	
local yz_bainiao=General:new(extension,"yz_bainiao","god",4,4,General.Female)
Fk:loadTranslationTable{
  ["yz_bainiao"] = "白鸟",
  ["#yz_bainiao"] = "机械之鸟",
  ["designer:yz_bainiao"] = "心枫",
  ["cv:yz_bainiao"] = "Ai配的",
  ["illustrator:yz_bainiao"] = "",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 星铭千愿
local yz_qianyuan=General:new(extension,"yz_qianyuan","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_qianyuan"] = "星铭千愿",
  ["#yz_qianyuan"] = "亚巴顿",
  ["designer:yz_qianyuan"] = "抱住玩偶的希儿",
  ["cv:yz_qianyuan"] = "Ai配的",
  ["illustrator:yz_qianyuan"] = "",
}
-------------------------------------------------------------------------------------------------------------------------------------
-- 绯都津璃桜		荷蒙库鲁兹
local yz_liying=General:new(extension,"yz_liying","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_liying"] = "绯都津璃桜",
  ["#yz_liying"] = "荷蒙库鲁兹",
  ["designer:yz_liying"] = "抱住玩偶的希儿",
  ["cv:yz_liying"] = "Ai配的",
  ["illustrator:yz_liying"] = "",
}
return extension