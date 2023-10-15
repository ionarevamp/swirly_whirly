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
    exit = "'Quit'"
}
function startmenu:open()
    self.state = 1
end
function startmenu:close()
    self.state = 0
end


charskills = {
    state = 0,
    -- Come up with more/better skill names...
    skillnames = {
    },
    skills = {
    }
}

--populate skill data
local skilldata = io.open("skills.list")
for i=1,#(charskills.skillnames) do 
    load(conc("charskills.skills[i] = {",destring(charskills.skillnames[i]),"=",charskills.skillnames[i],"}"))
end
--^^ should result in `skills = {{skill_name = false}, ...}` 
function sname(skill)
    return charskills.skills[skill]
end

function learnskill(skill) 
    player.skills[skill] = true;
end
function forgetskill(skill)
    player.skills[skill] = false;
end
itemui = {
    state = 0,
}

