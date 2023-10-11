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
        "Punch",
        "Kick",
        "Roundhouse kick",
        "Hook punch",
        "Side kick",
        "Back fist",
        "Elbow strike",
        "Knee strike",
        "Low kick",
        "High kick",
        "Upper cut punch",
        "Spinning back kick",
        "Palm strike",
        "Sweeping kick",
        "Hammer fist",
        "Front snap kick",
        "Knife-hand strike",
        "Front elbow strike",
        "Reverse punch",
        "Axe kick",
        "Back kick",
        "Spinning hook kick",
        "Back elbow strike",
        "Jumping front kick",
        "Jumping roundhouse kick".
    },
    skills = {

    }
}
for i=1,#skillnames do --populate skill data
    load(concat("charskills.skills[i] = {",destring(skillnames[i]),"=",skillnames[i],"}"))
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

