CMDS = {
    [" "] = "print('(please enter a valid command)');",
    ["quit"] = "quit = true;",
    ["refresh"] = [[
        blankerr();
        local args = getargs(cmd);
        local filename = table.remove(args,1);
        --TODO: refresh local data by reloading libraries and userdata
    ]],
    ["menu"] = [[startmenu:open();]],
    ["showcmd"] = [[
        print("Showing commands");
        local cmds = CMDS;
        showtable(CMDS);
    ]],
    ["addcmd"] = [[
        local args = getargs(cmd);
        local commandname = table.remove(args, 1);
        print("MAKING ARGLESS FUNCTION " .. commandname .. "() , code:");
        addcommand(commandname, table.concat(args, " "));
        print(CMDS[commandname]);
    ]],
    ["func"] = [[
        local args = getargs(cmd);
        local commandname = table.remove(args, 1);
        print("MAKING FUNCTION " .. commandname .. " , code:");
        for line in gmch(table.concat(args, "[^;]+")) do
            print(line);
        end;
        addcommand(commandname, table.concat(args, " "));
    ]],
    ["alias"] = [[
        local args = getargs(cmd);
        local alias = table.remove(args, 1);
        addalias(alias, args);
    ]],
    ["cast"] = [[
        local args = getargs(cmd);
        castspell(args);
    ]],
    ["last"] = [[
        if (last_cmd ~= cmd) then cmd = last_cmd end;
        docommand(cmd);
    ]]
}

function docommand(cmdtable)
    return load( CMDS[cmd[1]], "User Command" )() or "none"
end
function addcommand(commandstring, codestring)
    CMDS[commandstring] = codestring;
end

function addalias(alias, target)
    CMDS[alias] = CMDS[target];
end
function getargs(input)
    local args = input
    table.remove(args,1)
    return args
end
function checkcmd(command)
    local check_valid = {[true] = command, [false] = " "};
    return check_valid[CMDS[command] ~= nil];
end
function cmderror(text) 
    rgbprint(text,{102,102,51},{150,20,20})
end
function castspell(args)
    local name = args[1]
    if name == "fireball" then
        draw_fireball()
        slp()
    end
end