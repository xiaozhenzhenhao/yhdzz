
-- 声明子扩展包为约会大作战
local yuezhansha = require "packages/yhdzz/yuezhansha"
local myother=require "packages.yhdzz.myother"
local yz_sp=require "packages.yhdzz.yz_sp"
Fk:loadTranslationTable{
    -- 翻译子扩展包
    ["yhdzz"] = "约会大作战",
   
  }
return {
    yuezhansha,
    myother,
    yz_sp
}