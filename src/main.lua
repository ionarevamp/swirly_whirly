require("src/lib/init")
rgbwr("FUNCTIONS LOADED\n",{140,120,100})
-- rgb functions take colors as tables

memcount();slp(0.5)
function main()
  for i=0,HEIGHT do io.write() end
  clr()
  savecursor()
  slp()
  tobuffer(WIDTH-5,10,"Print test 1",CLR.red)
  print("Print test 2")
  printscreenbuf()
  tobuffer(30,11,"Print test 2",CLR.blue)
  printlinebuf(11)
  slp()
  dofile("src/intro.lua")
  c_print("Press Enter key to start",CENTER[2])
  memcount()
  mcr(CENTER[2]);io.flush();  
  io.read()
  io.write(conc("\027[2J\027[1;1H","Debug msg: Preparing...\n"))
  slp()
  
  -- START MENU
  -- dofile("src/startmenu.lua")

  -- MAIN LOOP --  --  -- MAIN LOOP --
  local input_buf = {}
  clr()
  rgbreset()
  quit = 0
  last_cmd = {}
  local defaultBG = {200,180,180}
  while (quit == 0) do
    local tinsert = table.insert
    gc[collectgarbage("count") > MEMLIMIT]()
    rgbreset()
    loadcursor()
    clr()
    --TODO: playable version should automatically enter
    --  startmenu
    gameprompt("What would you like to do?",
      CLR.darkgray,
      defaultBG
    )
    dofile("src/lib/spellgfx.lua")
    dofile("src/lib/commands.lua")
    memcount()
    
    cmd = {}
    cur_input = io.read()
    for word in gmch(cur_input,"%S+") do
      tinsert(cmd,word)
    end
    loadcursor()
    clr()
    -- dofile("memorytest.lua")
    -- dofile("memorytest.lua")
    mcu()
    cmd[1] = checkcmd(cmd[1]) -- (check if command exists)
    returnval = docommand(cmd) -- (execute command) -- refers to CMDS table, commands.lua
    if (cmd[1] ~= "last") then
      last_cmd = cmd
    end
  end
  ::game_end::
end

loadcursor()
clr()
main()
memcount()
print("Reached end. Reverse flag table: "..reverse_flags);
print(conc(startmenu.state,charskills.state,itemui.state))
-- os.execute("stty "..reverse_flags) -- at end of program, put TTY back to normal mode

