local extension = Package:new("myother")

extension.extensionName = "yhdzz"

Fk:loadTranslationTable{
    ["myother"] = "小萝莉 ",
   
  }
local fgo_yaolan=General:new(extension,"fgo_yaolan","god",3,3,General.Female)
Fk:loadTranslationTable{
  ["fgo_yaolan"] = "美露辛",
  ["#fgo_yaolan"] = "最后之龙",
  ["designer:fgo_yaolan"] = "匿名",
  ["cv:fgo_yaolan"] = "真寻",
  ["illustrator:fgo_yaolan"] = "FGO",

  ["fgo_yaolan_huguang"]="湖光",
  [":fgo_yaolan_huguang"]="杀指定目标时无视防具",
  ["fgo_yaolan_longlu"]="龙炉",
  [":fgo_yaolan_longlu"]="使用杀的次数+1,手牌上限+2",
  ["fgo_yaolan_tongtiao"]="同调",
  [":fgo_yaolan_tongtiao"]="与其它玩家的距离始终为1"

}
local fgo_yaolan_huguang=fk.CreateActiveSkill{
  name="fgo_yaolan_huguang",
  can_use=function (self, player, card, extra_data)
    
  end,
  on_use=function (self, room, cardUseEvent)
    
  end
}
local fgo_paomo=General:new(extension,"fgo_paomo","god",4,4,General.Female)
Fk:loadTranslationTable{
  ["fgo_paomo"] = "泡馍",
  ["#fgo_paomo"] = "夏日缤纷第六天魔王",
  ["designer:fgo_paomo"] = "匿名",
  ["cv:fgo_paomo"] = "泡馍",
  ["illustrator:fgo_paomo"] = "FGO",

  ["fgo_paomo_mowang"]="魔王",
  [":fgo_paomo_aiyu"]="无法成为锦囊牌目标，受到的伤害+1",
  ["fgo_paomo_aiyu"]="爱欲",
  [":fgo_yaolan_longlu"]="出牌阶段开始时，每回合限一次，选择一名玩家，其翻面",
  ["fgo_yaolan_wuxingzhe"]="无形",
  [":fgo_yaolan_tongtiao"]="锁定技，濒死时判定，如果为基本牌回复一点体力"

}

return extension