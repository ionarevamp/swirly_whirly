dofile("src/lib/spells.lua")
function castspell(spell,mana,...)
    if not (spell ~= nil or mana ~= nil) and not (args ~= nil) then
        cmderror("Incomplete arguments.")
        return ;
    end
    
end