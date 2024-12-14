
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
  on_use = function(self, room, effect)
    local player = room:getPlayerById(effect.from)
    player:throwAllCards("he")
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
    return player:hasSkill(self.name)
           and target==player
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
    room:changeMaxHp(to,1)
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
  [":yz_siminai_bingjie"]="出牌阶段限一次，若你的武将牌正面朝上，你可以弃置两张牌并将其中一张交给一名角色，随后翻面，"..
                          "若如此做，你回复一点体力并选择一项：<br>"..
                          "1、令一名未以此法翻面过的其他角色角色翻面；<br>"..
                          "2、摸两张牌并跳过本回合的弃牌阶段。",
  ["yz_siminai_bingjie_turnover"]="选择一名未翻面角色翻面",
  ["yz_siminai_bingjie_getcards"]="获得两张牌并跳过弃牌阶段",

  ["yz_siminai_dongkai"]="冻铠",
  [":yz_siminai_dongkai"]="锁定技，当你成为其他角色使用普通【杀】、【决斗】、【南蛮入侵】、【万箭齐发】的目标时，若你的武将牌背面朝上，取消之。"..
                          "当你受到火属性伤害时，若你的武将牌背面朝上，此伤害+1。",
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
          player:skip(Player.Discard)
          return true
      end
    end
  end
}
local yz_siminai_dongkai=fk.CreateTriggerSkill{
  name="yz_siminai_dongkai",
  frequency = Skill.Compulsory,
  events={fk.TargetConfirmed},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) 
           and target ~= player
           and (data.card.name == "slash" or data.card.name=="duel" 
           or data.card.name=="savage_assault" or data.card.name=="archery_attack")         
  end,
  on_use =function (self, event, target, player, data)
    if not player.faceup  then
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
  [":yz_qinli_pohuai"] = "破坏	锁定技，当你使用牌指定唯一目标时：<br>"..
                         "1、若该目标与你距离为1且你拥有技能【灼炮】，你失去技能【灼炮】并获得技能【炽斧】；<br>"..
                         "2、若该目标与你的距离大于1且你拥有技能【炽斧】，你失去技能【炽斧】并获得技能【灼炮】。",
  ["#yz_qinli_pohuai_fu"] = " %to 【破坏】切换技能为【炽斧】",
  ["#yz_qinli_pohuai_pao"] = " %to 【破坏】切换技能为【灼炮】",

  ["yz_qinli_chifu"] = "炽斧",
  ["#yz_qinli_chifu_plus"]="炽斧·斩",
  [":yz_qinli_chifu"] = "锁定技：你的【杀】、【决斗】和【火攻】无视防具且不能被响应。"..
                        "每回合限一次，当你使用火【杀】和【火攻】造成伤害时，你可以选择回复一点体力或摸两张牌。",
  ["yz_qinli_chifu_choose_tip"]="炽斧造成伤害后选择",
  ["yz_qinli_chifu_choose_hp"]="回复1血",
  ["yz_qinli_chifu_choose_card"]="获得两张牌",

  ["yz_qinli_zhuopao"] = "灼炮",
  ["#yz_qinli_zhuopao_card"] = "灼炮",
  ["#yz_qinli_zhuopao_card_get"]="灼炮·回收",
  [":yz_qinli_zhuopao"] = "锁定技：当你使用牌指定非唯一目标时，每回合限一次，你可以在此牌结算完成后获得之，"..
                          "若如此做，你失去一点体力。你使用的【火】杀和【火攻】可以额外指定一个目标。",
  ["@yz_qinli_fu"]="炽斧",
  ["@yz_qinli_pao"]="灼炮",
  ["@yz_qinli_pao_mark"]="灼炮·收"

}
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
    if data.tos and #data.tos[1]==1 and data.tos[1][1] ~= data.from then
      local player2=room:getPlayerById(data.tos[1][1])
      if player:distanceTo(player2,"both",true) == 1   then
          room:setPlayerMark(player,"@yz_qinli_fu",1)
          room:setPlayerMark(player,"@yz_qinli_pao",0)
      elseif player:distanceTo(player2,"both",true) > 1  then
        room:setPlayerMark(player,"@yz_qinli_pao",1)
        room:setPlayerMark(player,"@yz_qinli_fu",0)
      end
    end
  end
  
}
local yz_qinli_chifu_plus=fk.CreateTriggerSkill{
  name="#yz_qinli_chifu_plus",
  frequency=Skill.Compulsory,
  events={fk.TargetSpecified},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
          and target ==player 
          and player:getMark("@yz_qinli_fu")>0
          and (data.card.name == "slash" or data.card.name =="fire_attack" or data.card.name == "duel")
  end,
  on_use= function (self, event, target, player, data)
    local room=player.room
    data.disresponsive = true
    data.disresponsiveList = table.map(player.room.alive_players, Util.IdMapper)
    player:addQinggangTag(data)

  end
}
local yz_qinli_chifu=fk.CreateTriggerSkill{
  name="yz_qinli_chifu",
  frequency=Skill.Compulsory,
  events={fk.DamageCaused},
  can_trigger=function (self, event, target, player, data)
    return player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
           and player:hasSkill(self.name)
           and player:getMark("@yz_qinli_fu")>0
           and data.card
           and target==player
           and (data.card.name == "fire__slash" or data.card.name =="fire_attack")
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
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
local yz_qinli_zhuopao=fk.CreateTargetModSkill{
  name="yz_qinli_zhuopao",
  frequency=Skill.Compulsory,
  events = {fk.TargetSpecifying},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
          and target==player 
          and player:getMark("@yz_qinli_pao")>0
          and (data.card.name == "fire__slash" or data.card.name =="fire_attack")
  end,
  on_use =function (self, event, target, player, data)
    local room = player.room
    local targets = room:getUseExtraTargets(data)
    if #targets > 0 then
      local tos = room:askForChoosePlayers(player, targets, 1, 1,""..data.card:toLogString(), self.name, true)
      if #tos > 0 then
        table.forEach(tos, function (id)
          table.insert(data.tos, {id})
        end)
      end
    end
  end
}
local yz_qinli_zhuopao_card=fk.CreateTriggerSkill{
  name="#yz_qinli_zhuopao_card",
  frequency=Skill.Compulsory,
  events={fk.TargetSpecified},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
          and target==player 
          and player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
          and player:getMark("@yz_qinli_pao")>0
          and #data.tos[1] == 1
  end,
  on_cost=function (self, event, target, player, data)
    return true
  end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    room:setCardMark(data.card,"@yz_qinli_pao_mark",1)
  end
}
local yz_qinli_zhuopao_card_get=fk.CreateTriggerSkill{
  name="#yz_qinli_zhuopao_card_get",
  frequency=Skill.Compulsory,
  events={fk.CardEffectFinished},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name) 
           and player:getMark("@yz_qinli_pao")>0
           and data.card:getMark("@yz_qinli_pao_mark") > 0
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    room:obtainCard(player,data.card,true)
    room:loseHp(player,1,self.name)
  end
  
}
yz_qinli_chifu:addRelatedSkill(yz_qinli_chifu_plus)
yz_qinli_zhuopao:addRelatedSkill(yz_qinli_zhuopao_card)
yz_qinli_zhuopao:addRelatedSkill(yz_qinli_zhuopao_card_get)
yz_qinli:addSkill(yz_qinli_yanmo)
yz_qinli:addSkill(yz_qinli_pohuai)
yz_qinli:addSkill(yz_qinli_chifu)
yz_qinli:addSkill(yz_qinli_zhuopao)
-------------------------------------------------------------------------------------------------------------------------------------
-- 星宫六喰（can）
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
  [":yz_qizui_wanhua"]="每轮限一次，你可以选择一名角色，然后你声明其武将牌上的一个技能（限定技、觉醒技、主公技除外），你可以选择一项：<br>"..
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
-- 创建共有技能【分离】
Fk:loadTranslationTable{
  -- 技能翻译
  ["yz_bawu_fenli"]="分离",
  [":yz_bawu_fenli"]="锁定技，游戏开始时，或每局游戏限一次，你死亡时，你选择你未选择过的一项: <br>"..
                     " 1、用八舞耶俱矢替换你的武将牌<br>"..
                     "2、用八舞夕弦替换你的武将牌。<br>"..
                     "然后你将你的体力回复至体力上限复原并重置你的武将牌",
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
      if choices == "yz_bawu_fenli_choose_xixuan" then
        room:changeHero(player, "yz_xixuan")
      else
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
  -- 技能翻译
  ["yz_meijiu_duzou"]="独奏",
  [":yz_meijiu_duzou"]="出牌阶段限一次，你可以弃置至多x+1张手牌，并选择至多x名女性角色和一名男性角色，前者分别选择一项：<br>"..
                       "1、视为对后者使用一张【决斗】；<br>"..
                       "2、视为对后者使用一张无距离限制的【杀】。若如此做，你翻面。（x为你的当前体力值）",
  ["yz_meijiu_duzou_1"]="对其使用决斗",
  ["yz_meijiu_duzou_2"]="对其使用无距离限制的【杀】",
  ["yz_meijiu_baihe"]="百合",
  ["#yz_meijiu_baihe_getbai"]="百合·令",
  ["#yz_meijiu_baihe_clearbai"]="百合·解",
  [":yz_meijiu_baihe"]="结束阶段，你可以令本回合造成过伤害的女性角色选择一项:<br>"..
                       "1、摸一张牌<br>；"..
                       "2、令你摸一张牌；<br>"..
                       "3、令你回复一点体力，然后弃一张牌",
  ["yz_meijiu_baihe_choose1"]="摸一张牌",   
  ["yz_meijiu_baihe_choose2"]="令美九摸一张牌",   
  ["yz_meijiu_baihe_choose3"]="令美九回复一点体力，然后弃一张牌",   
  ["cancel"]="取消",
  ["@yz_meijiu_bai"]="百",
  ["@yz_meijiu_he"]="合",
}
local yz_meijiu_duzou=fk.CreateActiveSkill{
    name="yz_meijiu_duzou",
    can_use=function (self, player, card, extra_data)
      return player:hasSkill(self.name)
             and player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
             and player.phase == Player.Play
             and not player:isKongcheng()
    end,
    card_filter = function(self, to_select, selected)
      return #selected < Self.hp+1 and Fk:currentRoom():getCardArea(to_select) == Player.Hand and not Self:prohibitDiscard(Fk:getCardById(to_select))
    end,
    card_num=1,
    target_num=1,
    target_filter=function (self, to_select, selected, selected_cards, card, extra_data)
      return #selected < 1 and to_select ~= Self.id and Fk:currentRoom():getPlayerById(to_select).gender == General.Male
    end,
    on_use=function (self, room, data)
      local cards=data.cards
      local x=#cards
      local player=room:getPlayerById(data.from)
      local target=room:getPlayerById(data.tos[1])
      room:throwCard(cards,self.name,player,player)
      local alivePlayers=room:getAlivePlayers()
      local males={}
      local choose={"yz_meijiu_duzou_1","yz_meijiu_duzou_2"}
      for index, alivePlayer in ipairs(alivePlayers) do
        if alivePlayer.gender==General.Female then
          table.insert(males,alivePlayer.id)
        end
      end
      local juedou=Fk:cloneCard("duel")
      local sha=Fk:cloneCard("slash")
      local male=room:askForChoosePlayers(player,males,1,x,self.name..":最多挑选"..x.."名女角色",self.name,true)
      for index, toid in ipairs(male) do
        local to=room:getPlayerById(toid)
        local selected=room:askForChoice(to,choose,self.name,self.name..":选择对被选中的男性角色做出",false,choose)
        if selected=="yz_meijiu_duzou_1" then
          room:useCard({from=to.id,tos={{target.id}},card=juedou})
        elseif selected=="yz_meijiu_duzou_2" then
          room:useCard({from=to.id,tos={{target.id}},card=sha})
        end
      end
    end
}
local yz_meijiu_baihe=fk.CreateTriggerSkill{
    name="yz_meijiu_baihe",
    events={fk.EventPhaseStart},
    can_trigger=function (self, event, target, player, data)
      return player:hasSkill(self.name)
             and target:getMark("@yz_meijiu_bai") > 0
             and target.phase == Player.Finish
    end,
    on_cost=function (self, event, target, player, data)
      local room =player.room
      local choose={}
      if #player:getCardIds()>0 then
        choose={"yz_meijiu_baihe_choose1","yz_meijiu_baihe_choose2","yz_meijiu_baihe_choose3","cancel"}
      end
      local selected=room:askForChoice(target,choose,self.name,"",false,choose)
      if selected =="yz_meijiu_baihe_choose1" then
        self.cost_data=1
        return true
      elseif selected =="yz_meijiu_baihe_choose2" then
        self.cost_data=2
        return true
      elseif  selected =="yz_meijiu_baihe_choose3" then
        self.cost_data=3
        return false
      elseif selected =="cancel" then
      end
    end,
    on_use=function (self, event, target, player, data)
      local room =player.room
      local selected =self.cost_data
      if  selected == 1 then
        room:drawCards(target,1,self.name,"top")
      elseif selected==2 then
        room:drawCards(player,1,self.name,"top")
      elseif selected==3 then
        room:recover{
          who = player ,
          num = 1,
          recoverBy = player,
          skillName = "yz_meijiu_baihe"
        }
        local discard=room:askForDiscard(player,1,1,true,self.name,false,".",self.name..":选择弃置一张牌")
      end
    end
}
local yz_meijiu_baihe_getbai=fk.CreateTriggerSkill{
    name="#yz_meijiu_baihe_getbai",
    events={fk.Damage},
    can_trigger=function (self, event, target, player, data)
      return player:hasSkill(self.name)
             and target.gender ==General.Female
    end,
    on_cost=function (self, event, target, player, data)
      local room =player.room
      room:addPlayerMark(target,"@yz_meijiu_bai",1)
    end
}
local yz_meijiu_baihe_clearbai=fk.CreateTriggerSkill{
  name="#yz_meijiu_baihe_clearbai",
  refresh_events={fk.TurnEnd},
  can_refresh =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target:getMark("@yz_meijiu_bai")>0
          --  and  target.phase == Player.Finish 
  end,
  on_refresh=function (self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(target,"@yz_meijiu_bai",0)
  end
}
yz_meijiu:addSkill(yz_meijiu_duzou)
yz_meijiu_baihe:addRelatedSkill(yz_meijiu_baihe_getbai)
yz_meijiu_baihe:addRelatedSkill(yz_meijiu_baihe_clearbai)
yz_meijiu:addSkill(yz_meijiu_baihe)
-------------------------------------------------------------------------------------------------------------------------------------
-- 夜刀神十香
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
  [":yz_shixiang_wangwei"]="锁定技，当你成为一名角色使用【杀】和【桃】的目标后，该角色选择一项：<br>"..
                           "1.弃置一张牌；<br>"..
                           "2.令此牌对你无效。",
  ["yz_shixiang_wangwei_choose1"]="弃置一张牌",
  ["yz_shixiang_wangwei_choose2"]="令此无效",
}
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
  -- 技能翻译
  ["yz_yaku_nibie_zhikai"]="纸铠",
  [":yz_yaku_nibie_zhikai"]="游戏开始时，你调整体力上限至X点，并回复一点体力（X为你的体力值与体力上限最高的角色的差值）",
  ["yz_yaku_nibie_ruyi"]="如一",
  [":yz_yaku_nibie_ruyi"]="当你失去任意区域的最后一张牌时，你摸一张牌，那之后，你可以弃置自己其他任意区域内的一张牌。",
}
local yz_yaku_nibie_zhikai=fk.CreateTriggerSkill{
  name="yz_yaku_nibie_zhikai",
  events={fk.GameStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
  end,
  on_cost=function (self, event, target, player, data)
    local room =player.room
    local alive_players=room:getAlivePlayers()
    local maxp=2
    for index, alive_player in ipairs(alive_players) do
      if player.maxHp<alive_player.maxHp then
          room:changeMaxHp(player,alive_player.maxHp-player.maxHp)
      end
    end
    room:recover{
      who =player ,
      num = 1,
      recoverBy = player,
      skillName = self.name
    }
  end
}
local yz_yaku_nibie_ruyi=fk.CreateTriggerSkill{
  name="yz_yaku_nibie_ruyi",
  events={fk.AfterCardsMove},
  can_trigger = function(self, event, target, player, data)
    -- if player:hasSkill(self) and player.room.current and not player.room.current.dead then
    if player:hasSkill(self)  and not player.dead then
      for _, move in ipairs(data) do
        if move.from and move.from == player.id then
        -- if move.from and move.from == player.room.current.id then
          for _, info in ipairs(move.moveInfo) do
            -- if (info.fromArea == Card.PlayerHand and player.room.current:isKongcheng()) or
            --   (info.fromArea == Card.PlayerEquip and #player.room.current:getCardIds("e") == 0) or
            --   (info.fromArea == Card.PlayerJudge and #player.room.current:getCardIds("j") == 0) then
            --   return true
              if (info.fromArea == Card.PlayerHand and player:isKongcheng()) or
              (info.fromArea == Card.PlayerEquip and #player:getCardIds("e") == 0) or
              (info.fromArea == Card.PlayerJudge and #player:getCardIds("j") == 0) then
              return true  
            end
          end
        end
      end
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    player:drawCards(1,self.name,"top")
    local discard=room:askForDiscard(player,1,1,true,self.name,true,".",self.name..":可以弃置一张牌")
  end
}
yz_nibie:addSkill(yz_yaku_nibie_zhikai)
yz_nibie:addSkill(yz_yaku_nibie_ruyi)
-------------------------------------------------------------------------------------------------------------------------------------
-- 崇宫澪
local yz_ling=General:new(extension,"yz_ling","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_ling"] = "崇宫澪",
  ["#yz_ling"] = "始源精灵",
  ["designer:yz_ling"] = "好多人都设了，当时人挺多的",
  ["cv:yz_ling"] = "不知道",
  ["illustrator:yz_ling"] = "不是我",

  ["yz_ling_zero"]="零番",
  ["#yz_ling_zero_damage"]="零番·印",
  ["#yz_ling_zero_Deathed"]="零番·回",
  ["#yz_ling_zer_roundend"]="零番·约束",
  [":yz_ling_zero"]="锁定技，每轮开始时，你可以选择一名角色，若如此做，你令该角色获得一枚「结晶」标记。<br>"..
                    "你对拥有「结晶」标记的其他角色造成伤害时，你获得一个「结晶」标记。<br>"..
                    "当有「结晶」标记的其他角色死亡时，若你拥有「结晶」标记，你可以移去场上所有「结晶」标记，"..
                    "获得其所有牌然后声明其武将牌上的任意个技能，你视为拥有这些技能。<br>"..
                    "每轮结束时，若场上存在「结晶」标记，你失去一点体力并减一点体力上限，然后你移去场上所有「结晶」标记。",
 ["@yz_ling_jiejing"]="结晶",
 ["@yz_ling_yuesu"]="约束",
                    
}
local yz_ling_zero=fk.CreateTriggerSkill{
  name="yz_ling_zero",
  frequency=Skill.Compulsory,
  events={fk.TurnStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local  otherPlayers  = table.map(room:getAlivePlayers(), Util.IdMapper)
    local toId=room:askForChoosePlayers(player,otherPlayers,1,1,self.name..":选择一名玩家",self.name,true,false)
    if #toId>0 then
      local to=room:getPlayerById(toId[1])
      room:setPlayerMark(to,"@yz_ling_jiejing",1)
    end

    return false
  end
}
local yz_ling_zero_damage=fk.CreateTriggerSkill{
  name="#yz_ling_zero_damage",
  frequency=Skill.Compulsory,
  events={fk.Damage},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and data.to:getMark("@yz_ling_jiejing")>0
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_ling_jiejing",1)
  end
}
local yz_ling_zero_Deathed=fk.CreateTriggerSkill{
  name="#yz_ling_zero_death",
  frequency=Skill.Compulsory,
  events={fk.Deathed},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target:getMark("@yz_ling_jiejing") > 0
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local alive_players=table.map(room:getAlivePlayers(), Util.IdMapper)
    for index, alive_player in ipairs(alive_players) do
      local to=room:getPlayerById(alive_player)
      if alive_player:getMark("@yz_ling_jiejing") > 0 then
          room:setPlayerMark(alive_player,"@yz_ling_jiejing",0)
      end
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    local skills = Fk.generals[target.general]:getSkillNameList()
      if Fk.generals[target.deputyGeneral] then
        table.insertTableIfNeed(skills, Fk.generals[target.deputyGeneral]:getSkillNameList())
      end
      skills = table.filter(skills, function(skill_name)
        local skill = Fk.skills[skill_name]
        return not player:hasSkill(skill, true) and (#skill.attachedKingdom == 0 or table.contains(skill.attachedKingdom, player.kingdom))
      end)
      if #skills > 0 then
        local skill = room:askForChoice(player, skills, self.name, "选择其一个技能", true)
        room:handleAddLoseSkills(player, skill, nil, true, false)
      end
  end
}
local yz_ling_zer_roundend=fk.CreateTriggerSkill{
  name="#yz_ling_zer_roundend",
  frequency=Skill.Compulsory,
  events={fk.TurnEnd},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and player.hp>1
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local isJiejing=false
    -- dbg()
    local  alive_Players  = table.map(room:getAlivePlayers(), Util.IdMapper)
    for index, alive_Player in ipairs(alive_Players) do
      alive_Player=room:getPlayerById(alive_Player)
      if alive_Player:getMark("@yz_ling_jiejing") > 0 then
        isJiejing=true
        break
      end
    end
    if player:getMark("@yz_ling_yuesu") >0 and isJiejing then
      for index, alive_Player in ipairs(alive_Players) do
        alive_Player=room:getPlayerById(alive_Player)
        if alive_Player:getMark("@yz_ling_jiejing") > 0 then
          room:setPlayerMark(alive_Player,"@yz_ling_jiejing",0)
        end
      end
       room:loseHp(player,1,self.name)
       room:changeMaxHp(player,-1)
       room:setPlayerMark(player,"@yz_ling_yuesu",0)
    end
     if player:getMark("@yz_ling_yuesu") == 0 then
      room:setPlayerMark(player,"@yz_ling_yuesu",1)
    end
  end
}
yz_ling_zero:addRelatedSkill(yz_ling_zero_damage)
yz_ling_zero:addRelatedSkill(yz_ling_zero_Deathed)
yz_ling_zero:addRelatedSkill(yz_ling_zer_roundend)
yz_ling_zero.permanent_skill = true
yz_ling:addSkill(yz_ling_zero)
-------------------------------------------------------------------------------------------------------------------------------------
-- 凛弥  (妈妈)
local yz_linmi=General:new(extension,"yz_linmi","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_linmi"] = "园神凛祢",
  ["#yz_linmi"] = "支配者",
  ["designer:yz_linmi"] = "好多人都设了，当时人挺多的",
  ["cv:yz_linmi"] = "不知道",
  ["illustrator:yz_linmi"] = "不是我",
  -- 
  ["yz_linmi_leyuan"]="乐园",
  [":yz_linmi_leyuan"]="限定技，一名角色进入濒死状态时，你可以令其弃置区域内所有的牌，复原并重置武将牌，"..
                       "并将体力回复至x点（x为该角色的体力上限且至多为2），那之后如果该角色不是你，其获得一个「乐园」标记",
  ["yz_linmi_xionghuo"]="凶祸",
  ["#yz_linmi_xionghuo_death"]="凶祸·同归",
  ["#yz_linmi_xionghuo_target"]="凶祸·寂",
  [":yz_linmi_xionghuo"]="锁定技，当你受到伤害后，有「乐园」标记的其他角色受到等量的无来源伤害。<br>"..
                         "当你死亡时，你令有「乐园」标记的其他角色死亡。<br>"..
                         "当你成为【杀】或【决斗】的目标时，若你的体力值为1，你可以将场上的「乐园」标记移除，若如此做，你死亡。",
  ["yz_linmi_lunhui"]="轮回",
  [":yz_linmi_lunhui"]="每回合限1次，当你使用的基本牌或非延时锦囊牌进入弃牌堆时，你可以弃一张手牌并把那些牌以任意顺序置于牌堆顶。",
  ["@yz_leyuan"]="乐园",

}
local yz_linmi_leyuan=fk.CreateTriggerSkill{
  name="yz_linmi_leyuan",
  frequency=Skill.Limited,
  events={fk.EnterDying},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local targetCards=target:getCardIds()
    room:throwCard(targetCards,self.name,target,player)
    return true
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    target:setChainState(false)
    room:recover{
      who =target ,
      num = 2,
      recoverBy = player,
      skillName = self.name
    }
    if target.id~=player.id then
      room:setPlayerMark(target,"@yz_leyuan",1)
      player.room:handleAddLoseSkills(player, "yz_linmi_xionghuo", nil, true, true)
    end
  end
}
local yz_linmi_xionghuo=fk.CreateTriggerSkill{
  name="yz_linmi_xionghuo",
  frequency=Skill.Compulsory,
  events={fk.Damaged},
  can_trigger=function (self, event, target, player, data)
    local room=player.room
    local isLeYuan=false
    for index, otherPlayer in ipairs(room:getOtherPlayers(player)) do
      if otherPlayer:getMark("@yz_leyuan")> 0 then
        isLeYuan=true
        break
      end
    end
    return player:hasSkill(self.name)
           and isLeYuan
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    for index, otherPlayer in ipairs(room:getOtherPlayers(player)) do
      if otherPlayer:getMark("@yz_leyuan")> 0 then
        room:damage({
          from = player,
          to =otherPlayer ,
          damage = data.damage,
          damageType = fk.NormalDamage ,
          skillName = self.name
        })
      end
    end
  end
}
local yz_linmi_xionghuo_death=fk.CreateTriggerSkill{
  name="#yz_linmi_xionghuo_death",
  frequency=Skill.Compulsory,
  events={fk.Death},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    
    for index, otherPlayer in ipairs(room:getOtherPlayers(player)) do
      if otherPlayer:getMark("@yz_leyuan")> 0 then
        local dyingStruct={who=otherPlayer.id,damage=100,ignoreDeath=true}
        room:enterDying(dyingStruct)
 
      end
    end
  end
}
-- "当你成为【杀】或【决斗】的目标时，若你的体力值为1，你可以将场上的「乐园」标记移除，若如此做，你死亡。",
local yz_linmi_xionghuo_target=fk.CreateTriggerSkill{
  name="#yz_linmi_xionghuo_target",
  frequency=Skill.Compulsory,
  events={fk.TargetConfirmed},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) 
           and target == player
           and (data.card.name == "slash" or data.card.name=="duel")    
           and player.hp==1
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    for index, otherPlayer in ipairs(room:getOtherPlayers(player)) do
      if otherPlayer:getMark("@yz_leyuan")> 0 then
       room:setPlayerMark(otherPlayer,"@yz_leyuan",0)
      end
    end
    local deathStruct={who=player.id,damage=100}
    room:killPlayer(deathStruct)
  end
}
local yz_linmi_lunhui=fk.CreateTriggerSkill{
  name="yz_linmi_lunhui",
  events={fk.TurnStart},
  can_trigger=function (self, event, target, player, data)
    return  player:usedSkillTimes(self.name, Player.HistoryTurn) == 0
           and player:hasSkill(self.name)
  end,
  on_cost=function (self, event, target, player, data)
    player:drawCards(1,self.name,"top")
  end
}
yz_linmi_xionghuo:addRelatedSkill(yz_linmi_xionghuo_death)
yz_linmi_xionghuo:addRelatedSkill(yz_linmi_xionghuo_target)
yz_linmi:addSkill(yz_linmi_leyuan)
yz_linmi:addSkill(yz_linmi_xionghuo)
yz_linmi:addSkill(yz_linmi_lunhui)
-------------------------------------------------------------------------------------------------------------------------------------
-- 凛绪 （女儿）
-- 轮回	每回合限1次，当你使用的基本牌或非延时锦囊牌进入弃牌堆时，你可以弃一张手牌并把那些牌以任意顺序置于牌堆顶。
-- 		2级：每回合限1次，当有牌因使用结算完毕后进入弃牌堆时，你可以把那些牌以任意顺序置于牌堆顶。
-- 七日	锁定技，每轮结束时，你失去一点体力。每当你失去一点体力，你减少一点体力上限。
-- 出牌阶段，若你的体力上限不大于3，你可以用圆神凛祢替换你的武将牌，
-- 若如此做，你增加一点体力上限，并把体力回复至体力上限，升级技能【轮回】并且你的所有限定技视为已发动过。

local yz_linxu=General:new(extension,"yz_linxu","god",4,7,General.Female)
Fk:loadTranslationTable{
  ["yz_linxu"] = "园神凛绪",
  ["#yz_linxu"] = "无以为继的乌托邦",
  ["designer:yz_linxu"] = "好多人都设了，当时人挺多的",
  ["cv:yz_linxu"] = "不知道",
  ["illustrator:yz_linxu"] = "不是我",
  -- 
  ["yz_linxu_qiri"]="七日",
  ["#yz_linxu_qiri_lostHp"]="七日·虚",
  ["#yz_linxu_qiri_bianhua"]="七日·化身",
  [":yz_linxu_qiri"]="锁定技，每轮结束时，你失去一点体力。每当你失去一点体力，你减少一点体力上限。"..
                     "出牌阶段，若你的体力上限不大于3，你可以用圆神凛祢替换你的武将牌，"..
                     "若如此做，你增加一点体力上限，并把体力回复至体力上限，升级技能【轮回】并且你的所有限定技视为已发动过。",
}
local yz_linxu_qiri=fk.CreateTriggerSkill{
  name="yz_linxu_qiri",
  frequency=Skill.Compulsory,
  events={fk.TurnEnd},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    room:loseHp(player,1,self.name)
  end
}
local yz_linxu_qiri_lostHp=fk.CreateTriggerSkill{
  name="#yz_linxu_qiri_lostHp",
  frequency=Skill.Compulsory,
  events={fk.HpLost},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    room:changeMaxHp(player,-data.num)
  end
}
local yz_linxu_qiri_bianhua=fk.CreateTriggerSkill{
  name="#yz_linxu_qiri_bianhua",
  frequency=Skill.Compulsory,
  events={fk.HpLost},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and player.phase == Player.Play 
           and player.maxHp<=3
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local choose={"yes","no"}
    local selected=room:askForChoice(player,choose,self.name,self.name.."是否幻化为凛祢(妈妈桑)",false,choose)
    if selected=="yes" then
      return true
    else
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    room:changeHero(player,"yz_linmi",true,false,true,true)
    room:changeMaxHp(player,1)
  end
}

yz_linxu_qiri:addRelatedSkill(yz_linxu_qiri_lostHp)
yz_linxu_qiri:addRelatedSkill(yz_linxu_qiri_bianhua)
yz_linxu:addSkill(yz_linxu_qiri)
yz_linxu:addSkill("yz_linmi_lunhui")
-------------------------------------------------------------------------------------------------------------------------------------
-- 鞠亚&鞠奈
local  yz_juya_junai_yiti=fk.CreateTriggerSkill{
  name="yz_juya_junai_yiti",
  events ={fk.GameStart,fk.Damage,fk.Damaged},
  frequency=Skill.Compulsory,
  can_trigger =function (self, event, target, player, data)
    if  event == fk.GameStart then
       return player:hasSkill(self.name)
    elseif event == fk.Damage then
      return player:hasSkill(self.name)
             and target == player
    elseif event == fk.Damaged then   
      return player:hasSkill(self.name)
             and target == player
    end 
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
    elseif event == fk.Damage  then
      local hero= player.general
      if hero=="yz_juya" then
        room:changeHero(player, "yz_junai")
      end
    elseif event == fk.Damaged   then
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
local yz_juya_jianxuan=fk.CreateActiveSkill{
  name="yz_juya_jianxuan",
  can_use =function (self, player, card, extra_data)
      return player:usedSkillTimes(self.name, Player.HistoryPhase)== 0
  end,
  target_filter = function(self, to_select, selected)
    local target = Fk:currentRoom():getPlayerById(to_select)
    if #selected < 1 and to_select ~= Self.id and #target:getCardIds()>0 and not Fk.currentRoom():getPlayerById(to_select):isKongcheng() then
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
  -- 
  ["yz_wanyouli_leiting"]="雷霆",
  ["#yz_wanyouli_leiting_leisha"]="雷霆·镇压",
  ["#yz_wanyouli_leiting_mianyi"]="雷霆·免疫",
  ["#yz_wanyouli_leiting_use_lei"]="雷霆",
  [":yz_wanyouli_leiting"]="出牌阶段开始时，你可以将一张手牌当无距离限制且不计入次数的雷【杀】打出。"..
                           "你使用非转化的雷【杀】无次数限制且可以多指定至多2个目标。当你受到雷电伤害时，你可以阻止此伤害。",
  ["yz_wanyouli_daxiong"]="大凶",
  ["#yz_wanyouli_daxiong_get"]="大凶·赠与",
  [":yz_wanyouli_daxiong"]="当其他男性角色令你脱离濒死状态后，你可以令其选择是否减少一点体力上限并获得技能【雷霆】。若如此做，你死亡。",
  ["@yz_xiong"]="凶",
  ["@yz_lei"]="雷",
  ["yes"]="交给我吧",
  [":yes"]="减少一点体力上限并获得技能【雷霆】",
  ["no"]="不了",
  [":no"]="谢谢你，败犬，但是不行"
}
-- 视为雷杀
local yz_wanyouli_leiting=fk.CreateViewAsSkill{
    name="yz_wanyouli_leiting",
    anim_type = "defensive",
    pattern = "thunder__slash",
    before_use=function (self, player, use)
      local room=player.room
      room:setPlayerMark(player,"@yz_lei",1)
      local _ , data= room:askForUseViewAsSkill(player,self.name,self.name..":",true,{bypass_distances = true})
    end,
    card_filter = function(self, to_select, selected)
      return #selected == 0 
    end,
    view_as = function(self, cards)
      if #cards ~= 1 then return end
      local card = Fk:cloneCard("thunder__slash")
      card.skillName = self.name
      card:addSubcards(cards)
      return card
    end,
    
    after_use=function (self, player, use)
      local room=player.room
      room:setPlayerMark(player,"@yz_lei",0)
    end
}
-- 使用雷杀强化【无次数限制】
local yz_wanyouli_leiting_use_lei=fk.CreateTargetModSkill{
  name = "#yz_wanyouli_leiting_use_lei",
  bypass_times = function(self, player, skill, scope)
    if player:hasSkill(self) and skill.trueName == "thunder__slash"
      and scope == Player.HistoryPhase then
      return true
    end
  end,
}
-- 选择额外目标
local yz_wanyouli_leiting_use_mod=fk.CreateTriggerSkill{
  name="#yz_wanyouli_leiting_leisha",
  events={fk.TargetSpecified},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self)
           and player:getMark("@yz_lei") == 0
           and target == player
           and data.card
           and data.card.name=="thunder__slash"
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
-- 免疫雷伤
local yz_wanyouli_leiting_mianyi=fk.CreateTriggerSkill{
  name="#yz_wanyouli_leiting_mianyi",
  events={fk.DamageInflicted},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and data.damageType==fk.ThunderDamage 
           and target ==player
  end,
  on_cost=function (self, event, target, player, data)
   return true
  end,
  on_use=function (self, event, target, player, data)
     local room=player.room
    data.damage=0
  end
}
local yz_wanyouli_daxiong=fk.CreateTriggerSkill{
  name="yz_wanyouli_daxiong",
  events={fk.EnterDying},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_xiong",1)
  end
}
-- 复活时
local yz_wanyouli_daxiong_gethp=fk.CreateTriggerSkill{
  name="#yz_wanyouli_daxiong_get",
  events={fk.HpRecover},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and player:getMark("@yz_xiong") > 0
           and data.recoverBy.gender==General.Male
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local to=data.recoverBy
    local choose={"yes","no"}
    local selected=room:askForChoice(to,choose,self.name,self.name..":是否...",true,choose)
    if selected == "yes" then
      return true
    else
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    local to=data.recoverBy
    room:changeMaxHp(to,-1)
    room:handleAddLoseSkills(to, "yz_wanyouli_leiting", nil, true, true)
  end
}
yz_wanyouli_leiting:addRelatedSkill(yz_wanyouli_leiting_use_lei)
yz_wanyouli_leiting:addRelatedSkill(yz_wanyouli_leiting_use_mod)
yz_wanyouli_leiting:addRelatedSkill(yz_wanyouli_leiting_mianyi)
yz_wanyouli_daxiong:addRelatedSkill(yz_wanyouli_daxiong_gethp)
yz_wanyouli:addSkill(yz_wanyouli_leiting)
yz_wanyouli:addSkill(yz_wanyouli_daxiong)
-- 莲			堕天使				3/3

local yz_lian=General:new(extension,"yz_lian","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_lian"] = "莲",
  ["#yz_lian"] = "堕天使	",
  ["designer:yz_lian"] = "",
  ["cv:yz_lian"] = "ai配的",
  ["illustrator:yz_lian"] = "",
  ["yz_lian_tandu"]="瘴毒",
  ["#yz_lian_tandu_use"]="瘴毒·毒发",
  [":yz_lian_tandu"]="当你受到1点伤害后，你可以摸一张牌，然后你将一张手牌置于伤害来源的武将牌上，称为「毒」。"..
                     "当其他角色于使用手牌时，你可以移去其武将牌上一张牌名相同的「毒」，然后此牌无效，你摸两张牌。",
  ["yz_lian_dushen"]="渎神",
  [":yz_lian_dushen"]="当你进入濒死状态时，你可以选择一项:<br>"..
                     " 1、移去场上两张「毒」，然后你回复一点体力；<br>"..
                     " 2、进行一次判定，如果结果为♥️，你获得判定牌，然后你回复一点体力。",
  ["yz_lian_dushen_1"]="移去场上两张「毒」，回复一点体力",     
  ["yz_lian_dushen_2"]="进行判定",    
  ["cencle"]="取消",
  ["@yz_lian_du"]="毒"
}
local yz_lian_tandu=fk.CreateTriggerSkill{
  name="yz_lian_tandu",
  events={fk.Damaged},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
          --  and data.Damage
           and data.from ~=player
           and target == player
  end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    local to=data.from
    player:drawCards(1,self.name,"top")
    local cardIds=room:askForCardChosen(player,player,"h",self.name)
    to:addToPile("@yz_lian_du",cardIds,true,self.name)
  end
}
local yz_lian_tandu_use=fk.CreateTriggerSkill{
  name="#yz_lian_tandu_use",
  events={fk.CardUsing},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and data.from ~=player.id
           and #target:getPile("@yz_lian_du") > 0
  end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    local flag={}
    flag.card_data ={{"@yz_lian_du",target:getPile("@yz_lian_du")}}
    local cardIds=room:askForCardsChosen(player,target,1,1,flag,self.name,"yz_jingyou_kai_dis")
    room:throwCard(cardIds,self.name,target,player)
    data.nullifiedTargets = table.map(player.room.alive_players, Util.IdMapper)
    player:drawCards(2,self.name,"top")
  end
}
local yz_lian_dushen=fk.CreateTriggerSkill{
  name="yz_lian_dushen",
  events={fk.EnterDying},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
  end,
  on_cost=function (self, event, target, player, data)
    local room =player.room
    local choose={}
    local t=0
    local otherPlayers=room:getOtherPlayers(player)
    for index, otherPlayer in ipairs(otherPlayers) do
      if #otherPlayer:getPile("@yz_lian_du") >=2 then
        t = t + 1
      end
    end
    if t>0 then
       choose={"yz_lian_dushen_1","yz_lian_dushen_2","cencle"}
    else
      choose={"yz_lian_dushen_2","cencle"}
    end
    local selected=room:askForChoice(player,choose,self.name,self.name..":选择一项",false,choose)
    if selected=="yz_lian_dushen_1" then
        self.cost_data=1
        return true
    elseif selected=="yz_lian_dushen_2" then
      self.cost_data=2
      return true
    elseif selected=="cencle" then
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    if self.cost_data==1 then
      local flag={}
      flag.card_data ={{"@yz_lian_du",target:getPile("@yz_lian_du")}}
      local cardIds=room:askForCardsChosen(player,target,2,2,flag,self.name,"yz_jingyou_kai_dis")
      room:throwCard(cardIds,self.name,target,player)
      room:recover{
        who=player,
        num=1,
        from=player,
        skillName=self.name
      }
    elseif self.cost_data==2 then
      local judge = {
        who = player,
        reason = self.name,
        pattern = ".",
      }
      room:judge(judge)
      if judge.card and judge.card.suit==Card.Heart then
        room:recover{
          who=player,
          num=1,
          from=player,
          skillName=self.name
        }
      end
    end
  end
}
yz_lian_tandu:addRelatedSkill(yz_lian_tandu_use)
yz_lian:addSkill(yz_lian_tandu)
yz_lian:addSkill(yz_lian_dushen)
-- 同人精灵----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- 忆纭梦
-- 创造	每名角色的回合限一次，你可以把区域内的一张牌当作任意一张基本牌或非延时性锦囊牌使用。
-- 结束阶段，你可以把区域内的一张牌当作任意本回合你未使用过类型的一张基本牌或非延时性锦囊牌使用。
local yz_yunmeng=General:new(extension,"yz_yunmeng","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_yunmeng"] = "忆纭梦",
  ["#yz_yunmeng"] = "迷之造物主	",
  ["designer:yz_yunmeng"] = "Discc",
  ["cv:yz_yunmeng"] = "ai配的",
  ["illustrator:yz_yunmeng"] = "纸盒佬",
  -- 
  ["yz_yunmeng_chuangzao"]="创造",
  [":yz_yunmeng_chuangzao"]="每名角色的回合限一次，你可以把区域内的一张牌当作任意一张基本牌或非延时性锦囊牌使用。"..
                            "结束阶段，你可以把区域内的一张牌当作任意本回合你未使用过类型的一张基本牌或非延时性锦囊牌使用。",
}
local yz_yunmeng_chuangzao= fk.CreateViewAsSkill{
  name = "yz_yunmeng_chuangzao",
  prompt = "",
  times = function(self)
    return 
           Player.Play 
           and 
           Self:usedSkillTimes(self.name, Player.HistoryTurn) == 0
  end,
  interaction = function(self)
    local all_names = U.getAllCardNames("bt")
    return U.CardNameBox {
      choices = U.getViewAsCardNames(Self, self.name, all_names, nil, Self:getTableMark("yz_yunmeng_chuangzao-turn")),
      all_choices = all_names,
      default_choice = self.name,
    }
  end,
  card_filter = function(self, to_select, selected)
    return #selected == 0 and Fk.all_card_types[self.interaction.data] ~= nil
  end,
  view_as = function(self, cards)
    if #cards ~= 1 or Fk.all_card_types[self.interaction.data] == nil then return end
    local card = Fk:cloneCard(self.interaction.data)
    card:addSubcard(cards[1])
    card.skillName = self.name
    return card
  end,
  before_use = function(self, player, use)
    player.room:addTableMark(player, "yz_yunmeng_chuangzao-turn", use.card.trueName)
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) <
      #table.filter(Fk:currentRoom().alive_players, function (p)
        return 0
      end)
  end,
}
yz_yunmeng:addSkill(yz_yunmeng_chuangzao)
-------------------------------------------------------------------------------------------------------------------------------------
-- 镜优
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
  end,
  on_use =function (self, event, target, player, data)
    AimGroup:cancelTarget(data, player.id)
  end
}
local yz_jingyou_kaigu_lostHP=fk.CreateTriggerSkill{
  name="#yz_jingyou_kaigu_lostHP",
  events={fk.Damaged,fk.HpLost},
  frequency=Skill.Compulsory,
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name) and target ==player
  end,
  on_use =function (self, event, target, player, data)
    local room =player.room
    local card =room:drawCards(player,1,self.name,"top",{"@yz_jingyou_kai"})
    player:addToPile("@yz_jingyou_kai",card,true,self.name)
    room:addPlayerMark(player,"@yz_jingyou_kai_cards",1)
  end
}
local yz_jingyou_kaigu_maxcards = fk.CreateMaxCardsSkill{
  name = "#yz_jingyou_kaigu_maxcards",
  correct_func = function(self, player)
    return player:getMark("@yz_jingyou_kai_cards")
  end,
}
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
  ["yes"]="确定",
  ["no"]="取消",
  -- 
  ["yz_ming_yeyuan"]="夜原",
  ["#yz_ming_yeyuan_damaged_1"]="夜原·止",
  ["#yz_ming_yeyuan_damaged_2"]="夜原·支配",
  ["#yz_ming_yeyuan_reset"]="夜原",
  [":yz_ming_yeyuan"]="摸牌阶段，你可以放弃摸牌并失去一点体力，若如此做，你从以下效果中选择一项你上次未选择过的选项执行：<br>"..
                      "1、直到下一个你的回合开始阶段，当你受到伤害时，阻止此伤害，并直到下一个你的回合的开始阶段前使技能［封魔］失效。<br>"..
                      "2、将x点伤害分配给至多x名角色（X为你的当前体力值），你增加一点体力上限，并直到下一个自己的回合回合前使技能［神爱］失效。<br>",
  ["yz_ming_yeyuan_choose1"]="其一",
  [":yz_ming_yeyuan_choose1"]="直到下一个你的回合开始阶段，当你受到伤害时，阻止此伤害，并直到下一个你的回合的开始阶段前使技能［封魔］失效。",
  ["yz_ming_yeyuan_choose2"]="其二",
  [":yz_ming_yeyuan_choose2"]="将x点伤害分配给至多x名角色（X为你的当前体力值），你增加一点体力上限，并直到下一个自己的回合回合前使技能［神爱］失效",
  ["@yz_ming_lost_fengmo"]="禁·封魔",
  ["@yz_ming_lost_shenai"]="禁·神爱",
  ["yz_ming_fengmo"]="封魔",
  [":yz_ming_fengmo"]="其他角色造成属性伤害时，你可以弃置一张手牌并防止该伤害。",
  ["yz_ming_shenai"]="神爱",
  [":yz_ming_shenai"]="锁定技，你的伤害类锦囊和【杀】不能指定其他角色为目标。",
  ["yz_ming_xianhui"]="贤惠",
  ["#yz_ming_xianhui_maxcard"]="贤惠·买菜",
  [":yz_ming_xianhui"]="你的手牌上限+y，（y为「饭」的数量的一半，向下取整且最少为一）<br>"..
                       "出牌阶段限一次，你可以选择一下一项执行：<br>"..
                       "1.你可以将任意数量的手牌扣置在武将牌上称为「饭」。<br>"..
                       "2.你可以移去x张「饭」，为至多x名角色各恢复一点体力，若如此做，你摸一张牌。",
  ["#yz_ming_xianhui_get_fan"]="贤惠·做饭",
  ["@yz_ming_fan"]="饭",
  ["yz_ming_xianhui_1"]="将任意数量的手牌转为【饭】",
  ["yz_ming_xianhui_2"]="移去【饭】为角色一点体力",
}
local yz_ming_yeyuan=fk.CreateTriggerSkill{
  name="yz_ming_yeyuan",
  anim_type = "offensive",
  events = {fk.EventPhaseStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player.phase == Player.Draw
  end,
  on_use=function (self, event, target, player, data)
    local room= player.room
    
    room:loseHp(player,1,self.name)
    local feng=player:getMark("@yz_ming_lost_fengmo")
    local shen=player:getMark("@yz_ming_lost_shenai")
     local choose={}
    if feng == 0 and  shen == 0 then
       choose={"yz_ming_yeyuan_choose1","yz_ming_yeyuan_choose2"}
    elseif feng == 1 and  shen == 0 then
      choose={"yz_ming_yeyuan_choose2"}
    elseif feng == 0 and  shen == 1 then
       choose={"yz_ming_yeyuan_choose1"}
    end
    local selected=room:askForChoice(player,choose,self.name,"",true,choose)
    if selected=="yz_ming_yeyuan_choose1"  then
      room:setPlayerMark(player,"@yz_ming_lost_fengmo",1)
      room:invalidateSkill(player,"yz_ming_fengmo","-turn")
      room:setPlayerMark(player,"@yz_ming_lost_shenai",0)
      room:validateSkill(player,"yz_ming_fengmo")
    elseif selected=="yz_ming_yeyuan_choose2" then
      room:setPlayerMark(player,"@yz_ming_lost_shenai",1)
      room:invalidateSkill(player,"yz_ming_shenai","-turn")
      room:setPlayerMark(player,"@yz_ming_lost_fengmo",0)
      room:validateSkill(player,"yz_ming_fengmo")
    end
    player:skip(Player.Draw)
  end
}
-- 选择夜原1
local yz_ming_yeyuan_damaged_1=fk.CreateTriggerSkill{
  name="#yz_ming_yeyuan_damaged_1",
  events = {fk.DamageInflicted},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player:getMark("@yz_ming_lost_fengmo")>0
  end,
  on_use=function (self, event, target, player, data)
    return true
  end
}
-- 选择夜原2
local yz_ming_yeyuan_damaged_2=fk.CreateTriggerSkill{
  name="#yz_ming_yeyuan_damaged_2",
  events = {fk.DamageInflicted},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player:getMark("@yz_ming_lost_shenai")>0
  end,
  on_use=function (self, event, target, player, data)
   local room=player.room
   local otherPlayerId= table.map(room:getOtherPlayers(player), Util.IdMapper)
   local toIds=room:askForChoosePlayers(player,otherPlayerId,1,data.damage,self.name..":选择分配伤害",self.name,true)
   for index, toId in ipairs(toIds) do
    local to=room:getPlayerById(toId)
    room:damage({
      to=to,
      damage=1,
      from=player,
      damageType=fk.NormalDamage,
      skillName=self.name
    })
    -- AimGroup:cancelTarget(data, player.id)
    return true
   end
  end
}
local yz_ming_yeyuan_reset=fk.CreateTriggerSkill{
  name="#yz_ming_yeyuan_reset",
  refresh_events={fk.TurnStart},
  can_refresh=function (self, event, target, player, data)
    return player:hasSkill(self.name)
    and target ==player
  end,
  on_refresh=function (self, event, target, player, data)
    local room =player.room
    room:setPlayerMark(player,"@yz_ming_lost_fengmo",0)
    room:setPlayerMark(player,"@yz_ming_lost_shenai",0)
  end
}
-- 其他角色造成属性伤害时，你可以弃置一张手牌并防止该伤害。
local yz_ming_fengmo=fk.CreateTriggerSkill{
    name="yz_ming_fengmo",
    events={fk.DamageCaused},
    can_trigger=function (self, event, target, player, data)
      return player:hasSkill(self.name)
             and target ~=player
             and data.damageType
             and data.damageType~=fk.NormalDamage
             and #player:getCardIds()>0
    end,
    on_cost=function (self, event, target, player, data)
      local room =player.room
      local discard=room:askForDiscard(player,1,1,true,self.name,true)
      if #discard>0 then
        return true
      end
    end,
    on_use=function (self, event, target, player, data)
      return true
    end
}
-- 锁定技，你的伤害类锦囊和【杀】不能指定其他角色为目标。
local yz_ming_shenai=fk.CreateProhibitSkill{
  name="yz_ming_shenai",
  prohibit_use=function (self, player, card)
    return player:hasSkill(self.name)
           and (card.trueName=="slash"
           or card.sub_type == Card.SubtypeDelayedTrick)
  end
}
local yz_ming_xianhui=fk.CreateTriggerSkill{
  name="yz_ming_xianhui",
  events = {fk.AfterDrawNCards},
  can_trigger=function (self, event, target, player, data)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
           and player:hasSkill(self.name)
           and target==player
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local choose={"cencle"}
    if player:getPile("@yz_ming_fan") then
       choose={"yz_ming_xianhui_1","yz_ming_xianhui_2","cencle"}
    else
      choose={"yz_ming_xianhui_1","cencle"}
    end
    local selected=room:askForChoice(player,choose,self.name,self.name..":选择",false,choose)
    if selected=="yz_ming_xianhui_1" then
      self.cost_data=1
      return true
    elseif selected=="yz_ming_xianhui_2" then
      self.cost_data=2
      return true
    else
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    if self.cost_data==1 then
      local cardId=room:askForCardsChosen(player,player,1,#player:getCardIds(),"he",self.name,"选择牌转化为【饭】")
      player:addToPile("@yz_ming_fan",cardId,true,self.name)
    elseif self.cost_data==2 then
      local flag={}
      flag.card_data ={{"@yz_ming_fan",player:getPile("@yz_ming_fan")}}
      local cardIds=room:askForCardsChosen(player,player,1,#player:getPile("@yz_ming_fan"),flag,self.name,"选择【饭】")
      room:throwCard(cardIds,self.name,player,player)
      local tosId= table.map(room:getAlivePlayers(), Util.IdMapper)
      local toIds=room:askForChoosePlayers(player,tosId,1,#cardIds,self.name..":选择玩家",self.name,true)
      for index, toid in ipairs(toIds) do
        local to=room:getPlayerById(toid)
        room:recover{
          who=to,
          num=1,
          from=player,
          skillName=self.name
        }
      end
    end
   
  end
}

local yz_ming_xianhui_maxcard=fk.CreateMaxCardsSkill{
  name="#yz_ming_xianhui_maxcard",
  correct_func=function (self, player)
    local fan=#player:getPile("@yz_ming_fan")
    local maxCard=fan//2
    local maxCardNum=fan%2
    if maxCardNum >0 then
      maxCard=maxCard+1
     end
    if player:hasSkill(self.name) then
      return maxCard
    else
      return 0
    end
    
  end

}
yz_ming_yeyuan:addRelatedSkill(yz_ming_yeyuan_damaged_1)
yz_ming_yeyuan:addRelatedSkill(yz_ming_yeyuan_damaged_2)
yz_ming_yeyuan:addRelatedSkill(yz_ming_yeyuan_reset)
yz_ming_xianhui:addRelatedSkill(yz_ming_xianhui_maxcard)
yz_ming:addSkill(yz_ming_yeyuan)
yz_ming:addSkill(yz_ming_fengmo)
yz_ming:addSkill(yz_ming_shenai)
yz_ming:addSkill(yz_ming_xianhui)
-------------------------------------------------------------------------------------------------------------------------------------
-- 真夜
local yz_zhenye=General:new(extension,"yz_zhenye","god",6,6,General.Female)
Fk:loadTranslationTable{
  ["yz_zhenye"] = "饕神真夜",
  ["#yz_zhenye"] = "饕餮",
  ["designer:yz_zhenye"] = "社恐",
  ["cv:yz_zhenye"] = "Ai配的",
  ["illustrator:yz_zhenye"] = "表情包卡面，无语",
  -- 技能翻译
  ["yz_zhenye_yongmeng"]="勇猛",
  [":yz_zhenye_yongmeng"]="当你使用【杀】指定一名角色为目标后，你可以进行一次判定，若结果为♠️，其不能使用【闪】响应此【杀】。",
  ["yz_zhenye_conghui"]="聪慧",
  ["#yz_zhenye_conghui_getcard"]="聪慧·拿来",
  [":yz_zhenye_conghui"]="锁定技，当你使用锦囊牌指定目标时，你需进行判定：<br>"..
                         "若结果为红色，你令此牌无效；<br>"..
                         "若为♠️2~9，当此牌结算结束后置入弃牌堆时，你可以获得之。",
  ["yz_zhenye_chandou"]="缠斗",
  [":yz_zhenye_chandou"]="当你成为装备区里有武器牌的其他角色使用【杀】的目标时，你可以进行判定，若结果为红色，你回复一点体力，然后弃置其装备区内的武器牌。",
  ["@yz_zhenye_eat"]="锚",
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
        data.disresponsiveList = table.map(player.room.alive_players, Util.IdMapper)
        break
      else 
        break
      end
    end
  end
}
local yz_zhenye_conghui=fk.CreateTriggerSkill{
  name="yz_zhenye_conghui",
  frequency=Skill.Compulsory,
  events={fk.TargetConfirmed},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and data.from ~=player.id
           and data.card
           and data.card.type==Card.TypeTrick

  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local judge = {
      who = player,
      reason = self.name,
      pattern = ".",
    }
    room:judge(judge)
    if judge.card and judge.card.color == Card.Red then
      self.cost_data=1
      return true
    elseif judge.card and judge.card.color==Card.Black and judge.card.number>=2 and judge.card.number <=9 then
      self.cost_data=2
      return true
    else
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    if self.cost_data==1 then
        AimGroup:cancelTarget(data, player.id)
    elseif self.cost_data==2 then
      room:setCardMark(data.card,"@yz_zhenye_eat",1)
    end
  end
}
local yz_zhenye_conghui_getcard=fk.CreateTriggerSkill{
  name="#yz_zhenye_conghui_getcard",
  frequency=Skill.Compulsory,
  events={fk.CardUseFinished},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and data.card
           and data.card:getMark("@yz_zhenye_eat")>0
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    room:obtainCard(player,data.card,true,self.name)
  end
}
local yz_zhenye_chandou=fk.CreateTriggerSkill{
  name="yz_zhenye_chandou",
  events={fk.TargetConfirmed},
  can_trigger=function (self, event, target, player, data)
    local room=player.room
    local from=room:getPlayerById(data.from)
    return player:hasSkill(self.name)
           and target == player
           and data.from ~=player.id
           and data.card
           and data.card.name == "slash"
           and #from:getCardIds("e")>0

  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local judge = {
      who = player,
      reason = self.name,
      pattern = ".",
    }
    room:judge(judge)
    if judge.card and judge.card.color == Card.Red then
      return true
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room

    room:recover{
      who=player,
      num=1,
      from=player,
      skillName=self.name
    }
    local from=room:getPlayerById(data.from) 
    local discard=room:askForCardChosen(from,player,"e",self.name,self.name..":弃置一张装备牌")
    if #discard>0 then
      room:throwCard(discard,self.name,from)
    end
    
  end
}
yz_zhenye_conghui:addRelatedSkill(yz_zhenye_conghui_getcard)
yz_zhenye:addSkill(yz_zhenye_yongmeng)
yz_zhenye:addSkill(yz_zhenye_conghui)
yz_zhenye:addSkill(yz_zhenye_chandou)
-------------------------------------------------------------------------------------------------------------------------------------
-- 白鸟	
local yz_bainiao=General:new(extension,"yz_bainiao","god",4,4,General.Female)
Fk:loadTranslationTable{
  ["yz_bainiao"] = "白鸟",
  ["#yz_bainiao"] = "机械之鸟",
  ["designer:yz_bainiao"] = "心枫",
  ["cv:yz_bainiao"] = "Ai配的",
  ["illustrator:yz_bainiao"] = "",
  -- 
  ["yz_bainiao_yazhi"]="压制",
  ["#yz_bainiao_yazhi_buff"]="压制·兵器",
  ["#yz_bainiao_yazhi_buff_clear"]="压制·缓冲",
  ["#yz_bainiao_yazhi_mod"]="压制·强化",
  [":yz_bainiao_yazhi"]="摸牌阶段，你可以进行两次判定，然后若你没有「武装」，你可将至多两种不同花色的判定牌置于你的武将牌上，称为「武装」；"..
                        "否则你可以将任意张判定牌替换等量的「武装」。（你最多拥有两张「武装」）<br>"..
                        "【压制·兵器】: 出牌阶段，你可以弃置一张与你拥有的「武装」相花色相同的牌并获得以下效果：<br>"..
                        "<font color='red'>♥️</font>:你下一次对其他角色造成的伤害+1；【无人机】<br>"..
                        "♦️:你的下一张【杀】无视防具；【激光发射器】<br>"..
                        "♣️:选择一名角色，其技能失效直到回合结束；<br>"..
                        "♠️:你弃置一名角色一张牌；<br>"..
                        -- "若你于本回合的出牌阶段内使用过四种花色的牌，你可以对一名角色造成一点伤害，然后本回合此技能失效。<br>"..
                        "",
  ["yz_bainiao_yazhi_ranhui"]="燃毁",
  ["#yz_bainiao_yazhi_ranhui_dis"]="燃毁·扩大",
  [":yz_bainiao_yazhi_ranhui"]="你的攻击范围+x（X为你已损失的体力值）。"..
          "出牌阶段，若你的体力值为1，你可以移去所有「武装」并选择一名角色，该角色失去一点体力，然后若该角色未死亡，你失去1点体力。",
  ["@yz_bainiao_wuzhuang"]="武装",
  ["@yz_bainiao_beiyong"]="备用",
  ["@yz_bainiao_wurenji"]="无人机",
  ["@yz_bainiao_jiguangfasheqi"]="激光发射器",
}
local yz_bainiao_yazhi=fk.CreateTriggerSkill{
  name="yz_bainiao_yazhi",
  anim_type = "offensive",
  events = {fk.EventPhaseStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player.phase == Player.Draw
  end,
  on_cost=function (self, event, target, player, data)
    local room =player.room
    local judge1 = {
      who = player,
      reason = self.name,
      pattern = ".",
    }
    room:judge(judge1)
    local judge2 = {
      who = player,
      reason = self.name,
      pattern = ".",
    }
    room:judge(judge2)
    if player:getPile("@yz_bainiao_wuzhuang") and #player:getPile("@yz_bainiao_wuzhuang")==0 then
      if judge1.card and judge2.card and judge1.card.suit ~= judge2.card.suit then
        player:addToPile("@yz_bainiao_wuzhuang",{judge1.card,judge2.card},true,self.name)
      elseif judge1.card and judge2.card and judge1.card.suit == judge2.card.suit then
        player:addToPile("@yz_bainiao_wuzhuang",judge1.card,true,self.name)
      end
    elseif player:getPile("@yz_bainiao_wuzhuang") and #player:getPile("@yz_bainiao_wuzhuang") > 0 then
      local choose={"yes","no"}
      local selected=room:askForChoice(player,choose,self.name,self.name..":是否更换武装",false,choose)
      if selected=="yes" then
        local flag={}
        local flagJudge={}
        flag.card_data ={{"@yz_bainiao_wuzhuang",player:getPile("@yz_bainiao_wuzhuang")}}
        local cardIds=room:askForCardsChosen(player,player,1,#player:getPile("@yz_bainiao_wuzhuang"),flag,self.name,"选择弃置【武装】")
        local num=#cardIds
        room:throwCard(cardIds,self.name,player,player)

        flagJudge.card_data={{"@yz_bainiao_wuzhuang",{judge1.card.id,judge2.card.id}}}
        local juggeCardIds=room:askForCardsChosen(player,player,1,num,flagJudge,self.name,"选择【武装】")
        player:addToPile("@yz_bainiao_wuzhuang",juggeCardIds,true,self.name)
        return true
      else
        return false
      end
       
    end
  end,
  on_use=function (self, event, target, player, data)

  end
}
local yz_bainiao_yazhi_buff=fk.CreateTriggerSkill{
  name="#yz_bainiao_yazhi_buff",
  events = {fk.EventPhaseStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player.phase == Player.Play
           and #player:getPile("@yz_bainiao_wuzhuang")>0
  end,
  -- on_cost=function (self, event, target, player, data)
    -- local room =player.room
    -- local flag={}
    -- flag.card_data ={{"@yz_bainiao_wuzhuang",player:getPile("@yz_bainiao_wuzhuang")}}
    -- local cardIds=room:askForCardsChosen(player,player,1,1,flag,self.name,"选择弃置【武装】")
    -- if #cardIds>0 then
    --   local card=Fk.getCardById(cardIds[1])
    --   self.cost_data=card.suit
    --   return true
    -- end
  -- end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    -- local card=self.cost_data
    local flag={}
    flag.card_data ={{"@yz_bainiao_wuzhuang",player:getPile("@yz_bainiao_wuzhuang")}}
    local cardIds=room:askForCardsChosen(player,player,1,1,flag,self.name,"选择弃置【武装】")
    if #cardIds>0 then
      local card=Fk:getCardById(cardIds[1])
      if card.suit==Card.Heart then
        -- 红桃  你下一次对其他角色造成的伤害+1；
          room:setPlayerMark(player,"@yz_bainiao_wurenji",1)
      
      elseif card.suit==Card.Diamond then
        -- 方块  你的下一张【杀】无视防具；
        room:setPlayerMark(player,"@yz_bainiao_jiguangfasheqi",1)
        -- 无视防具
        -- player:addQinggangTag(data)

      elseif card.suit==Card.Spade then
        -- 黑桃  选择一名角色，其技能失效直到回合结束；
        local otherPlayerId= table.map(room:getOtherPlayers(player), Util.IdMapper)
        local toIds=room:askForChoosePlayers(player,otherPlayerId,1,1,self.name..":选择分配伤害",self.name,true)
        local to=room:getPlayerById(toIds[1])
        local skills = Fk.generals[to.general]:getSkillNameList()
        for index, skill in ipairs(skills) do
          room:invalidateSkill(player,skill,"-turn")
        end
      elseif card.suit==Card.Club then
        -- 梅花  你弃置一名角色一张牌；
        local otherPlayerId= table.map(room:getOtherPlayers(player), Util.IdMapper)
        local toIds=room:askForChoosePlayers(player,otherPlayerId,1,1,self.name..":选择一个角色",self.name,true)
        local to=room:getPlayerById(toIds[1])
      
        local discard=room:askForCardChosen(to,to,"he",self.name,self.name..":弃置一张牌")
        room:throwCard(discard,self.name,to,player)
      end
      room:throwCard(card,self.name,player,player)
    end
   
  end
}
local yz_bainiao_yazhi_mod=fk.CreateTriggerSkill{
  name="#yz_bainiao_yazhi_mod",
  events={fk.TargetSpecified,fk.DamageCaused},
  can_trigger=function (self, event, target, player, data)
    if event==fk.DamageCaused then
      return player:hasSkill(self.name)
           and target==player
           and player:getMark("@yz_bainiao_wurenji")>0
    end
    if event==fk.TargetSpecified then
      return player:hasSkill(self.name)
            and target==player
            and data.card.name=="slash"
            and player:getMark("@yz_bainiao_jiguangfasheqi")>0
    end
  end,
  on_use=function (self, event, target, player, data)
    if event==fk.DamageCaused and  player:getMark("@yz_bainiao_wurenji")>0 then
      data.damage = data.damage+ 1
    elseif event==fk.TargetSpecified and player:getMark("@yz_bainiao_jiguangfasheqi")>0 then
      player:addQinggangTag(data)
    end
  end
  
}
local yz_bainiao_yazhi_buff_clear=fk.CreateTriggerSkill{
  name="#yz_bainiao_yazhi_buff_clear",
  refresh_events={fk.Damage},
  can_refresh=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and data.card
          --  and data.card.name=="slash"
           and (player:getMark("@yz_bainiao_wurenji")>0
           or player:getMark("@yz_bainiao_jiguangfasheqi")>0 )
  end,
  on_refresh=function (self, event, target, player, data)
    local room=player.room
    if player:getMark("@yz_bainiao_wurenji")>0 then
     room:setPlayerMark(player,"@yz_bainiao_wurenji",0)
    elseif player:getMark("@yz_bainiao_jiguangfasheqi")>0 and data.card.name=="slash" then
      room:setPlayerMark(player,"@yz_bainiao_jiguangfasheqi",0)
    end
  end
}

local yz_bainiao_yazhi_ranhui=fk.CreateTriggerSkill{
  name="yz_bainiao_yazhi_ranhui",
  anim_type = "offensive",
  events = {fk.EventPhaseStart},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player.phase == Player.phase
           and player.hp==1
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local otherPlayerId= table.map(room:getOtherPlayers(player), Util.IdMapper)
    local toIds=room:askForChoosePlayers(player,otherPlayerId,1,1,self.name..":选择燃毁目标",self.name,true)
    if #toIds>0 then
      self.cost_data=toIds[1]
      return true
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    local to=room:getPlayerById(self.cost_data)
    room:loseHp(to,1,self)
    if not to.dying then
      room:loseHp(player,1,self)
    end
  end
}
local yz_bainiao_yazhi_ranhui_dis=fk.CreateDistanceSkill{
    name="#yz_bainiao_yazhi_ranhui_dis",
    correct_func = function(self, from, to)
      if from:hasSkill(self) then
        return from.maxHp-from.hp
      end
    end,
}
yz_bainiao_yazhi:addRelatedSkill(yz_bainiao_yazhi_buff)
yz_bainiao_yazhi:addRelatedSkill(yz_bainiao_yazhi_mod)
yz_bainiao_yazhi:addRelatedSkill(yz_bainiao_yazhi_buff_clear)
yz_bainiao_yazhi_ranhui:addRelatedSkill(yz_bainiao_yazhi_ranhui_dis)
yz_bainiao:addSkill(yz_bainiao_yazhi)
yz_bainiao:addSkill(yz_bainiao_yazhi_ranhui)
-------------------------------------------------------------------------------------------------------------------------------------
-- 星铭千愿
local yz_qianyuan=General:new(extension,"yz_qianyuan","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_qianyuan"] = "星铭千愿",
  ["#yz_qianyuan"] = "亚巴顿",
  ["designer:yz_qianyuan"] = "抱住玩偶的希儿",
  ["cv:yz_qianyuan"] = "Ai配的",
  ["illustrator:yz_qianyuan"] = "",
  -- 
  ["yz_qianyuan_yanruo"]="剡若",
  ["#yz_qianyuan_yanruo_sha_plus"]="剡若·杀",
  ["#yz_qianyuan_yanruo_sha_clear"]="剡若",
  [":yz_qianyuan_yanruo"]="出牌阶段限一次，你可以失去一点体力，若如此做，你令你使用的下一张【杀】造成的伤害+1。",
  ["yz_qianyuan_lingyou"]="灵佑",
  [":yz_qianyuan_lingyou"]="锁定技，若你的装备区里没有防具牌， ♣️【杀】对你无效。",
  ["yz_qianyuan_yinyu"]="银羽",
  ["#yz_qianyuan_yinyu_mod"]="银羽·解放",
  ["#yz_qianyuan_yinyu_mod_clear"]="银羽·检",
  [":yz_qianyuan_yinyu"]="出牌阶段限一次，你可以进行一次判定，若结果为黑色，直到回合结束你使用【杀】无距离限制。",
  ["yz_qianyuan_changqiong"]="苍穹",
  [":yz_qianyuan_changqiong"]="出牌阶段限一次，你可以弃置两张手牌，观看一名其他角色的手牌，若如此做，你可以选择一项：<br>"..
                              "1、你回复一点体力；<br>"..
                              "	2、该角色回复一点体力。",
  ["yz_qianyuan_guangqi"]="光启",   
  ["#yz_qianyuan_guangqi_ruo"]="光启·弱化",
  ["#yz_qianyuan_guangqi_time"]="光启·计时",
  [":yz_qianyuan_guangqi"]="限定技，出牌阶段，你可以增加两点体力上限并回复两点体力，下个你的回合的结束阶段，你将你的体力值调整至1。",   
  ["@yz_qianyuan_yanruo_sha"]="剡若·杀",
  ["@yz_qianyuan_yinyu_sha"]="银羽·解放",
  ["@yz_qianyuan_guangqi_ruo"]="光启·限",
  ["@yz_qianyuan_guangqi_time"]="光启·计时",
  ["choose1"]="回复一点体力",
  ["choose2"]="该角色回复一点体力",
}
local yz_qianyuan_yanruo=fk.CreateActiveSkill{
  name="yz_qianyuan_yanruo",
  can_use=function (self, player, card, extra_data)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
           and player.hp>1
  end,
  on_use=function (self, room, data)
    local from=room:getPlayerById(data.from)
    room:loseHp(from,1,self.name)
    room:setPlayerMark(from,"@yz_qianyuan_yanruo_sha",1)
  end
}
local yz_qianyuan_yanruo_sha_plus=fk.CreateTriggerSkill{
  name="#yz_qianyuan_yanruo_sha_plus",
  events={fk.DamageCaused},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and player:getMark("@yz_qianyuan_yanruo_sha") > 0
           and data.card
           and data.card.name=="slash"
  end,
  on_use=function (self, event, target, player, data)
    data.damage=data.damage+1
  end
}
local yz_qianyuan_yanruo_sha_clear=fk.CreateTriggerSkill{
  name="#yz_qianyuan_yanruo_sha_clear",
  refresh_events={fk.Damage},
  can_refresh=function (self, event, target, player, data)
   return  player:hasSkill(self.name)
           and player:getMark("@yz_qianyuan_yanruo_sha") > 0
           and data.card
           and data.card.name=="slash"
  end,
  on_refresh=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_qianyuan_yanruo_sha",0)
  end
}
local yz_qianyuan_lingyou=fk.CreateTriggerSkill{
  name="yz_qianyuan_lingyou",
  events={fk.TargetConfirmed},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target==player
           and #player:getCardIds("e")==0
           and data.card
           and data.card.name=="slash"
           and data.card.suit==Card.Club
  end,
  on_cost=function (self, event, target, player, data)
    return true
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    AimGroup:cancelTarget(data, player.id)
  end
}
local yz_qianyuan_yinyu=fk.CreateActiveSkill{
  name="yz_qianyuan_yinyu",
  can_use=function (self, player, card, extra_data)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
  end,
  on_use=function (self, room, data)
    local from=room:getPlayerById(data.from)
    local judge = {
      who = from,
      reason = self.name,
      pattern = ".",
    }
    room:judge(judge)
    if judge.card and judge.card.color==Card.Black then
      room:setPlayerMark(from,"@yz_qianyuan_yinyu_sha",1)
    end
  end
}
local yz_qianyuan_yinyu_mod = fk.CreateTargetModSkill{
  name = "#yz_qianyuan_yinyu_mod",
  bypass_times = function(self, player, skill, scope)
    if player:hasSkill(self) and skill.trueName == "slash_skill"
      and scope == Player.HistoryPhase and player:getMark("@yz_qianyuan_yinyu_sha") > 0 then
      return true
    end
  end,
}
local yz_qianyuan_yinyu_mod_clear=fk.CreateTriggerSkill{
  name="#yz_qianyuan_yinyu_mod_clear",
  refresh_events={fk.TurnEnd},
  can_refresh=function (self, event, target, player, data)
    return player:hasSkill(self.name)
            and target==player
            and player:getMark("@yz_qianyuan_yinyu_sha")>0
  end,
  on_refresh=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_qianyuan_yinyu_sha",0)
  end

}
local yz_qianyuan_changqiong=fk.CreateActiveSkill{
  name="yz_qianyuan_changqiong",
  frequency=Skill.Compulsory,
  can_use=function (self, player, card, extra_data)
    return player:usedSkillTimes(self.name, Player.HistoryPhase) == 0
  end,
  card_num=2,
  card_filter = function(self, to_select, selected)
    return #selected < 2 and Fk:currentRoom():getCardArea(to_select) == Player.Hand and not Self:prohibitDiscard(Fk:getCardById(to_select))
  end,
  target_num=1,
  target_filter = function(self, to_select, selected)
    return #selected == 0 and #Fk:currentRoom():getPlayerById(to_select)  and to_select ~=Self.id
  end,
  on_use=function (self, room, use)
    local player = room:getPlayerById(use.from)
    local target = room:getPlayerById(use.tos[1])
    room:throwCard(use.cards, self.name, player, player)
    U.viewCards(player, target:getCardIds("h"), self.name, "看牌"..target.id)
    local choose={"choose1","choose2"}
    local selected=room:askForChoice(player,choose,self.name,self.name..":选择效果",false,choose)
    if selected=="choose1" then
      room:recover{
        who=player,
        num=1,
        from=player,
        skillName=selected.name
      }
    elseif selected=="choose2" then
      room:recover{
        who=target,
        num=1,
        from=player,
        skillName=selected.name
      }
    end
  end
}
local yz_qianyuan_guangqi=fk.CreateActiveSkill{
  name="yz_qianyuan_guangqi",
  frequency=Skill.Limited,
  can_use=function (self, player, card, extra_data)
    return player:usedSkillTimes(self.name, Player.HistoryGame) == 0
  end,
  on_use=function (self, room, data)
    local player =room:getPlayerById(data.from)
    room:setPlayerMark(player,"@yz_qianyuan_guangqi_ruo",1)
    room:changeMaxHp(player,2)
    room:changeHp(player,2)
    room:setPlayerMark(player,"@yz_qianyuan_guangqi_time",1)
  end
}
local yz_qianyuan_guangqi_ruo=fk.CreateTriggerSkill{
  name="#yz_qianyuan_guangqi_ruo",
  -- frequency=Skill.Limited,
  events={fk.AfterPhaseEnd},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
           and player.phase == Player.Discard
           and player:getMark("@yz_qianyuan_guangqi_ruo") > 0
           and player:getMark("@yz_qianyuan_guangqi_time")  == 0

  end,
  on_cost=function (self, event, target, player, data)
    return true
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_qianyuan_guangqi_ruo",0)
    room:changeHp(player,-(player.hp-1))
  end
}
local yz_qianyuan_guangqi_time=fk.CreateTriggerSkill{
  name="#yz_qianyuan_guangqi_time",
  -- frequency=Skill.Limited,
  refresh_events={fk.TurnStart},
  can_refresh=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ==player
          --  and player.phase == Player.Discard
           and player:getMark("@yz_qianyuan_guangqi_ruo") > 0
           and player:getMark("@yz_qianyuan_guangqi_time") > 0

  end,
  on_refresh=function (self, event, target, player, data)
    local room=player.room
    room:setPlayerMark(player,"@yz_qianyuan_guangqi_time",0)
  end
}
yz_qianyuan_yanruo:addRelatedSkill(yz_qianyuan_yanruo_sha_plus)
yz_qianyuan_yanruo:addRelatedSkill(yz_qianyuan_yanruo_sha_clear)
yz_qianyuan_yinyu:addRelatedSkill(yz_qianyuan_yinyu_mod)
yz_qianyuan_yinyu:addRelatedSkill(yz_qianyuan_yinyu_mod_clear)
yz_qianyuan_yinyu:addRelatedSkill(yz_qianyuan_guangqi_ruo)
yz_qianyuan_yinyu:addRelatedSkill(yz_qianyuan_guangqi_time)
yz_qianyuan:addSkill(yz_qianyuan_yanruo)
yz_qianyuan:addSkill(yz_qianyuan_lingyou)
yz_qianyuan:addSkill(yz_qianyuan_yinyu)
yz_qianyuan:addSkill(yz_qianyuan_changqiong)
yz_qianyuan:addSkill(yz_qianyuan_guangqi)
-------------------------------------------------------------------------------------------------------------------------------------
-- 绯都津璃桜		荷蒙库鲁兹
local yz_liying=General:new(extension,"yz_liying","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["yz_liying"] = "绯都津璃桜",
  ["#yz_liying"] = "荷蒙库鲁兹",
  ["designer:yz_liying"] = "抱住玩偶的希儿",
  ["cv:yz_liying"] = "Ai配的",
  ["illustrator:yz_liying"] = "",
  -- 
  ["yz_liying_tianyi"]="天翼",
  [":yz_liying_tianyi"]="锁定技，你计算与其他角色的距离视为1。",
  ["yz_liying_liancheng"]="炼成",
  [":yz_liying_liancheng"]="当一名角色于其回合内受到伤害或者失去体力后，你可以令其选择一项：<br>"..
                           "1、摸一张牌；<br>"..
                           "2、视为使用了一张【酒】。",
  ["yz_liying_liancheng_1"]="摸一张牌",
  ["yz_liying_liancheng_2"]="使用【酒】",
  ["cencle"]="取消",
  ["yz_liying_miuhuan"]="缪环",
  ["#yz_liying_miuhuan_get"]="缪环",
  [":yz_liying_miuhuan"]="弃牌阶段弃置手牌后，你获得x枚「缪环」标记（x为弃置的手牌数）。你最多拥有3枚「缪环」标记。"..
                         "出牌阶段，你可以移去一枚「缪环」标记，令一名角色摸一张牌。",
  ["yz_liying_zhinao"]="智脑",
  ["#yz_liying_zhinao_getsha"]="智脑",
  [":yz_liying_zhinao"]="当你成为【杀】的目标时，你可以进行一次判定，若结果为红色，该【杀】对你无效。"..
                        "其他角色的出牌阶段开始时，你可以弃置一张手牌，并令其从牌堆中获得一张【杀】。",

  ["@yz_liying_miuhuan_mark"]="缪环"
}
local yz_liying_liancheng=fk.CreateTriggerSkill{
  name="yz_liying_liancheng",
  events={fk.Damaged,fk.HpLost},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
  end,
  on_cost=function (self, event, target, player, data)
    local room=player.room
    local choose={"yz_liying_liancheng_1","yz_liying_liancheng_2","cencle"}
    local selected=room:askForChoice(target,choose,self.name,self.name..":选择效果",false,choose)
    if selected=="yz_liying_liancheng_1" then
      self.cost_data=1
      return true
    elseif selected=="yz_liying_liancheng_2" then
      self.cost_data=2
      return true
    elseif selected=="cencle" then
      return false
    end
  end,
  on_use=function (self, event, target, player, data)
    local room=player.room
    if self.cost_data == 1 then
      target:drawCards(1,self.name,"top")
    elseif self.cost_data == 2 then  
      local card= Fk:cloneCard("analeptic")
      room:useCard({from=player.id,tos={{target.id}},card=card})
    end
  end
}
local yz_liying_miuhuan_get=fk.CreateTriggerSkill{
  name="#yz_liying_miuhuan_get",
  events={fk.AfterCardsMove},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
          --  and target ==player
           and player.phase==Player.Discard
  end,
  on_lose=function (self, player, is_death)
    return true
  end,
  on_use=function (self, event, target, player, data)
    local room = player.room
    local n = 0
    local miuhuan=player:getMark("@yz_liying_miuhuan_mark")
    for _, move in ipairs(data) do
      if move.from == player.id and move.moveReason == fk.ReasonDiscard then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerHand then
            n = n + 1
          end
        end
      end
    end
    if miuhuan+n<=3 then
      room:setPlayerMark(player, "@yz_liying_miuhuan_mark", miuhuan+n)
    elseif miuhuan+n>3 then
      room:setPlayerMark(player, "@yz_liying_miuhuan_mark",3)
    -- elseif miuhuan+n > 3 then
    --   room:addPlayerMark(player, "@yz_liying_miuhuan_mark",3)
    end
  end
}
local yz_liying_miuhuan=fk.CreateActiveSkill{
  name="yz_liying_miuhuan",
  can_use=function (self, player, card, extra_data)
    return player:getMark("@yz_liying_miuhuan_mark")>0
  end,
  target_num=1,
  target_filter=function (self, to_select, selected, selected_cards, card, extra_data)
    return #selected == 0 and #Fk:currentRoom():getPlayerById(to_select)  
  end,
  on_use=function (self, room, data)
    local from=room:getPlayerById(data.from)
    local to=room:getPlayerById(data.tos[1])
    room:removePlayerMark(from,"@yz_liying_miuhuan_mark",1)
    to:drawCards(1,self.name,"top")
  end
}
local yz_liying_zhinao=fk.CreateTriggerSkill{
  name="yz_liying_zhinao",
  events={fk.TargetConfirmed},
  can_trigger=function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target == player
           and data.card
           and data.card.name == "slash"
  end,
  on_cost=function (self, event, target, player, data)
    local room =player.room
    local judge = {
      who = player,
      reason = self.name,
      pattern = ".",
    }
    room:judge(judge)
    if judge.card and judge.card.color == Card.Red then
      return true
    end
  end,
  on_use=function (self, event, target, player, data)
    AimGroup:cancelTarget(data,player.id)
  end
}
local yz_liying_zhinao_getsha=fk.CreateTriggerSkill{
  name="#yz_liying_zhinao_getsha",
  events={fk.EventPhaseStart},
  can_trigger =function (self, event, target, player, data)
    return player:hasSkill(self.name)
           and target ~=player
           and target.phase == Player.Play
           and not player:isKongcheng()
  end,
  on_use=function (self, event, target, player, data)
    local room =player.room
    local discard=room:askForDiscard(player,1,1,false,self.name,false)
    print("111")
    local sha= room:getCardsFromPileByRule("slash",1,"allPiles")
    if #sha>0 then
      room:obtainCard(target,sha[1],true)
    end
    
  end
}
yz_liying_miuhuan:addRelatedSkill(yz_liying_miuhuan_get)
yz_liying_zhinao:addRelatedSkill(yz_liying_zhinao_getsha)
yz_liying:addSkill(zz_tianyi)
yz_liying:addSkill(yz_liying_liancheng)
yz_liying:addSkill(yz_liying_miuhuan)
yz_liying:addSkill(yz_liying_zhinao)
return extension