require("src/lib/magic") -- outlines technicalities of magic
btoi={ [true]=1, [false]=0 }

default = 5000; --default value of genetic stats b4 mods
--PERFECT sl/fst/sl FORMULA, meets (0,0),(0.5,1),(1,0):
--  y = (3x-(4x^2+x)) ; can be adjusted via factors
--[[
if math.floor(player.age) > currentage then
    age = math.floor(player.age)
    power = power*(1+(((3*age)-((4*age)^2+age))/2))
end
]]

creature = {
    x = 1,
    y = 1,
    maxhp = 100,
    age = 1,
    stats = {
        power = 1, --all life is born with power = 1 * powermod
        iq = default,
        sight = default,
        smell = default,
        taste = default,
        hearing = default,
        touch = default,
        flex = default,
        size = default,
        strength = default,
        leverage = default,
        mana = default,
        intel = default,
        esp = default,
        affinity = {
            heat = default,
            null = default,
            space = default,
            motion = default,
            force = default
        }
    },
    genes = {
        powermod = 1,
        iq = 1,
        sight = 1,
        smell = 1,
        taste = 1,
        hearing = 1,
        touch = 1,
        esp = 1,
        magical = 1,
        mana = 1,
        flex = 1,
        size = 1,
        strength = 1,
        leverage = 1,
        affinity = {
            heat = 1,
            null = 1,
            space = 1,
            motion = 1,
            force = 1
        }
        -- NO INTEL GENE (knowledge is complex and situational)
    },
    skills = {}
}


-- COULD do this procedurally, but would be unnecessarily complex
function creature:new(type,statstable)
    local o = statstable or {}
    setmetatable(o, self)
    self.__index = self
    o.name = tostring(type)
    o.stats.power = o.stats.power*(1+(((3*o.age)-((4*o.age)^2+o.age))/2))*o.genes.powermod
    o.stats.power = math.abs(o.stats.power*btoi[o.stats.power >= 0])
    o.stats.iq = o.stats.iq*o.genes.iq
    o.stats.sight = o.stats.sight*o.genes.sight
    o.stats.smell = o.stats.smell*o.genes.smell
    o.stats.hearing = o.stats.hearing*o.genes.hearing
    o.stats.touch = o.stats.touch*o.genes.touch
    o.stats.mana = (((o.stats.iq/2))^2)*((o.stats.touch/o.stats.strength)^2)*o.genes.mana*(o.genes.magical)
    o.stats.size = o.stats.size*o.genes.size
    o.stats.leverage = (default/o.stats.size)*o.stats.leverage*o.genes.leverage
    o.stats.flex = (o.stats.flex*o.genes.flex)-(o.stats.flex/o.stats.size)
    o.stats.intel = ((o.stats.iq/default)*((o.stats.sight+(o.stats.smell/20)+(o.stats.hearing/2)+(o.stats.taste/2)+(o.stats.touch*0.7)+flr(o.stats.iq/2000)+(o.stats.mana/10))/default))
    o.stats.esp = math.floor(o.stats.iq/2000)+math.floor(o.stats.intel)*o.genes.esp
    o.maxhp = (o.maxhp-(o.stats.flex/3))*o.stats.power
    o.hp = o.maxhp
    for i=1,#o.stats.affinity do
        o.stats.affinity = o.stats.affinity*o.genes.affinity
    end
    return o

end

Player = creature:new()

function advanceAge(creature) -- the idea here is that you age faster the older you are, bodily age
                        -- being different than how old you are in time
    if math.floor(Player.age) > currentage then
        Player.age = math.floor(Player.age)
        Player.stats.power = Player.stats.power*(1+(((3*Player.age)-((4*Player.age)^2+Player.age))/2))
        Player.stats.intel = Player.stats.intel+( (Player.stats.iq/10)*(Player.stats.intel/(age*10)) )
    end
end


