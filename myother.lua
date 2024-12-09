local extension = Package:new("myother")

extension.extensionName = "yhdzz"

Fk:loadTranslationTable{
    ["myother"] = "夹的私货",
   
  }
local fgo_yaolan=General:new(extension,"fgo_yaolan","god",3,3,General.Female)
local fgo_yaolan_huguang=fk.CreateActiveSkill{
  name="fgo_yaolan_huguang",
  can_use=function (self, player, card, extra_data)
    
  end,
  on_use=function (self, room, cardUseEvent)
    
  end
}
return extension