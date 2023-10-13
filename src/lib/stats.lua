require("src/lib/magic") -- outlines technicalities of magic
bc={ [true]=1, [false]=0 }

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
    age = 1,
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
        size = 1,
        strength = 1,
        leverage = 1,
        flex = 1,
        affinity = {
            heat = 1, -- "fire"
            null = 1, -- "ice"
            space = 1, -- "warp"
            motion = 1, -- "wind"
            force = 1, -- "earth" or "solid"
        }
        -- NO INTEL GENE
    }
    stats = {
        power = 1, --all life is born with power = 1 * powermod
        iq = default,
        sight = default,
        smell = default,
        taste = default,
        hearing = default,
        touch = default,
        size = default,
        strength = default,
        leverage = (default/size)*default,
        mana = (((iq/2))^2)*((touch/strength)^2),
        intel = ((iq/default)*((sight+(smell/20)+(hearing/2)+(taste/2)+(touch*0.7)+math.floor(iq/2000)+(mana/10))/default)), --Knowledge is situational
        esp = math.floor(iq/2000)+math.floor(intel),
        flex = default --needs to be a fairly wide-ranging stat
    },
    skills = {}
}

function creature:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    o.stats.power = o.stats.power*(1+(((3*o.age)-((4*o.age)^2+o.age))/2))*o.genes.powermod
    o.stats.iq = o.stats.iq*o.genes.iq
    o.stats.sight = o.stats.sight*o.genes.sight
    o.stats.smell = o.stats.smell*o.genes.smell
    o.stats.hearing = o.stats.hearing*o.genes.hearing
    o.stats.touch = o.stats.touch*o.genes.touch
    o.stats.esp = o.stats.esp*o.genes.esp
    o.stats.mana = o.stats.mana*o.genes.mana*(o.genes.magical)
    o.stats.size = o.stats.size*o.genes.size
    o.stats.leverage = o.stats.leverage*o.genes.leverage
    o.stats.flex = (o.stats.flex*o.genes.flex)-(o.stats.flex/o.stats.size)

    return o

end
function creature:grow()

Player = creature:new()

function advanceAge()
    if math.floor(Player.age) > currentage then
        Player.age = math.floor(Player.age)
        Player.power = Player.power*(1+(((3*Player.age)-((4*Player.age)^2+Player.age))/2))
    end
end
function toggle(boolval)
    local opposite = {[true]=false,[false]=true}
    return opposite[boolval];
end