require("src/lib/buffer")
require("src/lib/strings")
require("src/lib/stats")

--TODO add these basic menus:
--[[
    start
    character
        - skills/stats
    item
]]


startmenu = {
    state = 0,
    begin = "'Begin' game",
    load = "'Load' save",
    options = "'Options' and settings",
    exit = "'Quit' / exit",
    optioncount = 4,
}
racenames = {
    "human","wild elf","luminant","dwarf"
}
racedata = {}
backgroundnames = {
    "((Feature not yet implemented))"
}
playerstatus = {
    {"Health","Stamina","Mana",
    "Heat","Null","Space","Motion","Force"},
    {Player.hp,Player.ep,Player.sp,
    Player.stats.affinity.heat,Player.stats.affinity.null,
    Player.stats.affinity.space,Player.stats.affinity.motion,Player.stats.affinity.force}
}

function startmenu:open()
    self.state = 1
    dofile("src/startmenu.lua")
end
function startmenu:close()
    self.state = 0
end

charskills = {
    state = 0,
    -- Come up with skill names...
    skillnames = {
    },
    skills = {
    }
}

--populate skill data
-- local skilldata = io.lines("src/lib/skills.list")
for i=1,#(charskills.skillnames) do 
    load(
        conc( "charskills.skills[i] = {",
        destring(charskills.skillnames[i]),
        "= ",charskills.skillnames[i],"}" )
    )()
end
--^^ should result in `skills = {{skill_name = false}, ...}` 
function sname(skill)
    return charskills.skills[skill]
end

function learnskill(skill) 
    Player.skills[skill] = true;
end
function forgetskill(skill)
    Player.skills[skill] = false;
end
itemui = {
    state = 0,
}

