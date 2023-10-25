CMDS = {
    [" "] = "print(\"(please enter a valid command)\")",
    ["quit"] = "quit = true",
    ["menu"] = "startmenu:open()",
    ["showcmd"] = "print(\"Showing commands\");local cmds = CMDS;"..
	"showtable(CMDS)",
    ["addcmd"] = conc(
        "local args = cmd;",
        "table.remove(args,1);",
	"local commandname = table.remove(args,1);",
	"print(conc(\"MAKING ARGLESS FUNCTION \",commandname,\"() , code:\"));",
        "addcommand(commandname,table.concat(args,\" \"));"
    ),
    ["func"] = conc(
	"local args = cmd;",
        "table.remove(args,1);",
        "local commandname = table.remove(args,1);",
        "print(conc(\"MAKING FUNCTION \",commandname,\" , code:\"));",
        "for line in gmch(table.concat(args, \"[^;]+\" do ",
          "print(line);",
        "end;",
        "addcommand(commandname,table.concat(args,\" \"))"
    ),
    ["alias"] = conc(
	"local args = cmd;",
	"table.remove(args,1);",
	"local alias = table.remove(args,1);",
	"addalias(alias,unpack(args))"
    )
}

function addcommand(commandstring,codestring)
    CMDS[commandstring] = loadstring(codestring)
end
function addalias(alias,target)
    CMDS[alias] = CMDS[target]
end
function checkcmd(command)
    local check_valid = {[true]=command,[false]=" "}
    local cmdexists = false
    return check_valid[CMDS[command] ~= nil]
end
