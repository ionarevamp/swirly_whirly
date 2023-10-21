CMDS = {
    ["quit"] = load("quit = true"),
    ["menu"] = load("startmenu:open()"),
    ["addcommand"] = load(conc(
        "local args = cmd;",
        "table.remove(args,1);",
        "addcommand(args[1],args[2])"
    ))
}
function addcommand(commandstring,codestring)
    CMDS[commandstring] = load(codestring)
end
function exec_command(commandstring)
    pcall(CMDS[commandstring])
end